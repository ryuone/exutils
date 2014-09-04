defmodule ExutilsTest do
  use ExUnit.Case

  setup_all do
    :meck.new(System, [:passthrough])
    :meck.expect(System, :halt, 1, fn(n) -> n end)
    # :meck.expect(:erlang, :localtime, 1, {{2014,08,31}, {0,0,0}})

    on_exit fn ->
      try do
        :meck.unload(System)
      rescue
        _ in [ErlangError] ->
      end
    end
    {:ok, HashDict.new}
  end

  test "Get localtime." do
    {_date={year,month,day},_time={hour,minutes,seconds}} = :erlang.localtime()
    assert Exutils.localtime == "#{year}/#{month}/#{day} #{hour}:#{minutes}:#{seconds}"
  end

  test "system_halt is working" do
    assert Exutils.system_halt(100) == 100
  end

  test "wait is working" do
    assert Exutils.wait(100) == :after
  end

end
