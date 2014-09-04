defmodule Exutils do
  @moduledoc """
  * Utility module
  """

  @doc """
  現在時刻を取得
  """
  def localtime do
    {_date={year,month,day},_time={hour,minutes,seconds}} = :erlang.localtime()
    "#{year}/#{month}/#{day} #{hour}:#{minutes}:#{seconds}"
  end

  @doc """
  処理待ち時間機能
  """
  @spec wait(non_neg_integer) :: :after
  def wait(t) do
    receive do
      after
        t ->
          :after
    end
  end

  @doc """
  処理停止機能
  """
  def system_halt(num) do
    wait(100)
    System.halt(num)
  end
end
