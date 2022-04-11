class AddUserIdToCommunities < ActiveRecord::Migration[5.1]
  def change
    add_column :communities, :user_id, :bigint
    add_foreign_key :communities, :users

    # also add missing timestamps
    add_column :communities, :created_at, :datetime
    add_column :communities, :updated_at, :datetime
    Community.all.each do |c|
      if c.respond_to?(:updated_at)
        now = Time.now
        c.update(user_id: User.first.id, created_at: now, updated_at: now)
      end
    end
  end
end
