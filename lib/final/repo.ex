defmodule Final.Repo do
  use Ecto.Repo,
    otp_app: :final,
    adapter: Ecto.Adapters.Postgres
end
