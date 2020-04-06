defmodule Regalocal.Release do
  @app :regalocal

  def migrate do
    ensure_all_started()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    ensure_all_started()

    Code.eval_file("priv/repo/seeds.exs")
  end

  def setup do
    migrate()
    seed()
  end

  defp repos do
    Application.load(@app)
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp ensure_all_started do
    Application.ensure_all_started(@app)
  end
end
