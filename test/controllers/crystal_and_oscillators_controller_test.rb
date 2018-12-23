require 'test_helper'

class CrystalAndOscillatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @crystal_and_oscillator = crystal_and_oscillators(:one)
  end

  test "should get index" do
    get crystal_and_oscillators_url
    assert_response :success
  end

  test "should get new" do
    get new_crystal_and_oscillator_url
    assert_response :success
  end

  test "should create crystal_and_oscillator" do
    assert_difference('CrystalAndOscillator.count') do
      post crystal_and_oscillators_url, params: { crystal_and_oscillator: { active: @crystal_and_oscillator.active, comment: @crystal_and_oscillator.comment, created_at: @crystal_and_oscillator.created_at, datasheet: @crystal_and_oscillator.datasheet, frequency: @crystal_and_oscillator.frequency, height: @crystal_and_oscillator.height, in_stock: @crystal_and_oscillator.in_stock, length: @crystal_and_oscillator.length, manufacturer: @crystal_and_oscillator.manufacturer, partnumber: @crystal_and_oscillator.partnumber, stability: @crystal_and_oscillator.stability, tolerance: @crystal_and_oscillator.tolerance, updated_at: @crystal_and_oscillator.updated_at, width: @crystal_and_oscillator.width } }
    end

    assert_redirected_to crystal_and_oscillator_url(CrystalAndOscillator.last)
  end

  test "should show crystal_and_oscillator" do
    get crystal_and_oscillator_url(@crystal_and_oscillator)
    assert_response :success
  end

  test "should get edit" do
    get edit_crystal_and_oscillator_url(@crystal_and_oscillator)
    assert_response :success
  end

  test "should update crystal_and_oscillator" do
    patch crystal_and_oscillator_url(@crystal_and_oscillator), params: { crystal_and_oscillator: { active: @crystal_and_oscillator.active, comment: @crystal_and_oscillator.comment, created_at: @crystal_and_oscillator.created_at, datasheet: @crystal_and_oscillator.datasheet, frequency: @crystal_and_oscillator.frequency, height: @crystal_and_oscillator.height, in_stock: @crystal_and_oscillator.in_stock, length: @crystal_and_oscillator.length, manufacturer: @crystal_and_oscillator.manufacturer, partnumber: @crystal_and_oscillator.partnumber, stability: @crystal_and_oscillator.stability, tolerance: @crystal_and_oscillator.tolerance, updated_at: @crystal_and_oscillator.updated_at, width: @crystal_and_oscillator.width } }
    assert_redirected_to crystal_and_oscillator_url(@crystal_and_oscillator)
  end

  test "should destroy crystal_and_oscillator" do
    assert_difference('CrystalAndOscillator.count', -1) do
      delete crystal_and_oscillator_url(@crystal_and_oscillator)
    end

    assert_redirected_to crystal_and_oscillators_url
  end
end
