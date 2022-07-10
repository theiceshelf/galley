defmodule GalleyWeb.RecipeLive.Index do
  use GalleyWeb, :live_view

  alias Galley.Recipes

  @recipe_filters [
    "All",
    "My Recipes",
    "Under an hour",
    "Under 30 minutes",
    "Recently posted",
    "My favourites"
  ]

  @impl true
  def mount(_params, _session, socket) do
    state = %{
      recipes: [],
      search_query: "",
      search_filter: "All",
      search_tags: "",
      page_heading: "Recipes",
      tags: ["spicy", "vegan", "easy"],
      taggings: []
    }

    {:ok, assign(socket, state)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    query = params |> Map.get("query", "")
    filter = params |> Map.get("filter", "")
    tags = params |> Map.get("tags", "")

    user_id = socket.assigns.current_user.id

    recipes =
      Recipes.search_recipes(%{"query" => query, "tags" => tags, "filter" => filter}, user_id)

    tagged =
      if tags !== "" do
        "tagged with: #{tags}"
      end

    page_heading = fn ->
      l = recipes |> length

      res =
        case filter do
          "My Recipes" -> "Your recipes"
          "Under an hour" -> "Recipes under an hour"
          "Under 30 minutes" -> "Recipes under 30 minutes"
          "Recently posted" -> "Recipes posted in the last 2 weeks"
          _ -> "Recipes"
        end

      "#{res} #{if tags, do: tagged} (#{l})"
    end

    socket =
      socket
      |> assign(:recipes, recipes)
      |> assign(:search_filter, filter)
      |> assign(:search_query, query)
      |> assign(:search_tags, tags)
      |> assign(:page_heading, page_heading.())

    {:noreply, socket}

    # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def get_recipe_filters() do
    @recipe_filters
  end

  @impl true
  def handle_event(
        "search-params",
        %{"search" => %{"query" => query, "filter" => filter, "tags" => tags}},
        socket
      ) do
    IO.inspect(tags, label: ">>>>>>>>>> tags")

    {:noreply,
     push_patch(socket,
       to: Routes.recipe_index_path(socket, :index, query: query, tags: tags, filter: filter)
     )}
  end
end
