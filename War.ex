defmodule War do
  @moduledoc """
  	Documentation for `War`.
  """

  @doc """
  	Function stub for deal/1 is given below. Feel free to add
  	as many additional helper functions as you want.

  	The tests for the deal function can be found in test/war_test.exs.
  	You can add your five test cases to this file.

  	Run the tester by executing 'mix test' from the war directory
  	(the one containing mix .exs)
  """
 # populate hand with even indices of shuf
  def deal_helper_1(shuf) do
    Enum.with_index(shuf)
    |> Enum.filter(fn {_, i} -> rem(i, 2) == 0 end)
    |> Enum.map(fn {elem, _} -> elem end)
    |> Enum.reverse()
  end

  # populate hand with odd indices of shuf
  def deal_helper_2(shuf) do
    Enum.with_index(shuf)
    |> Enum.filter(fn {_, i} -> rem(i, 2) != 0 end)
    |> Enum.map(fn {elem, _} -> elem end)
    |> Enum.reverse()
  end

  # search for 1's change to 14
  def fix_aces(shuf) do
    Enum.map(shuf, fn x ->
      if x == 1 do
        x + 13
      else
        x
      end
    end)
  end

  # search for 14's, revert to 1's
  def revert_aces(shuf) do
    Enum.map(shuf, fn x ->
      if x == 14 do
        x - 13
      else
        x
      end
    end)
  end

  def deal(shuf) do
    # convert every 1 to 14 in shuffled cards to simplify comparisons later
    shuf = fix_aces(shuf)
    # split the deck evenly
    p1 = deal_helper_1(shuf)
    p2 = deal_helper_2(shuf)
    # init warchest to be empty
    warchest = []
    # store winning hand in var, then undo fix_aces()
    winner = turn(p1, p2, warchest)
    revert_aces(winner)
  end

  # function headers and base cases
  def turn(p1, p2, warchest)

  # check for p1 running out of cards
  def turn([], p2, warchest) do
    p2 = p2 ++ Enum.sort(warchest, &(&2 < &1))
    p2
  end

  # check for p2 running out of cards
  def turn(p1, [], warchest) do
    p1 = p1 ++ Enum.sort(warchest, &(&2 < &1))
    p1
  end

  # check for a tie edgecase in war
  def turn([], [], warchest) do
    # sort warchest from largest to smallest and return warchest
    Enum.sort(warchest, &(&2 < &1))
  end

  # if not base case, perform gameloop aka recursive case
  def turn(p1, p2, warchest) do
    # head and tail recursion
    [p1_top | p1_tail] = p1
    [p2_top | p2_tail] = p2
    # sort the war chest from largest to smallest each recursive call
    warchest = [p1_top, p2_top] ++ warchest
    warchest = Enum.sort(warchest, &(&2 < &1))
    cond do
      p1_top > p2_top ->
        # recursively play with updated hands
        turn(p1_tail ++ warchest, p2_tail, [])

      p2_top > p1_top ->
        turn(p1_tail, p2_tail ++ warchest, [])
      # same rank, check if war is possible recurse turn() and add matching cards to warchest
      length(p1_tail) > 2 and length(p2_tail) > 2 ->

        [p1_top | p1_tail] = p1_tail
        [p2_top | p2_tail] = p2_tail
        turn(p1_tail, p2_tail, warchest ++ [p1_top, p2_top])

      true ->
        IO.inspect(warchest, limit: :infinity)
        turn(p1_tail, p2_tail, warchest)
    end
  end
end
