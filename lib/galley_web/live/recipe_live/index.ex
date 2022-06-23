defmodule GalleyWeb.RecipeLive.Index do
  use GalleyWeb, :live_view

  alias Galley.Recipes

  @impl true
  def mount(_params, _session, socket) do
    state = %{
      recipes: list_recipes(),
      search_query: "",
      search_filter: "All",
      search_tags: "",
      page_heading: "Recipes"
    }

    {:ok, assign(socket, state)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    user_id = socket.assigns.current_user.id

    socket =
      socket
      |> assign(:recipes, Recipes.search_recipes(search, user_id))
      |> assign(:search_filter, search["filter"])
      |> assign(:search_query, search["query"])
      |> assign(:search_tags, search["tags"])
      |> assign(
        :page_heading,
        case search["filter"] do
          "My Recipes" -> "My Recipes"
          "" -> "Recipes"
        end
      )

    {:noreply, socket}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Galley - Recipes")
    |> assign(:recipe, nil)
  end

  defp list_recipes do
    Recipes.list_recipes()
  end
end
