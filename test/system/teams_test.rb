require "application_system_test_case"

class TeamsTest < ApplicationSystemTestCase
  setup do
    @team = teams(:one)
  end

  test "visiting the index" do
    visit teams_url
    assert_selector "h1", text: "Teams"
  end

  test "creating a Team" do
    visit teams_url
    click_on "New Team"

    fill_in "Country code", with: @team.country_code
    fill_in "Description", with: @team.description
    fill_in "Discord", with: @team.discord
    fill_in "Facebook", with: @team.facebook
    fill_in "Image height", with: @team.image_height
    fill_in "Image link", with: @team.image_link
    fill_in "Image width", with: @team.image_width
    fill_in "Instagram", with: @team.instagram
    check "Is recruiting" if @team.is_recruiting
    check "Is sponsoring players" if @team.is_sponsoring_players
    fill_in "Name long", with: @team.name_long
    fill_in "Name short", with: @team.name_short
    fill_in "Recruiting description", with: @team.recruiting_description
    fill_in "Region", with: @team.region
    fill_in "Twitch", with: @team.twitch
    fill_in "Telegram", with: @team.telegram
    fill_in "Twitter", with: @team.twitter
    fill_in "Website", with: @team.website
    fill_in "Youtube", with: @team.youtube
    click_on "Create Team"

    assert_text "Team was successfully created"
    click_on "Back"
  end

  test "updating a Team" do
    visit teams_url
    click_on "Edit", match: :first

    fill_in "Country code", with: @team.country_code
    fill_in "Description", with: @team.description
    fill_in "Discord", with: @team.discord
    fill_in "Facebook", with: @team.facebook
    fill_in "Image height", with: @team.image_height
    fill_in "Image link", with: @team.image_link
    fill_in "Image width", with: @team.image_width
    fill_in "Instagram", with: @team.instagram
    check "Is recruiting" if @team.is_recruiting
    check "Is sponsoring players" if @team.is_sponsoring_players
    fill_in "Name long", with: @team.name_long
    fill_in "Name short", with: @team.name_short
    fill_in "Recruiting description", with: @team.recruiting_description
    fill_in "Region", with: @team.region
    fill_in "Twitch", with: @team.twitch
    fill_in "Telegram", with: @team.telegram
    fill_in "Twitter", with: @team.twitter
    fill_in "Website", with: @team.website
    fill_in "Youtube", with: @team.youtube
    click_on "Update Team"

    assert_text "Team was successfully updated"
    click_on "Back"
  end

  test "destroying a Team" do
    visit teams_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Team was successfully destroyed"
  end
end
