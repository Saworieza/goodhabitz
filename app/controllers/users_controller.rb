class UsersController < ApplicationController
  def new 
    @user = User.new 
  end   

  def set_keys
    @consumer_key = "springest_-_testklant.1"
    @consumer_secret = "zvhFujzLrr"
    @launch_url = "https://apps.goodhabitz.com/lti"
  end 

  def has_required_params? 
    @consumer_key && @consumer_secret && @launch_url && @resource_link_id
  end 

  def create 
    # raise "Don't have all your require params" unless has_required_params?

    # should have lti parameters 
    @lti_message_type = 'basic-lti-launch-request'
    @lti_version = 'LTI-1p0'

    # uri = URI.parse(@launch_url)
    # unique_slug = "/SLM_13592_O_Content/1"
    # host = uri + unique_slug
    # uri.scheme = 'https'
    path = "https://apps.goodhabitz.com/lti/SLM_13592_O_Content/1"

    consumer = OAuth::Consumer.new(@consumer_key, @consumer_secret, { 
      :site => "https://apps.goodhabitz.com/lti/SLM_13592_O_Content/1", 
      :signature_method => "HMAC-SHA1",
       })

    options = { 
      :scheme => 'body'
    }

    params['lti_version'] ||= "LTI-1p0"

    request = consumer.create_signed_request(:post, path, nil, options, params)

      # the request is made by a html form in the user's browser, so we
      # want to revert the escapage and return the hash of post parameters ready
      # for embedding in a html view
    hash = {}
    request.body.split(/&/).each do |param|
      key, val = param.split('/=/').map { |v| CGI.unescape(v) }
      hash[key] = val
    end
    puts hash

    redirect_to users_path
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

