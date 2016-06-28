require 'securerandom'

class UsersController < ApplicationController
  before_action :set_keys

  def new 
    @user = User.new 
  end   

  def set_keys
    @consumer_key = Rails.application.secrets.good_habitz_key
    @consumer_secret = Rails.application.secrets.good_habitz_secret
  end 

  def create
    @user = User.new(user_params)
    # uri = URI.parse(@launch_url)
    # unique_slug = "/SLM_13592_O_Content/1"
    # host = uri + unique_slug
    # uri.scheme = 'https'
    path = "/lti/SLM_13592_O_Content/1"

    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, { 
      :site => "https://apps.goodhabitz.com", 
      :signature_method => "HMAC-SHA1",
      # :oauth_callback => "about:blank",
       })

    options = { 
      :scheme => 'body'
    }

    custom_params = {}
    custom_params[:lti_version] = "LTI-1p0"
    custom_params[:lti_message_type] = "basic-lti-launch-request"
    custom_params[:resource_link_id] = SecureRandom.uuid
    custom_params[:user_id] = @user.user_id
    custom_params[:oauth_callback] = "about:blank"
 
    request = consumer.create_signed_request(:post, path, nil, options, custom_params)
      # the request is made by a html form in the user's browser, so we
      # want to revert the escapage and return the hash of post parameters ready
      # for embedding in a html view
    @hash = {}
    request.body.split(/&/).each do |param|
      key, val = param.split('=').map { |v| CGI.unescape(v) }
      @hash[key] = val
    end

    puts "==================="
    puts @custom_params
    puts "==================="
    puts @hash 
    puts "==================="
  end 

  def oauth_callback_url
    # when you return with access_token 
    # save session token with code in oauth ruby 
    # render our tool/data inside their learning environment 
    print "Succesful handshake"
  end
  def index
  end 

  private 

  def user_params 
    params.require(:user).permit(:name, :user_id)
  end 
end 

