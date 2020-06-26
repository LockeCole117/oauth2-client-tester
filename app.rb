require 'rubygems'; require 'bundler'; Bundler.require

require 'byebug'
require 'faraday'

require_relative 'config'

get '/' do
	erb :index
end

get '/step1' do
	@client = OAuth2::Client.new(ENV.fetch("CLIENT_ID"), ENV.fetch("CLIENT_SECRET"), site: ENV.fetch("PROVIDER_SITE"), authorize_url: ENV.fetch("AUTHORIZE_URL"), token_url: ENV.fetch("TOKEN_URL"))
	redirect @client.auth_code.authorize_url(
		redirect_uri: ENV.fetch("REDIRECT_URI"),
		state: "test1234"
	)
end

get '/step2' do
	@code = params[:code]
	@state = params[:state]

	# Used when you need to look at the details of the response for debugging
	# conn = Faraday.new(:url => PROVIDER_SITE) do |faraday|
	#   faraday.request  :url_encoded             # form-encode POST params
	#   faraday.response :logger                  # log requests to STDOUT
	#   faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
	# end

	# response = conn.post TOKEN_URL, { :code => @code, :client_id => CLIENT_ID, :client_secret => CLIENT_SECRET}

	# debugger

	# Rack::Utils.parse_query(response.body)

	@client = OAuth2::Client.new(ENV.fetch("CLIENT_ID"), ENV.fetch("CLIENT_SECRET"), site: ENV.fetch("PROVIDER_SITE"), authorize_url: ENV.fetch("AUTHORIZE_URL"), token_url: ENV.fetch("TOKEN_URL"))

	@token = @client.auth_code.get_token(@code, redirect_uri: ENV.fetch("REDIRECT_URI"))

	logger.info @token.to_hash

	erb :step2
end