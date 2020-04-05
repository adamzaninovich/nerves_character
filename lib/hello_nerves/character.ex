defmodule HelloNerves.Character do
  @moduledoc """
  A struct for storing character data
  """
  alias HelloNerves.{
    Character,
    CharacterGenerator
  }

  defstruct heading: "", body: "", response: ""

  def new do
    %Character{
      heading: CharacterGenerator.heading(),
      body: CharacterGenerator.character(),
      response: CharacterGenerator.response()
    }
  end

  def new(heading, body, response) do
    %Character{heading: heading, body: body, response: response}
  end

  def cleanup(%Character{} = character, true = _allow_fucks) do
    character
  end

  def cleanup(%Character{} = character, false = _allow_fucks) do
    heading = filter_words(character.heading)

    response =
      character.response
      |> translate_words()
      |> filter_words()

    Character.new(heading, character.body, response)
  end

  defp translate_words(text) do
    %{
      "a-fucking-nother" => "another",
      "give a fuck" => "care"
    }
    |> Enum.reduce(text, fn {phrase, translation}, text ->
      String.replace(text, phrase, translation)
    end)
  end

  defp filter_words(text) do
    text
    |> String.split()
    |> Enum.reject(&(&1 in ~w[shit fucking]))
    |> Enum.join(" ")
  end
end
