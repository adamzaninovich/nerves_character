defmodule NervesCharacter.Application do
  @moduledoc false

  use Application
  require Logger

  @doc false
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: NervesCharacter.Supervisor]
    main_viewport_config = Application.get_env(:nerves_character, :viewport)
    children = [{Scenic, viewports: [main_viewport_config]}]

    start_wifi_wizard_when_needed()

    Supervisor.start_link(children, opts)
  end

  if Application.get_env(:nerves_character, :target) == :host do
    defp start_wifi_wizard_when_needed() do
      Logger.debug("Target is host, skipping VintageNetWizard")
    end
  else
    defp start_wifi_wizard_when_needed() do
      if should_start_wizard?() do
        Logger.info("VintageNetWizard starting")
        VintageNetWizard.run_wizard(on_exit: {__MODULE__, :handle_wizard_exit, []})
      else
        Logger.debug("wlan0 configured, skipping VintageNetWizard")
      end
    end

    @doc false
    def handle_wizard_exit() do
      Logger.info("VintageNetWizard stopped")
    end

    defp should_start_wizard? do
      "wlan0" not in VintageNet.configured_interfaces()
    end
  end
end
