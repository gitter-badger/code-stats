defmodule CodeStats.Machine do
  use CodeStats.Web, :model
  alias Comeonin.Bcrypt

  schema "machines" do
    field :name, :string
    field :api_salt, :string

    belongs_to :user, CodeStats.User
    has_many :pulses, CodeStats.Pulse

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name, name: :machines_name_user_id_index)
    |> put_change(:api_salt, generate_api_salt())
  end

  @doc """
  Creates a changeset to regenerate the API salt of the Machine.

  Takes no input.
  """
  def api_changeset(model) do
    model
    |> change(%{api_salt: generate_api_salt()})
  end

  defp generate_api_salt() do
    Bcrypt.gen_salt()
  end
end