require 'test_helper'

class InductorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inductor = inductors(:one)
  end

  test "should get index" do
    get inductors_url
    assert_response :success
  end

  test "should get new" do
    get new_inductor_url
    assert_response :success
  end

  test "should create inductor" do
    assert_difference('Inductor.count') do
      post inductors_url, params: { inductor: { active: @inductor.active, casing: @inductor.casing, comment: @inductor.comment, created_at: @inductor.created_at, datasheet: @inductor.datasheet, in_stock: @inductor.in_stock, inductance: @inductor.inductance, inductance_in_henry: @inductor.inductance_in_henry, manufacturer: @inductor.manufacturer, max_dc_current: @inductor.max_dc_current, max_dc_resistance: @inductor.max_dc_resistance, partnumber: @inductor.partnumber, specific_component_type: @inductor.specific_component_type, tolerance: @inductor.tolerance, unit: @inductor.unit, updated_at: @inductor.updated_at } }
    end

    assert_redirected_to inductor_url(Inductor.last)
  end

  test "should show inductor" do
    get inductor_url(@inductor)
    assert_response :success
  end

  test "should get edit" do
    get edit_inductor_url(@inductor)
    assert_response :success
  end

  test "should update inductor" do
    patch inductor_url(@inductor), params: { inductor: { active: @inductor.active, casing: @inductor.casing, comment: @inductor.comment, created_at: @inductor.created_at, datasheet: @inductor.datasheet, in_stock: @inductor.in_stock, inductance: @inductor.inductance, inductance_in_henry: @inductor.inductance_in_henry, manufacturer: @inductor.manufacturer, max_dc_current: @inductor.max_dc_current, max_dc_resistance: @inductor.max_dc_resistance, partnumber: @inductor.partnumber, specific_component_type: @inductor.specific_component_type, tolerance: @inductor.tolerance, unit: @inductor.unit, updated_at: @inductor.updated_at } }
    assert_redirected_to inductor_url(@inductor)
  end

  test "should destroy inductor" do
    assert_difference('Inductor.count', -1) do
      delete inductor_url(@inductor)
    end

    assert_redirected_to inductors_url
  end
end
