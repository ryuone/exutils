defmodule Pg.PgServiceTest do
  use ExUnit.Case

  setup_all do
    :meck.new(System, [:passthrough])
    :meck.expect(System, :user_home, 0, "./test/asset")

    Pg.PgService.init

    on_exit fn ->
      try do
        :meck.unload(System)
      rescue
        _ in [ErlangError] ->
      end
    end
    {:ok, HashDict.new}
  end

  test "Get manage database's information." do
    kwlist = Pg.PgService.connection_data('manage')
    assert kwlist[:hostname] == '192.168.0.30'
    assert kwlist[:username] == 'test_db_user'
    assert kwlist[:password] == :undefined
    assert kwlist[:database] == 'test_manage'
    assert kwlist[:port]     == 5432
  end
  test "Get not_exist_manage database's information." do
    kwlist = Pg.PgService.connection_data('not_exist_manage')
    assert kwlist == nil
  end
end
