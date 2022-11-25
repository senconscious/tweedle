defmodule TweedleWeb.User.ReplyView do
  use TweedleWeb, :view

  def render(template, %{reply: reply}) when template in ["create.json", "update.json"] do
    %{
      data: render_one(reply, __MODULE__, "reply.json")
    }
  end

  def render("delete.json", %{reply: reply}) do
    %{
      data: %{
        id: reply.id,
        parent_id: reply.parent_id
      }
    }
  end

  def render("reply.json", %{reply: reply}) do
    %{
      id: reply.id,
      message: reply.message,
      author_id: reply.author_id,
      parent_id: reply.parent_id,
      inserted_at: reply.inserted_at,
      updated_at: reply.updated_at
    }
  end
end
