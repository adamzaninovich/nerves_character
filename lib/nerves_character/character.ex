defmodule NervesCharacter.Character do
  @moduledoc """
  A struct for storing character data
  """

  alias NervesCharacter.{
    Character,
    CharacterGenerator
  }

  defstruct heading: "", body: "", response: ""

  @doc """
  Generates a new Character
  """
  @spec new() :: %Character{}
  def new do
    %Character{
      heading: CharacterGenerator.heading(),
      body: CharacterGenerator.body(),
      response: CharacterGenerator.response()
    }
  end

  @doc """
  Builds a new Character given a heading, body, and response
  """
  @spec new(String.t(), String.t(), String.t()) :: %Character{}
  def new(heading, body, response) do
    %Character{heading: heading, body: body, response: response}
  end

  @doc """
  Given a Character and an `allow_fucks` boolean, cleans up the language of the
  Character when `allow_fucks` is `false`
  """
  @spec cleanup(%Character{}, boolean()) :: %Character{}
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
