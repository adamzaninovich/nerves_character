defmodule NervesCharacter.Scene.Character do
  use Scenic.Scene

  alias Scenic.Graph
  alias NervesCharacter.Character

  import Scenic.Primitives
  import Scenic.Components

  @center 400
  @button_width 700
  @button_left @center - @button_width / 2
  @fucks_on_by_default false

  @toggle_theme %{
    text: {164, 54, 51},
    border: {164, 54, 51},
    # :light_coral,
    thumb: :black,
    # :light_coral,
    focus: :black,
    background: :black,
    active: {164, 54, 51}
  }

  @graph Graph.build(font_size: 32, font: :roboto)
         |> group(
           &text(&1, "heading", text_align: :center, id: :heading),
           translate: {@center, 70}
         )
         |> group(
           &text(&1, "character", text_align: :center, id: :body),
           translate: {@center, 195},
           font_size: 36
         )
         |> group(
           &button(&1, "response",
             button_font_size: 32,
             theme: @toggle_theme,
             id: :response,
             width: @button_width
           ),
           translate: {@button_left, 370}
         )
         |> group(
           fn graph ->
             graph
             |> text("fucks?", id: :fuck_text, hidden: not @fucks_on_by_default)
             |> toggle(@fucks_on_by_default,
               id: :fuck,
               theme: @toggle_theme,
               translate: {66, -8}
             )
           end,
           translate: {712, 470},
           font_size: 24,
           scale: 0.75
         )

  # --------------------------------------------------------
  def init(_args, opts) do
    character = Character.new()

    graph = update_graph(@graph, @fucks_on_by_default, character)

    state = %{
      viewport: opts[:viewport],
      fucks: @fucks_on_by_default,
      character: character,
      graph: graph
    }

    {:ok, state, push: graph}
  end

  def filter_event({:click, :response}, _pid, state) do
    character = Character.new()
    graph = update_graph(state.graph, state.fucks, character)

    {:noreply, %{state | character: character, graph: graph}, push: graph}
  end

  def filter_event({:value_changed, :fuck, fucks}, _pid, state) do
    graph =
      state.graph
      |> Graph.modify(:fuck_text, &update_opts(&1, hidden: not fucks))
      |> update_graph(fucks, state.character)

    {:noreply, %{state | fucks: fucks, graph: graph}, push: graph}
  end

  defp update_graph(graph, fucks, character) do
    character = Character.cleanup(character, fucks)

    graph
    |> Graph.modify(:heading, &text(&1, character.heading))
    |> Graph.modify(:body, &text(&1, character.body))
    |> Graph.modify(:response, &button(&1, character.response))
  end
end
