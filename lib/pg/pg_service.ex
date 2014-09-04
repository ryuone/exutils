defmodule Pg.PgService do
  @moduledoc """
  PostgreSQL用INIファイルから必要な情報を取得
  """

  @doc """
  初期化処理(iniファイルの読み込み)
  """
  def init do
    :econfig.register_config(:pg_service, [config_file], [])
    :econfig.subscribe(:pg_service)
  end

  @doc """
  接続情報を取得
  """
  @spec connection_data(List) :: [...]
  def connection_data(dbtype) do
    case :econfig.get_value(:pg_service, dbtype) do
      [] ->
        Application.get_env(:b100_get_exchange_rate, List.to_atom dbtype)
      _ ->
        [
          hostname: :econfig.get_value(:pg_service, dbtype, 'host'),
          username: :econfig.get_value(:pg_service, dbtype, 'user'),
          password: :econfig.get_value(:pg_service, dbtype, 'password'),
          database: :econfig.get_value(:pg_service, dbtype, 'dbname'),
          port:     List.to_integer(:econfig.get_value(:pg_service, dbtype, 'port')),
        ]
    end
  end

  defp config_file do
    String.to_char_list(System.user_home) ++ '/.pg_service.conf'
  end
end
