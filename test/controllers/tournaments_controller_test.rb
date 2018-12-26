require 'test_helper'

class TournamentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tournament = tournaments(:one)
  end

  test "should get index" do
    get tournaments_url
    assert_response :success
  end

  test "should get new" do
    get new_tournament_url
    assert_response :success
  end

  test "should create tournament" do
    assert_difference('Tournament.count') do
      post tournaments_url, params: { tournament: { active: @tournament.active, comment: @tournament.comment, created_at: @tournament.created_at, date: @tournament.date, location: @tournament.location, name: @tournament.name, occupied_seats: @tournament.occupied_seats, registration_fee: @tournament.registration_fee, total_seats: @tournament.total_seats, updated_at: @tournament.updated_at } }
    end

    assert_redirected_to tournament_url(Tournament.last)
  end

  test "should show tournament" do
    get tournament_url(@tournament)
    assert_response :success
  end

  test "should get edit" do
    get edit_tournament_url(@tournament)
    assert_response :success
  end

  test "should update tournament" do
    patch tournament_url(@tournament), params: { tournament: { active: @tournament.active, comment: @tournament.comment, created_at: @tournament.created_at, date: @tournament.date, location: @tournament.location, name: @tournament.name, occupied_seats: @tournament.occupied_seats, registration_fee: @tournament.registration_fee, total_seats: @tournament.total_seats, updated_at: @tournament.updated_at } }
    assert_redirected_to tournament_url(@tournament)
  end

  test "should destroy tournament" do
    assert_difference('Tournament.count', -1) do
      delete tournament_url(@tournament)
    end

    assert_redirected_to tournaments_url
  end
end
