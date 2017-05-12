require 'sinatra'
require 'sinatra/cookies'
require 'json'
require 'base64'
require 'date'
require 'net/http'

configure do
  set :bind, '0.0.0.0'
  set :port, '8080'
end

enable :sessions

get '/logout' do
  if (!session["user"].nil?)
    session["user"] = nil
    redirect to('/login')
  end
  return "Not logged in"
end

def getUser(identity)
  return nil if identity.nil? or $knownIdentities[identity].nil?
  return $knownIdentities[identity]["full_name"] unless $knownIdentities[identity]["full_name"].nil?
  return $knownIdentities[identity]["sub"]
end

get '/' do
  #Step #1
  identity = session["user"]

  if (!identity.nil?)
    token = $knownIdentities[identity] #AAT
    #if (is_token_expired (token))
    #  # Token is expired
    #  redirect "/login"
    #end
    if (!token.nil?)
        #TODO> Get UMA RPT
    end
  end
  
  #Step #2
  redirect $umaServer+"/authorize?response_type=code&client_id=s6BhdRkqt3&state=xyz&redirect_uri=http%3A%2F%2Fexample.gnu%3A4568%2Fcb&scope=uma_authorization"
end

get "/cb" do
    #Step #9
    code = params[:code]
    p code
    # POST /token HTTP/1.1
    # Host: server.example.com
    # Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    # Content-Type: application/x-www-form-urlencoded
#
#     grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
#     &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb
end
