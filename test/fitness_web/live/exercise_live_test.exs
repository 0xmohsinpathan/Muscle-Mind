defmodule FitnessWeb.ExerciseLiveTest do
  alias Fitness.Exercises
  use FitnessWeb.ConnCase

  import Phoenix.LiveViewTest
  import Fitness.ExercisesFixtures

  @create_attrs %{description: "some description", gif_url: "some gif_url", level: "some level", name: "some name", type: "some type", equipment: "some equipment", body_part: "some body part"}
  @update_attrs %{description: "some updated description", gif_url: "some updated gif_url", level: "some updated level", name: "some updated name", type: "some updated type", equipment: "some undated equipment", body_part: "some updated body part"}
  @invalid_attrs %{description: nil, gif_url: nil, level: nil, name: nil, type: nil}

  defp create_exercise(_) do
    exercise = exercise_fixture()
    %{exercise: exercise}
  end

  describe "Index" do
    setup [:create_exercise]

    test "lists all exercises", %{conn: conn, exercise: exercise} do
      {:ok, _index_live, html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert html =~ "Search Exercises"
      assert html =~ exercise.name
    end

    test "lists all exercises not matching search query", %{conn: conn} do
      exercise = exercise_fixture(name: "Decline Crunch")
      {:ok, _index_live, html} = live(conn, Routes.exercise_index_path(conn, :index, search: "Hanging leg raise"))
      assert html =~ exercise.name
    end

    test "list_exercise/1_ matching name, type, level" do
      exercise = exercise_fixture(name: "Decline Crunch", level: "Intermediate", type: "Strength")
      assert Exercises.list_exercises("Decline intermediate Strength") == [exercise]
    end

    # test "list_authors/1 _ matching name" do
    #   author = author_fixture(name: "Andrew Rowe")
    #   assert Authors.list_authors("Andrew Rowe") == [author]
    # end

    # test "list_authors/1 _ non matching name" do
    #   author = author_fixture(name: "Andrew Rowe")
    #   assert Authors.list_authors("Dennis E Taylor") == []
    # end


    test "saves new exercise", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert index_live |> element("a", "New Exercise") |> render_click() =~
               "New Exercise"

      assert_patch(index_live, Routes.exercise_index_path(conn, :new))

      assert index_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#exercise-form", exercise: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_index_path(conn, :index))

      assert html =~ "Exercise created successfully"
      assert html =~ "some name"
    end

    test "updates exercise in listing", %{conn: conn, exercise: exercise} do
      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert index_live |> element("#exercise-#{exercise.id} a", "Edit") |> render_click() =~
               "Edit Exercise"

      assert_patch(index_live, Routes.exercise_index_path(conn, :edit, exercise))

      assert index_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#exercise-form", exercise: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_index_path(conn, :index))

      assert html =~ "Exercise updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes exercise in listing", %{conn: conn, exercise: exercise} do
      {:ok, index_live, _html} = live(conn, Routes.exercise_index_path(conn, :index))

      assert index_live |> element("#exercise-#{exercise.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#exercise-#{exercise.id}")
    end
  end

  describe "Show" do
    setup [:create_exercise]

    test "displays exercise", %{conn: conn, exercise: exercise} do
      {:ok, _show_live, html} = live(conn, Routes.exercise_show_path(conn, :show, exercise))

      assert html =~ "Show Exercise"
      assert html =~ exercise.description
    end

    test "updates exercise within modal", %{conn: conn, exercise: exercise} do
      {:ok, show_live, _html} = live(conn, Routes.exercise_show_path(conn, :show, exercise))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Exercise"

      assert_patch(show_live, Routes.exercise_show_path(conn, :edit, exercise))

      assert show_live
             |> form("#exercise-form", exercise: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#exercise-form", exercise: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.exercise_show_path(conn, :show, exercise))

      assert html =~ "Exercise updated successfully"
      assert html =~ "some updated description"
    end
  end
end