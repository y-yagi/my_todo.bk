require_relative 'models'

require 'roda'
require 'tilt/sass'

class MyTodo < Roda
  plugin :default_headers,
    'Content-Type'=>'text/html',
    'Content-Security-Policy'=>"default-src 'self'; style-src 'self' https://maxcdn.bootstrapcdn.com;",
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  # Don't delete session secret from environment in development mode as it breaks reloading
  session_secret = ENV['RACK_ENV'] == 'development' ? ENV['MY_TODO_SESSION_SECRET'] : ENV.delete('MY_TODO_SESSION_SECRET')
  use Rack::Session::Cookie,
    key: '_MyTodo_session',
    #secure: ENV['RACK_ENV'] != 'test', # Uncomment if only allowing https:// access
    :same_site=>:lax, # or :strict if you want to disallow linking into the site
    secret: (session_secret || SecureRandom.hex(40))

  plugin :csrf
  plugin :flash
  plugin :assets, css: 'app.scss', css_opts: {style: :compressed, cache: false}, timestamp_paths: true
  plugin :render, escape: true
  plugin :multi_route
  plugin :all_verbs
  plugin :json, classes: [Array, Hash, Sequel::Model]
  plugin :rodauth do
    enable :login, :logout, :create_account
  end

  Unreloader.require('routes'){}

  route do |r|
    r.rodauth
    rodauth.require_authentication
    r.assets
    r.multi_route

    r.root do
      account = Account[rodauth.session_value]
      @todos = account.todos
      view 'index'
    end

    r.post 'todos' do
      todo = Todo.new(r.params['todo'])
      todo.account = Account[rodauth.session_value]
      todo.save
      r.redirect '/'
    end

    r.is 'todo', Integer do |id|
      @todo = Todo[id]

      r.get do
        @todo.destroy
        r.redirect '/'
      end

      r.post do
        @todo.update(r.params['todo'])
        r.redirect '/'
      end
    end
  end
end
