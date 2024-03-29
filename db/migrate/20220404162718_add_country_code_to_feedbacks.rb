class AddCountryCodeToFeedbacks < ActiveRecord::Migration[5.2]
  def change
    add_column :feedbacks, :country_code, :string
    Feedback.includes(:user).all.each do |n|
      if n.respond_to?(:country_code)
        n.update(country_code: n.user.country_code)
      end
    end
  end
end
