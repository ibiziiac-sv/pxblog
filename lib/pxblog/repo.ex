defmodule Pxblog.Repo do
  use Ecto.Repo,
    otp_app: :pxblog,
    adapter: Ecto.Adapters.Postgres
end
