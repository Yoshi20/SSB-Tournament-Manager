require 'test_helper'

class ResistorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resistor = resistors(:one)
  end

  test "should get index" do
    get resistors_url
    assert_response :success
  end

  test "should get new" do
    get new_resistor_url
    assert_response :success
  end

  test "should create resistor" do
    assert_difference('Resistor.count') do
      post resistors_url, params: { resistor: { active: @resistor.active, casing: @resistor.casing, comment: @resistor.comment, created_at: @resistor.created_at, datasheet: @resistor.datasheet, in_stock: @resistor.in_stock, manufacturer: @resistor.manufacturer, partnumber: @resistor.partnumber, power_rating: @resistor.power_rating, resistance: @resistor.resistance, tolerance: @resistor.tolerance, specific_component_type: @resistor.specific_component_type, unit: @resistor.unit, updated_at: @resistor.updated_at } }
    end

    assert_redirected_to resistor_url(Resistor.last)
  end

  test "should show resistor" do
    get resistor_url(@resistor)
    assert_response :success
  end

  test "should get edit" do
    get edit_resistor_url(@resistor)
    assert_response :success
  end

  test "should update resistor" do
    patch resistor_url(@resistor), params: { resistor: { active: @resistor.active, casing: @resistor.casing, comment: @resistor.comment, created_at: @resistor.created_at, datasheet: @resistor.datasheet, in_stock: @resistor.in_stock, manufacturer: @resistor.manufacturer, partnumber: @resistor.partnumber, power_rating: @resistor.power_rating, resistance: @resistor.resistance, tolerance: @resistor.tolerance, specific_component_type: @resistor.specific_component_type, unit: @resistor.unit, updated_at: @resistor.updated_at } }
    assert_redirected_to resistor_url(@resistor)
  end

  test "should destroy resistor" do
    assert_difference('Resistor.count', -1) do
      delete resistor_url(@resistor)
    end

    assert_redirected_to resistors_url
  end
end
