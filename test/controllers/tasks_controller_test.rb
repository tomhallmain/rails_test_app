require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Dynamically override the layout for TasksController
    TasksController.class_eval do
      layout 'test'
    end
    
    @user = users(:one)
    @project = projects(:one)
    @task = tasks(:one)
    sign_in_as(@user, skip_redirect: true)
  end

  def teardown
    # Reset to default layout
    TasksController.class_eval do
      layout 'application'
    end
  end

  test "should get index" do
    get tasks_path
    assert_response :success
    assert_select "h1", "Tasks"
  end

  test "should redirect to tasks when trying to create task without project" do
    get new_task_path
    assert_redirected_to tasks_path
  end

  test "should create task" do
    assert_difference('Task.count') do
      post tasks_path, params: {
        task: {
          title: "New Task",
          description: "Task Description",
          project_id: @project.id
        }
      }
    end

    assert_redirected_to Task.last.project || tasks_path
  end

  test "should show task" do
    get task_path(@task)
    assert_response :success
  end

  test "should get edit" do
    get edit_task_path(@task)
    assert_response :success
  end

  test "should update task" do
    patch task_path(@task), params: {
      task: {
        title: "Updated Task",
        description: "Updated Description"
      }
    }
    assert_redirected_to @task.project || tasks_path
    @task.reload
    assert_equal "Updated Task", @task.title
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete task_path(@task)
    end

    assert_redirected_to @task.project || tasks_path
  end

  test "should toggle task completion" do
    patch toggle_task_path(@task)
    assert_redirected_to tasks_path
    @task.reload
    assert @task.completed
  end

  test "should archive task" do
    post archive_task_path(@task)
    assert_redirected_to tasks_path
    @task.reload
    assert @task.archived
  end
end 