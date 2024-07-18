class User < ApplicationRecord
  has_one :player, dependent: :destroy
  has_many :communities
  has_many :feedbacks
  has_many :news
  has_many :teams
  has_many :shop_products, dependent: :destroy

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  before_validation :strip_whitespace

  validates :username,
    :presence => true,
    :uniqueness => {
      :case_sensitive => false
    }

  validate :validate_username

  scope :all_from, ->(country_code) { where(country_code: country_code) }

  MAX_USERS_PER_PAGE = 100

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # Besides :streches, you can define:
         # :pepper, :encryptor, :confirm_within, :remember_for, :timeout_in, :unlock_in, ...

  #before_action :authenticate_user!
  #.user_signed_in?
  #.current_user
  #.user_session

  #after_sign_in_path_for :...
  #after_sign_out_path_for :...

  # after_create :login_data_notification

  # def login_data_notification
  #   UserMailer.login_data().deliver
  # end

  def strip_whitespace
    self.username.try(:strip!)
    self.email.try(:strip!)
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions.to_hash).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def admin?
    self.is_admin == true || self.is_super_admin == true
  end

  def super_admin?
    self.is_super_admin == true
  end

  def allows_emails
    if self.country_code == 'ch'
      self.allows_emails_from_swisssmash
    elsif self.country_code == 'de'
      self.allows_emails_from_germanysmash
    elsif self.country_code == 'fr'
      self.allows_emails_from_francesmash
    elsif self.country_code == 'lu'
      self.allows_emails_from_luxsmash
    elsif self.country_code == 'it'
      self.allows_emails_from_italysmash
    elsif self.country_code == 'uk'
      self.allows_emails_from_uksmash
    elsif self.country_code == 'pt'
      self.allows_emails_from_portugalsmash
    elsif self.country_code == 'is'
      self.allows_emails_from_smashiceland
    end
  end

  def gamer_tag
    self.player.gamer_tag
  end

  def send_devise_notification(notification, *args)
    locale = Domain.default_locale_from(self.country_code)
    I18n.with_locale(locale) { super(notification, *args) }
  end

  def has_role?(role)
    self.player.role_list.include?(role)
  end

  def is_moderator?
    self.admin? || self.has_role?("forum_moderator")
  end

end
