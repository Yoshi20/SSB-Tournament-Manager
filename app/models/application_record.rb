class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def set_country_code
    self.country_code = 'ch'
  end

end
