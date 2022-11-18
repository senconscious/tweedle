defmodule TweedleWeb.ErrorView do
  use TweedleWeb, :view

  alias Ecto.InvalidChangesetError
  alias TweedleWeb.ChangesetView

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".

  def render("422.json", %{reason: %InvalidChangesetError{changeset: changeset}}) do
    ChangesetView.render("error.json", changeset: changeset)
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
