require 'test_helper'

class PowerManagementIcsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @power_management_ic = power_management_ics(:one)
  end

  test "should get index" do
    get power_management_ics_url
    assert_response :success
  end

  test "should get new" do
    get new_power_management_ic_url
    assert_response :success
  end

  test "should create power_management_ic" do
    assert_difference('PowerManagementIc.count') do
      post power_management_ics_url, params: { power_management_ic: { active: @power_management_ic.active, battery_type: @power_management_ic.battery_type, casing: @power_management_ic.casing, comment: @power_management_ic.comment, created_at: @power_management_ic.created_at, datasheet: @power_management_ic.datasheet, dropout_voltage: @power_management_ic.dropout_voltage, in_stock: @power_management_ic.in_stock, input_voltage: @power_management_ic.input_voltage, manufacturer: @power_management_ic.manufacturer, max_output_current: @power_management_ic.max_output_current, output_voltage: @power_management_ic.output_voltage, partnumber: @power_management_ic.partnumber, quiscent_current: @power_management_ic.quiscent_current, specific_component_type: @power_management_ic.specific_component_type, switching_frequency: @power_management_ic.switching_frequency, updated_at: @power_management_ic.updated_at } }
    end

    assert_redirected_to power_management_ic_url(PowerManagementIc.last)
  end

  test "should show power_management_ic" do
    get power_management_ic_url(@power_management_ic)
    assert_response :success
  end

  test "should get edit" do
    get edit_power_management_ic_url(@power_management_ic)
    assert_response :success
  end

  test "should update power_management_ic" do
    patch power_management_ic_url(@power_management_ic), params: { power_management_ic: { active: @power_management_ic.active, battery_type: @power_management_ic.battery_type, casing: @power_management_ic.casing, comment: @power_management_ic.comment, created_at: @power_management_ic.created_at, datasheet: @power_management_ic.datasheet, dropout_voltage: @power_management_ic.dropout_voltage, in_stock: @power_management_ic.in_stock, input_voltage: @power_management_ic.input_voltage, manufacturer: @power_management_ic.manufacturer, max_output_current: @power_management_ic.max_output_current, output_voltage: @power_management_ic.output_voltage, partnumber: @power_management_ic.partnumber, quiscent_current: @power_management_ic.quiscent_current, specific_component_type: @power_management_ic.specific_component_type, switching_frequency: @power_management_ic.switching_frequency, updated_at: @power_management_ic.updated_at } }
    assert_redirected_to power_management_ic_url(@power_management_ic)
  end

  test "should destroy power_management_ic" do
    assert_difference('PowerManagementIc.count', -1) do
      delete power_management_ic_url(@power_management_ic)
    end

    assert_redirected_to power_management_ics_url
  end
end
