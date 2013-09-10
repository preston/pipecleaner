require 'test_helper'

class PipelinesControllerTest < ActionController::TestCase
  setup do
    @pipeline = pipelines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pipelines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pipeline" do
    assert_difference('Pipeline.count') do
      post :create, pipeline: { code: @pipeline.code, description: @pipeline.description, name: @pipeline.name }
    end

    assert_redirected_to pipeline_path(assigns(:pipeline))
  end

  test "should show pipeline" do
    get :show, id: @pipeline
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pipeline
    assert_response :success
  end

  test "should update pipeline" do
    put :update, id: @pipeline, pipeline: { code: @pipeline.code, description: @pipeline.description, name: @pipeline.name }
    assert_redirected_to pipeline_path(assigns(:pipeline))
  end

  test "should destroy pipeline" do
    assert_difference('Pipeline.count', -1) do
      delete :destroy, id: @pipeline
    end

    assert_redirected_to pipelines_path
  end
end
