defmodule FitnessWeb.WorkoutTemplateLive.FormComponent do
  use FitnessWeb, :live_component

  alias Fitness.WorkoutTemplates
  alias Fitness.WorkoutTemplates.WorkoutItem

  @impl true
  def update(%{workout_template: workout_template} = assigns, socket) do
    changeset = WorkoutTemplates.change_workout_template(workout_template) |> Ecto.Changeset.put_assoc(:workout_items, [WorkoutTemplates.change_workout_item(%WorkoutItem{})])

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"workout_template" => workout_template_params}, socket) do

    changeset =
      socket.assigns.workout_template
      |> WorkoutTemplates.change_workout_template(workout_template_params)
      |> Ecto.Changeset.put_assoc(:workout_items, [WorkoutTemplates.change_workout_item(%WorkoutItem{})])
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"workout_template" => workout_template_params}, socket) do
    save_workout_template(socket, socket.assigns.action, workout_template_params)
  end

  defp save_workout_template(socket, :edit, workout_template_params) do
    case WorkoutTemplates.update_workout_template(socket.assigns.workout_template, workout_template_params) do
      {:ok, _workout_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Workout template updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_workout_template(socket, :new, workout_template_params) do
    case WorkoutTemplates.create_workout_template(workout_template_params) do
      {:ok, _workout_template} ->
        {:noreply,
         socket
         |> put_flash(:info, "Workout template created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
