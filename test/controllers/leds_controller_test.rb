require 'test_helper'

class LedsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @led = leds(:one)
  end

  test "should get index" do
    get leds_url
    assert_response :success
  end

  test "should get new" do
    get new_led_url
    assert_response :success
  end

  test "should create led" do
    assert_difference('Led.count') do
      post leds_url, params: { led: { active: @led.active, casing: @led.casing, color: @led.color, comment: @led.comment, created_at: @led.created_at, datasheet: @led.datasheet, forward_current: @led.forward_current, forward_voltage: @led.forward_voltage, in_stock: @led.in_stock, luminous_intensity: @led.luminous_intensity, manufacturer: @led.manufacturer, partnumber: @led.partnumber, updated_at: @led.updated_at, viewing_angle: @led.viewing_angle } }
    end

    assert_redirected_to led_url(Led.last)
  end

  test "should show led" do
    get led_url(@led)
    assert_response :success
  end

  test "should get edit" do
    get edit_led_url(@led)
    assert_response :success
  end

  test "should update led" do
    patch led_url(@led), params: { led: { active: @led.active, casing: @led.casing, color: @led.color, comment: @led.comment, created_at: @led.created_at, datasheet: @led.datasheet, forward_current: @led.forward_current, forward_voltage: @led.forward_voltage, in_stock: @led.in_stock, luminous_intensity: @led.luminous_intensity, manufacturer: @led.manufacturer, partnumber: @led.partnumber, updated_at: @led.updated_at, viewing_angle: @led.viewing_angle } }
    assert_redirected_to led_url(@led)
  end

  test "should destroy led" do
    assert_difference('Led.count', -1) do
      delete led_url(@led)
    end

    assert_redirected_to leds_url
  end
end
