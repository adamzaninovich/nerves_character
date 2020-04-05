use Mix.Config

config :hello_nerves, :viewport, %{
  name: :main_viewport,
  default_scene: {HelloNerves.Scene.Character, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :hello_nerves"]
    }
  ]
}
