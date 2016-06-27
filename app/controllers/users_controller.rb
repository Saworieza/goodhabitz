class UsersController < ApplicationController
  def new 
    @user = User.new 
  end   

  def create 
    @user = User.new(user_params)

    @callback_url = "http://127.0.0.1:3000/oauth/callback"
    # creates a new instance of consumer, passing through the params in the hash here 
    # maybe I should pass lti_consumer_key and lti_version through here? 
    @consumer = OAuth::Consumer.new(
      Rails.application.secrets.good_habitz_key,
      Rails.application.secrets.good_habitz_secret, 
      :http_method => :post, 
      :site => "https://apps.goodhabitz.com/lti/SLM_13592_O_Content/1",
      :lti_message_type => "basic-lti-launch-request",
      # of course version should be 2, but test tool uses 1
      :lti_version => "LTI-2p0",
      :user_id => 1,
      :resource_link_id => 429785226)


    @request_token = @consumer.get_request_token(:oauth_callback => @callback_url)
    
    if @user.save 
      session[:token] = @request_token.token
      session[:token_secret] = @request_token.secret
      # can't get the request token to authorize correctly 
      puts "==============================="
      puts @request_token.authorize_url
      puts "==============================="
      # redirect_to request_token.authorize_url(:oauth_callback => @callback_url)
      # should go to their site, then back to ours 

    else 
      render :new
    end
  end 

  def oauth_callback_url
    print "Succesful handshake"
  end

  private 

  def user_params 
    params.require(:user).permit(:name)
  end 
end 

