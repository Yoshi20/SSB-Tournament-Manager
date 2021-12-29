class AddAllowsEmailsFromSwisssmashToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :allows_emails_from_swisssmash, :boolean, default: true
    add_column :users, :allows_emails_from_partners, :boolean, default: true

    User.all.each do |u|
      if u.respond_to?(:allows_emails_from_swisssmash)
        u.update(allows_emails_from_swisssmash: false) unless (u.wants_major_email || u.wants_weekly_email)
      end
    end
  end
end
