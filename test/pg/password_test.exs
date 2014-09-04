defmodule Pg.PasswordTest do
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

  test "Convert list to struct.(Pg.Password.list_to_struct)" do
    struct = Pg.Password.list_to_struct [hostname: "x1", port: "x2", database: "x3", username: "x4"]
    assert struct == %Pg.PgpassStruct{database: "x3", hostname: "x1", password: nil, port: "x2", username: "x4"}
  end

  test "Pattern 1) To get password." do
    pgpass = %Pg.PgpassStruct{database: 'databasename',
                              hostname: 'localhost',
                              port: 5432,
                              username: 'test_db_user'}
    assert 'test_db_user1' == Pg.Password.get(pgpass)
  end
  test "Pattern 2) To get password." do
    pgpass = %Pg.PgpassStruct{database: 'databasename',
                              hostname: '192.168.33.22',
                              port: 6000,
                              username: 'test_db_user'}
    assert 'test_db_user4' == Pg.Password.get(pgpass)
  end
  test "Pattern 3) To get password." do
    pgpass = %Pg.PgpassStruct{database: 'dbname',
                              hostname: '192.168.33.10',
                              port: 5432,
                              username: 'test_db_user'}
    assert 'test_db_user3' == Pg.Password.get(pgpass)
  end
  test "Pattern 4)[exception] To get password." do
    pgpass = %Pg.PgpassStruct{database: 'dbname',
                              hostname: '192.168.33.10',
                              port: 1000,
                              username: 'test_db_user'}
    try do
      Pg.Password.get(pgpass)
    rescue
      e ->
        assert e.message == "pg connection data is mismatch."
    end
  end

end
