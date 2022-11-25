defmodule TweedleWeb.User.ReplyController do
  use TweedleWeb, :controller

  alias Tweedle.Tweeds

  def create(conn, %{"tweed_id" => tweed_id, "reply" => params}) do
    %{id: author_id} = conn.assigns.current_user

    reply = Tweeds.create_reply!(author_id, tweed_id, params)

    render(conn, "create.json", reply: reply)
  end

  def update(conn, %{"id" => id, "reply" => params}) do
    reply = Tweeds.update_tweed!(id, params)

    render(conn, "update.json", reply: reply)
  end

  def delete(conn, %{"id" => id}) do
    reply = Tweeds.delete_tweed!(id)

    render(conn, "delete.json", reply: reply)
  end
end
