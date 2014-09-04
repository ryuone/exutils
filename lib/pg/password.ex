defmodule Pg.Password do
  def list_to_struct(list) do
    %Pg.PgpassStruct{
      hostname: list[:hostname],
      port: list[:port],
      database: list[:database],
      username: list[:username],
    }
  end

  def get(src) do
    list = Pg.ReadPgpass.get
    case confirm_information(src, list, "", false) do
      {true, password} -> password
      {false, _} -> raise("pg connection data is mismatch.")
    end
  end

  def confirm_information(_, _, password, true), do: {true, password}
  def confirm_information(_, [], _, _), do: {false, ""}
  def confirm_information(src, [h|t], _, false) do
    {_, _, status} = {src, h, true} |> is_same_hostname |> is_same_port |> is_same_database |> is_same_username
    confirm_information(src, t, h.password, status)
  end

  def is_same_hostname({_, _, false}=p), do: p
  def is_same_hostname({src, dst, _status}) do
    cond do
      is_nil(dst.hostname) -> {src, dst, true}
      dst.hostname == src.hostname -> {src, dst, true}
      true -> {src, dst, false}
    end
  end
  def is_same_port({_, _, false}=p), do: p
  def is_same_port({src, dst, _status}) do
    cond do
      is_nil(dst.port) -> {src, dst, true}
      dst.port == src.port -> {src, dst, true}
      true -> {src, dst, false}
    end
  end
  def is_same_database({_, _, false}=p), do: p
  def is_same_database({src, dst, _status}) do
    cond do
      is_nil(dst.database) -> {src, dst, true}
      dst.database == src.database -> {src, dst, true}
      true -> {src, dst, false}
    end
  end
  def is_same_username({_, _, false}=p), do: p
  def is_same_username({src, dst, _status}) do
    cond do
      is_nil(dst.username) -> {src, dst, true}
      dst.username == src.username -> {src, dst, true}
      true -> {src, dst, false}
    end
  end
end