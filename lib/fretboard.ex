defmodule Fretboard do
  def to_string(fretboard) do
    for {frets, s} <- Enum.with_index(fretboard) do
      for {fret, f} <- Enum.with_index(frets) do
        cond do
          s == 0 ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "┌"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┐"
                  false -> "───┐"
                end

              true ->
                case fret do
                  true -> "─●─┬"
                  false -> "───┬"
                end
            end

          s == length(fretboard) - 1 ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "└"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┘"
                  false -> "───┘"
                end

              true ->
                case fret do
                  true -> "─●─┴"
                  false -> "───┴"
                end
            end

          true ->
            cond do
              f == 0 ->
                case fret do
                  true -> "○"
                  false -> "├"
                end

              f == length(List.first(fretboard)) - 1 ->
                case fret do
                  true -> "─●─┤"
                  false -> "───┤"
                end

              true ->
                case fret do
                  true -> "─●─┼"
                  false -> "───┼"
                end
            end
        end
      end ++ "\n"
    end
  end

  def new(strings, frets) do
    false
    |> List.duplicate(frets)
    |> List.duplicate(strings)
  end
end
