require 'test_helper'

class CapacitorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capacitor = capacitors(:one)
  end

  test "should get index" do
    get capacitors_url
    assert_response :success
  end

  test "should get new" do
    get new_capacitor_url
    assert_response :success
  end

  test "should create capacitor" do
    assert_difference('Capacitor.count') do
      post capacitors_url, params: { capacitor: { active: @capacitor.active, capacitance: @capacitor.capacitance, capacitance_in_farad: @capacitor.capacitance_in_farad, casing: @capacitor.casing, comment: @capacitor.comment, created_at: @capacitor.created_at, datasheet: @capacitor.datasheet, in_stock: @capacitor.in_stock, manufacturer: @capacitor.manufacturer, partnumber: @capacitor.partnumber, power_rating: @capacitor.power_rating, specific_component_type: @capacitor.specific_component_type, tolerance: @capacitor.tolerance, unit: @capacitor.unit, updated_at: @capacitor.updated_at } }
    end

    assert_redirected_to capacitor_url(Capacitor.last)
  end

  test "should show capacitor" do
    get capacitor_url(@capacitor)
    assert_response :success
  end

  test "should get edit" do
    get edit_capacitor_url(@capacitor)
    assert_response :success
  end

  test "should update capacitor" do
    patch capacitor_url(@capacitor), params: { capacitor: { active: @capacitor.active, capacitance: @capacitor.capacitance, capacitance_in_farad: @capacitor.capacitance_in_farad, casing: @capacitor.casing, comment: @capacitor.comment, created_at: @capacitor.created_at, datasheet: @capacitor.datasheet, in_stock: @capacitor.in_stock, manufacturer: @capacitor.manufacturer, partnumber: @capacitor.partnumber, power_rating: @capacitor.power_rating, specific_component_type: @capacitor.specific_component_type, tolerance: @capacitor.tolerance, unit: @capacitor.unit, updated_at: @capacitor.updated_at } }
    assert_redirected_to capacitor_url(@capacitor)
  end

  test "should destroy capacitor" do
    assert_difference('Capacitor.count', -1) do
      delete capacitor_url(@capacitor)
    end

    assert_redirected_to capacitors_url
  end
end
