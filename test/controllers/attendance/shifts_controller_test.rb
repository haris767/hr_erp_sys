require "test_helper"

class Attendance::ShiftsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get attendance_shifts_index_url
    assert_response :success
  end

  test "should get new" do
    get attendance_shifts_new_url
    assert_response :success
  end

  test "should get create" do
    get attendance_shifts_create_url
    assert_response :success
  end

  test "should get edit" do
    get attendance_shifts_edit_url
    assert_response :success
  end

  test "should get update" do
    get attendance_shifts_update_url
    assert_response :success
  end

  test "should get destroy" do
    get attendance_shifts_destroy_url
    assert_response :success
  end
end
