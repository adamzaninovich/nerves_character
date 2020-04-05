defmodule NervesCharacterTest do
  use ExUnit.Case
  doctest NervesCharacter

  test "greets the world" do
    assert NervesCharacter.hello() == :world
  end
end
