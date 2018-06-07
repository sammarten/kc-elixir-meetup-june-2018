defmodule GymTest do
  use ExUnit.Case
  doctest Gym

  test "greets the world" do
    assert Gym.hello() == :world
  end
end
