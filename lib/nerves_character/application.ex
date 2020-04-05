defmodule NervesCharacter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NervesCharacter.Supervisor]

    children =
      [
        # Children for all targets
        # Starts a worker by calling: NervesCharacter.Worker.start_link(arg)
        # {NervesCharacter.Worker, arg},
      ] ++ children(target())

    if target() != :host and should_start_wizard?() do
      Logger.info("VintageNetWizard starting")
      VintageNetWizard.run_wizard(on_exit: {__MODULE__, :handle_wizard_exit, []})
    else
      Logger.error("wlan0 configured, skipping VintageNetWizard")
    end

    Supervisor.start_link(children, opts)
  end

  def handle_wizard_exit() do
    Logger.info("VintageNetWizard stopped")
  end

  def should_start_wizard? do
    "wlan0" not in VintageNet.configured_interfaces()
  end

  # List all child processes to be supervised
  def children(:host) do
    main_viewport_config = Application.get_env(:nerves_character, :viewport)

    [
      {Scenic, viewports: [main_viewport_config]}
    ]
  end

  def children(_target) do
    main_viewport_config = Application.get_env(:nerves_character, :viewport)

    [
      {Scenic, viewports: [main_viewport_config]}
    ]
  end

  def target() do
    Application.get_env(:nerves_character, :target)
  end
end
