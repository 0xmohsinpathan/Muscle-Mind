defmodule Fitness.Exercises do
  @moduledoc """
  The Exercises context.
  """

  import Ecto.Query, warn: false
  alias Fitness.Repo

  alias Fitness.Exercises.Exercise

  @doc """
  Returns the list of exercises.

  ## Examples

      iex> list_exercises()
      [%Exercise{}, ...]

  """
  def list_exercises(search_query) do
  exercises = Repo.all(Exercise)
  filter_by_search(exercises, search_query)
  end

  def list_exercises do
    Repo.all(Exercise)
  end

  @doc """
  Gets a single exercise.

  Raises `Ecto.NoResultsError` if the Exercise does not exist.

  ## Examples

      iex> get_exercise!(123)
      %Exercise{}

      iex> get_exercise!(456)
      ** (Ecto.NoResultsError)

  """
  def get_exercise!(id), do: Repo.get!(Exercise, id)

  @doc """
  Creates a exercise.

  ## Examples

      iex> create_exercise(%{field: value})
      {:ok, %Exercise{}}

      iex> create_exercise(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_exercise(attrs \\ %{}) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a exercise.

  ## Examples

      iex> update_exercise(exercise, %{field: new_value})
      {:ok, %Exercise{}}

      iex> update_exercise(exercise, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_exercise(%Exercise{} = exercise, attrs) do
    exercise
    |> Exercise.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a exercise.

  ## Examples

      iex> delete_exercise(exercise)
      {:ok, %Exercise{}}

      iex> delete_exercise(exercise)
      {:error, %Ecto.Changeset{}}

  """
  def delete_exercise(%Exercise{} = exercise) do
    Repo.delete(exercise)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking exercise changes.

  ## Examples

      iex> change_exercise(exercise)
      %Ecto.Changeset{data: %Exercise{}}

  """
  def change_exercise(%Exercise{} = exercise, attrs \\ %{}) do
    Exercise.changeset(exercise, attrs)
  end

  defp filter_by_search(exercises, search_query) do


    found_search_query =
      case search_query do
        "" ->
          exercises

        search_query ->
          words = search_query |> String.downcase() |> String.split()

          exercises
          |> Enum.filter(fn exercise ->
            texts =
              [
                exercise.name |> String.downcase(),
                exercise.level |> String.downcase(),
                exercise.type |> String.downcase(),
                exercise.body_part |> String.downcase(),
                exercise.equipment |> String.downcase()
              ]
              |> Enum.join()

            Enum.all?(words, fn word ->
              String.contains?(texts, word)
            end)
          end)
      end

    found_search_query
  end
end
