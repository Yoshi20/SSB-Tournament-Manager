require 'test_helper'

class DiodesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @diode = diodes(:one)
  end

  test "should get index" do
    get diodes_url
    assert_response :success
  end

  test "should get new" do
    get new_diode_url
    assert_response :success
  end

  test "should create diode" do
    assert_difference('Diode.count') do
      post diodes_url, params: { diode: { active: @diode.active, casing: @diode.casing, comment: @diode.comment, created_at: @diode.created_at, datasheet: @diode.datasheet, forward_current: @diode.forward_current, forward_voltage: @diode.forward_voltage, in_stock: @diode.in_stock, manufacturer: @diode.manufacturer, partnumber: @diode.partnumber, reverse_current: @diode.reverse_current, specific_component_type: @diode.specific_component_type, updated_at: @diode.updated_at } }
    end

    assert_redirected_to diode_url(Diode.last)
  end

  test "should show diode" do
    get diode_url(@diode)
    assert_response :success
  end

  test "should get edit" do
    get edit_diode_url(@diode)
    assert_response :success
  end

  test "should update diode" do
    patch diode_url(@diode), params: { diode: { active: @diode.active, casing: @diode.casing, comment: @diode.comment, created_at: @diode.created_at, datasheet: @diode.datasheet, forward_current: @diode.forward_current, forward_voltage: @diode.forward_voltage, in_stock: @diode.in_stock, manufacturer: @diode.manufacturer, partnumber: @diode.partnumber, reverse_current: @diode.reverse_current, specific_component_type: @diode.specific_component_type, updated_at: @diode.updated_at } }
    assert_redirected_to diode_url(@diode)
  end

  test "should destroy diode" do
    assert_difference('Diode.count', -1) do
      delete diode_url(@diode)
    end

    assert_redirected_to diodes_url
  end
end
