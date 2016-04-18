Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => "yflix.herokuapp.com" }
  Rails.application.routes.default_url_options[:host] = "yflix.herokuapp.com"

  ActionMailer::Base.smtp_settings = {
    address: "smtp.qq.com",
    port: 25,
    domain: "qq.com",
    authentication: "login",
    enable_starttls_auto: true,
    user_name: ENV["MAIL_USERNAME"],
    password: ENV["MAIL_PASSWORD"]
  }
  ActionMailer::Base.delivery_method = :smtp

end
