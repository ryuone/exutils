defmodule Pg.ReadPgpass do
  defp config_file do
    String.to_char_list(System.user_home) ++ '/.pgpass'
  end

  def get do
    try do
      {:ok, bin} = File.read(config_file)
      bin |> String.split("\n") |> resolution
    rescue
      e ->
        IO.puts "*Warning* Can not read #{config_file}. [#{inspect(e)}]"
        []
    end
  end

  defp resolution(config_arr), do: resolution(config_arr, [])
  defp resolution([], acc), do: acc |> Enum.reverse
  defp resolution([""|t], acc), do: resolution(t, acc)
  defp resolution([<<"#", _rest::binary>>|t], acc), do: resolution(t, acc)
  defp resolution([h|t], acc) do
    ltuple = String.split(h, ":") |> List.to_tuple
    {_, r} = {ltuple, %Pg.PgpassStruct{}} |>
      set_hostname |>
      set_port |>
      set_database |>
      set_username |>
      set_password
    resolution(t, [r|acc])
  end

  defp set_hostname({t, r}) do
    case (t |> elem 0) do
      "*" -> {t, r}
      v -> {t, Map.put(r, :hostname, v |> String.to_char_list)}
    end
  end
  defp set_port({t, r}) do
    case (t |> elem 1) do
      "*" -> {t, r}
      v -> {t, Map.put(r, :port, v |> String.to_integer)}
    end
  end
  defp set_database({t, r}) do
    case (t |> elem 2) do
      "*" -> {t, r}
      v -> {t, Map.put(r, :database, v |> String.to_char_list)}
    end
  end
  defp set_username({t, r}) do
    case (t |> elem 3) do
      "*" -> {t, r}
      v -> {t, Map.put(r, :username, v |> String.to_char_list)}
    end
  end
  defp set_password({t, r}) do
    case (t |> elem 4) do
      "*" -> {t, r}
      v -> {t, Map.put(r, :password, v |> String.to_char_list)}
    end
  end
end
