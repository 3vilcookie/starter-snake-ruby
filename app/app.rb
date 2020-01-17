require 'rack'
require 'rack/contrib'
require 'sinatra'
require './app/util'
require './app/move'

set :bind, '0.0.0.0'
set :logging, false

use Rack::PostBodyContentTypeParser

appearance = {
  color: '#4169E1',
  head_type: 'pixel',
  tail_type: 'bolt'
}

session = {}

get '/' do
  <<~HTML
  <html>
    <head>
      <title>Rudy Rand - Battle Snake</title>
    </head>
    <body>
      Rudy Rand played #{session.count} games since the last restart.<br>
    </body>
  </html>
  HTML

end

post '/ping' do
  "ok\n"
end

post '/start' do
  # Create new Navigation object with the game id as key
  # and store it into the session hash
  request = underscore(env['rack.request.form_hash'])
  session[request[:game][:id]] = Navigation.new request

  puts " > > > NEW GAME < < < <"
  puts "Width:  #{request[:board][:width]}"
  puts "Height: #{request[:board][:width]}"

  puts "Player: "
  puts request[:board][:snakes].map{|s|s[:name]}.join("\n")

  content_type :json
  camelcase(appearance).to_json
end

post '/move' do
  request = underscore(env['rack.request.form_hash'])
  response = session[request[:game][:id]].move(request)

  content_type :json
  camelcase(response).to_json
end

post '/end' do
  request = underscore(env['rack.request.form_hash'])
  session.delete(request[:game][:id])
  "end\n"
end
