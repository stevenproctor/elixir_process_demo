defmodule Fibbonacci do
  def nth(0), do: 1
  def nth(1), do: 1
  def nth(n), do: Fibbonacci.nth(Fibbonacci.nth(0), Fibbonacci.nth(1), n-2)

  def nth(two_ago, one_ago, 0), do: two_ago + one_ago
  def nth(two_ago, one_ago, n), do: Fibbonacci.nth(one_ago, two_ago + one_ago, n-2)
end

defmodule Spawner do
  def create_tasks(process_count, task_function) do
    1..process_count
      |> Enum.map( fn(_) -> Task.async(task_function) end )
      |> Enum.map( &Task.await/1 )
  end
end

defmodule Examples do
  def run_sleepers(processes, milliseconds_to_sleep) do
    sleeper_task = fn() -> :timer.sleep(milliseconds_to_sleep) end
    run_tasks(processes, sleeper_task)
  end

  def run_fibbonacci(processes, nth_fibbonacci) do
    fibbonacci_task = fn() -> Fibbonacci.nth(nth_fibbonacci) end
    run_tasks(processes, fibbonacci_task)
  end

  defp run_tasks(process_count, task_function) do
    IO.puts inspect node()
    {timing, _result} = :timer.tc(Spawner, :create_tasks, [process_count, task_function])
    IO.puts inspect timing
  end
end

