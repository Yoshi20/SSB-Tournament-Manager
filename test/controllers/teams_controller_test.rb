require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
  end

  test "should get index" do
    get teams_url
    assert_response :success
  end

  test "should get new" do
    get new_team_url
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post teams_url, params: { team: { country_code: @team.country_code, description: @team.description, discord: @team.discord, telegram: @team.telegram, facebook: @team.facebook, image_height: @team.image_height, image_link: @team.image_link, image_width: @team.image_width, instagram: @team.instagram, is_recruiting: @team.is_recruiting, is_sponsoring_players: @team.is_sponsoring_players, name_long: @team.name_long, name_short: @team.name_short, recruiting_description: @team.recruiting_description, region: @team.region, twitch: @team.twitch, twitter: @team.twitter, website: @team.website, youtube: @team.youtube } }
    end

    assert_redirected_to team_url(Team.last)
  end

  test "should show team" do
    get team_url(@team)
    assert_response :success
  end

  test "should get edit" do
    get edit_team_url(@team)
    assert_response :success
  end

  test "should update team" do
    patch team_url(@team), params: { team: { country_code: @team.country_code, description: @team.description, discord: @team.discord, telegram: @team.telegram, facebook: @team.facebook, image_height: @team.image_height, image_link: @team.image_link, image_width: @team.image_width, instagram: @team.instagram, is_recruiting: @team.is_recruiting, is_sponsoring_players: @team.is_sponsoring_players, name_long: @team.name_long, name_short: @team.name_short, recruiting_description: @team.recruiting_description, region: @team.region, twitch: @team.twitch, twitter: @team.twitter, website: @team.website, youtube: @team.youtube } }
    assert_redirected_to team_url(@team)
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to teams_url
  end
end
