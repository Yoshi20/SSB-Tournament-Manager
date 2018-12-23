require 'test_helper'

class MicrocontrollersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @microcontroller = microcontrollers(:one)
  end

  test "should get index" do
    get microcontrollers_url
    assert_response :success
  end

  test "should get new" do
    get new_microcontroller_url
    assert_response :success
  end

  test "should create microcontroller" do
    assert_difference('Microcontroller.count') do
      post microcontrollers_url, params: { microcontroller: { active: @microcontroller.active, casing: @microcontroller.casing, comment: @microcontroller.comment, name: @microcontroller.name, created_at: @microcontroller.created_at, data_bus_width: @microcontroller.data_bus_width, data_ram_size: @microcontroller.data_ram_size, datasheet: @microcontroller.datasheet, eeprom_size: @microcontroller.eeprom_size, in_stock: @microcontroller.in_stock, manufacturer: @microcontroller.manufacturer, max_clock_frequency: @microcontroller.max_clock_frequency, number_of_ios: @microcontroller.number_of_ios, partnumber: @microcontroller.partnumber, program_memory_size: @microcontroller.program_memory_size, supply_voltage: @microcontroller.supply_voltage, updated_at: @microcontroller.updated_at } }
    end

    assert_redirected_to microcontroller_url(Microcontroller.last)
  end

  test "should show microcontroller" do
    get microcontroller_url(@microcontroller)
    assert_response :success
  end

  test "should get edit" do
    get edit_microcontroller_url(@microcontroller)
    assert_response :success
  end

  test "should update microcontroller" do
    patch microcontroller_url(@microcontroller), params: { microcontroller: { active: @microcontroller.active, casing: @microcontroller.casing, comment: @microcontroller.comment, name: @microcontroller.name, created_at: @microcontroller.created_at, data_bus_width: @microcontroller.data_bus_width, data_ram_size: @microcontroller.data_ram_size, datasheet: @microcontroller.datasheet, eeprom_size: @microcontroller.eeprom_size, in_stock: @microcontroller.in_stock, manufacturer: @microcontroller.manufacturer, max_clock_frequency: @microcontroller.max_clock_frequency, number_of_ios: @microcontroller.number_of_ios, partnumber: @microcontroller.partnumber, program_memory_size: @microcontroller.program_memory_size, supply_voltage: @microcontroller.supply_voltage, updated_at: @microcontroller.updated_at } }
    assert_redirected_to microcontroller_url(@microcontroller)
  end

  test "should destroy microcontroller" do
    assert_difference('Microcontroller.count', -1) do
      delete microcontroller_url(@microcontroller)
    end

    assert_redirected_to microcontrollers_url
  end
end
