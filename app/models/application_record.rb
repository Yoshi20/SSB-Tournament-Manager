class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def set_country_code
    self.country_code = session['country_code'] unless self.country_code.present? # blup: not possible -> must be set in the view or the controller
  end

end
