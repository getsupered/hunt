defmodule HuntWeb.Ueberauth do
  @behaviour Plug

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, opts) do
    conn
    |> Ueberauth.call(Ueberauth.init(opts))
  end
end
