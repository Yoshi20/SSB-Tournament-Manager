Recaptcha.configure do |config|
  config.site_key  = ENV['RECAPTCHA_SITE_KEY_CH']
  config.secret_key = ENV['RECAPTCHA_SECRET_KEY_CH']
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
