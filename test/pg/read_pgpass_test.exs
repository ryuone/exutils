defmodule Pg.ReadPgpassTest do
  use ExUnit.Case

  setup_all do
    :meck.new(System, [:passthrough])
    :meck.expect(System, :user_home, 0, "./test/asset")

    on_exit fn ->
      try do
        :meck.unload(System)
      rescue
        _ in [ErlangError] ->
      end
    end
    {:ok, HashDict.new}
  end

  test "Get .pgpass information." do
    list = Pg.ReadPgpass.get
    first = list |> List.first
    last  = list |> List.last

    assert first.database == nil
    assert first.hostname == 'localhost'
    assert first.password == 'test_db_user1'
    assert first.port     == 5432
    assert first.username == 'test_db_user'

    assert last.database == 'databasename'
    assert last.hostname == '192.168.33.22'
    assert last.password == 'test_db_user4'
    assert last.port     == 6000
    assert last.username == 'test_db_user'
  end
end
