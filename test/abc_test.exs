defmodule ABCTest do
  import ABC

  use ExUnit.Case

  # test "parses a chord" do
  #   assert parse("""
  #          |"Cmaj7"|
  #          """) == [[0, 4, {:optional, 7}, 11]]
  # end

  # test "parses a chord with an accidental" do
  #   assert parse("""
  #          |"C#maj7"|
  #          """) == [[1, 5, {:optional, 8}, 0]]
  # end

  # test "parses a slash chord" do
  #   assert parse("""
  #                 |"Cmaj7/E"|
  #          """) == [[0, {:optional, 7}, 11, {:lowest, 4}]]
  # end

  # test "parses slash chord with optional as slash" do
  #   assert parse("""
  #          |"Cmaj7/g"|
  #          """) == [[0, 4, 11, {:lowest, 7}]]
  # end

  # test "parses a slash chord with extra note" do
  #   assert parse("""
  #          |"Cmaj7/Eb"|
  #          """) == [[0, 4, {:optional, 7}, 11, {:lowest, 3}]]
  # end

  # test "parses a chord and note" do
  #   assert parse("""
  #          |"Cmaj7"C|
  #          """) == [[0, 4, {:optional, 7}, 11, {:highest, 48}]]
  # end

  test "parses a chord and multiple notes" do
    assert parse("""
                  |"Cmaj7"cdB|
           """) == [
             [0, 4, {:optional, 7}, 11, {:highest, 60}],
             [0, 4, {:optional, 7}, 11, {:highest, 62}],
             [0, 4, {:optional, 7}, 11, {:highest, 59}]
           ]
  end

  # test "preprocesses field continuations" do
  #   assert preprocess("""
  #          w:Sa-ys my au-l' wan to your aul' wan,
  #          +:will~ye come to the Wa-x-ies dar-gle?
  #          """) == [
  #            "w:Sa-ys my au-l' wan to your aul' wan, will~ye come to the Wa-x-ies dar-gle?"
  #          ]
  # end

  # test "breaks out inline fields" do
  #   assert preprocess("""
  #          E2E EFE|E2E EFG|[M:9/8] A2G F2E D2|]
  #          """) == [
  #            "E2E EFE|E2E EFG|",
  #            "M:9/8",
  #            "A2G F2E D2|"
  #          ]
  # end

  # test "joins line breaks" do
  #   assert preprocess("""
  #          E2E EFE|E2E EFG|\
  #          A2G F2E D2|]
  #          """) == ["E2E EFE|E2E EFG|A2G F2E D2|"]
  # end

  # test "preprocesses a complex input" do
  #   assert preprocess("""
  #          E2E EFE|E2E EFG|\
  #          A2G F2E D2|]
  #          """) == ["E2E EFE|E2E EFG|A2G F2E D2|"]
  # end
end
