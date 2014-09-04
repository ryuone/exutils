defmodule Pg.PgpassStructTest do
  use ExUnit.Case

  test "%Pg.PgpassStruct{} result all nil." do
    struct = %Pg.PgpassStruct{}
    assert struct.hostname == nil
    assert struct.port == nil
    assert struct.database == nil
    assert struct.username == nil
    assert struct.password == nil
  end

  test "%Pg.PgpassStruct{} result all specific value." do
    struct = %Pg.PgpassStruct{hostname: "x1", port: "x2", database: "x3",
      username: "x4", password: "x5"}
    assert struct.hostname == "x1"
    assert struct.port == "x2"
    assert struct.database == "x3"
    assert struct.username == "x4"
    assert struct.password == "x5"
  end
end
