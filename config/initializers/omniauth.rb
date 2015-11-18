Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'],ENV['GITHUB_CLIENT_SECRET']
  provider :weibo, ENV['WEIBO_CLIENT_ID'],ENV['WEIBO_CLIENT_SECRET']
end
