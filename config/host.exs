use Mix.Config

config :nerves_character, :viewport, %{
  name: :main_viewport,
  default_scene: {NervesCharacter.Scene.Character, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :nerves_character"]
    }
  ]
}
