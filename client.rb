require 'sinatra'
require 'sinatra/cookies'
require 'json'
require 'base64'
require 'date'
require 'net/http'
require 'rest-client'

configure do
  set :bind, '0.0.0.0'
  set :port, '4568'
end

enable :sessions

$knownIdentities = {}
$umaServer = 'http://testservice.gnu:4567'
$client_id = "random_client_id"
$client_secret = "lksajr327048olkxjf075342jldsau0958lkjds"

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
  p identity

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

#callback URL
get "/cb" do
    #Step #9
    code = params['code']
    p code
    # POST /token HTTP/1.1
    # Host: server.example.com
    # Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
    # Content-Type: application/x-www-form-urlencoded
#
#     grant_type=authorization_code&code=SplxlOBeZQQYbYS6WxSbIA
#     &redirect_uri=https%3A%2F%2Fclient%2Eexample%2Ecom%2Fcb

    encoded_authorization = ["#{$client_id}:#{$client_secret}"].pack('m').delete("\r\n")
    puts "user pass #{$client_id} #{$client_secret}"
    r = RestClient::Request.execute(method: :post,
                                    url: 'http://testservice.gnu:4567/token',
                                    verify_ssl: false,
                                    user: $client_id,
                                    password: $client_secret,
                                    headers: {Authorization: 'Basic #{encoded_authorization}',
                                      content_type: 'json', params: {grant_type: 'authorization_code',code: code, redirect_uri: 'http%3A%2F%2Fexample%2Egnu%2Fcb'}})
    response_body = JSON.parse(r.body)
    puts "response aat #{response_body["access_token"]}"



end
