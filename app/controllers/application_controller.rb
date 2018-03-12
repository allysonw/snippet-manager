class ApplicationController < Sinatra::Base
  register Sinatra::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "snippet_manager_secret"
  end

  get '/' do
    if logged_in?
      @user = current_user
      @snippets = current_user.snippets
      erb :index
    else
      erb :index
    end
  end

  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end
