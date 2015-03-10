defmodule IssuesTest do
  use ExUnit.Case

  import Issues.CLI, only: [
    parse_argv: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_hashdicts: 1]

  test "help" do
    assert parse_argv(["-h", "anything"]) == :help
    assert parse_argv(["--help", "anything"]) == :help
  end

  test "three values" do
    assert parse_argv(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "two values" do
    assert parse_argv(["user", "project"]) == { "user", "project", 4}
  end

  test "sort" do
    result = sort_into_ascending_order(fake_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w(a b c)
  end

  defp fake_list(vs) do
    data = for v <- vs, do: [{"created_at", v}, {"other", "xxx"}]
    convert_to_list_of_hashdicts(data)
  end
end
