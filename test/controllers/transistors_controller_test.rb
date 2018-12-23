require 'test_helper'

class TransistorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @transistor = transistors(:one)
  end

  test "should get index" do
    get transistors_url
    assert_response :success
  end

  test "should get new" do
    get new_transistor_url
    assert_response :success
  end

  test "should create transistor" do
    assert_difference('Transistor.count') do
      post transistors_url, params: { transistor: { active: @transistor.active, casing: @transistor.casing, cb_voltage: @transistor.cb_voltage, comment: @transistor.comment, configuration: @transistor.configuration, continuous_drain_current: @transistor.continuous_drain_current, created_at: @transistor.created_at, datasheet: @transistor.datasheet, ds_breakdown_voltage: @transistor.ds_breakdown_voltage, ds_resistance: @transistor.ds_resistance, eb_voltage: @transistor.eb_voltage, gs_threshold_voltage: @transistor.gs_threshold_voltage, in_stock: @transistor.in_stock, manufacturer: @transistor.manufacturer, max_ce_voltage: @transistor.max_ce_voltage, max_dc_current: @transistor.max_dc_current, number_of_channels: @transistor.number_of_channels, partnumber: @transistor.partnumber, polarity: @transistor.polarity, specific_component_type: @transistor.specific_component_type, updated_at: @transistor.updated_at } }
    end

    assert_redirected_to transistor_url(Transistor.last)
  end

  test "should show transistor" do
    get transistor_url(@transistor)
    assert_response :success
  end

  test "should get edit" do
    get edit_transistor_url(@transistor)
    assert_response :success
  end

  test "should update transistor" do
    patch transistor_url(@transistor), params: { transistor: { active: @transistor.active, casing: @transistor.casing, cb_voltage: @transistor.cb_voltage, comment: @transistor.comment, configuration: @transistor.configuration, continuous_drain_current: @transistor.continuous_drain_current, created_at: @transistor.created_at, datasheet: @transistor.datasheet, ds_breakdown_voltage: @transistor.ds_breakdown_voltage, ds_resistance: @transistor.ds_resistance, eb_voltage: @transistor.eb_voltage, gs_threshold_voltage: @transistor.gs_threshold_voltage, in_stock: @transistor.in_stock, manufacturer: @transistor.manufacturer, max_ce_voltage: @transistor.max_ce_voltage, max_dc_current: @transistor.max_dc_current, number_of_channels: @transistor.number_of_channels, partnumber: @transistor.partnumber, polarity: @transistor.polarity, specific_component_type: @transistor.specific_component_type, updated_at: @transistor.updated_at } }
    assert_redirected_to transistor_url(@transistor)
  end

  test "should destroy transistor" do
    assert_difference('Transistor.count', -1) do
      delete transistor_url(@transistor)
    end

    assert_redirected_to transistors_url
  end
end
