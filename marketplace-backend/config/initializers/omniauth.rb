require 'omniauth/rails_csrf_protection'
require 'omniauth-google-oauth2'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, 
          ENV['GOOGLE_CLIENT_ID'], 
          ENV['GOOGLE_CLIENT_SECRET'],
          {
            scope: 'email,profile',
            prompt: 'select_account',
            image_aspect_ratio: 'square',
            image_size: 50,
            access_type: 'offline',
            skip_jwt: true
          }
end

# In development, allow OmniAuth to work in development without https
OmniAuth.config.allowed_request_methods = [:post, :get] if Rails.env.development?

# Add error handling
OmniAuth.config.on_failure = Proc.new do |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
end