defmodule Hunt.Repo do
  use Ecto.Repo,
    otp_app: :hunt,
    adapter: Ecto.Adapters.Postgres
end
