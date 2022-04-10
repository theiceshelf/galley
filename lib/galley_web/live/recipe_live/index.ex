defmodule GalleyWeb.RecipeLive.Index do
  use GalleyWeb, :live_view

  alias Galley.Recipes
  alias Galley.Recipes.Recipe

  @impl true
  def mount(_params, _session, socket) do
    state = %{
      recipes: list_recipes(),
      formState: 0
    }
    {:ok, assign(socket, state)}

  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipes")
    |> assign(:recipe, nil)
  end

  defp list_recipes do
    Recipes.list_recipes()
  end
end