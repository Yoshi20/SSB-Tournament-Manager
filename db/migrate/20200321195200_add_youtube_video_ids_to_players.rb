class AddYoutubeVideoIdsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :youtube_video_ids, :string
  end
end
