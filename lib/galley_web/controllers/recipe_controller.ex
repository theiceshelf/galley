defmodule GalleyWeb.RecipeController do
  use GalleyWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"ingredient" => ingredient_params}) do
  end
end
