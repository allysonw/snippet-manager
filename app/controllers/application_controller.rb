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

  def get_label_ids(snippets)
    snippets.collect {|snippet| snippet.label_ids}.flatten.uniq
  end

  def filter_snippets_by_label(snippets, label)
    snippets.select {|snippet| snippet.labels.include?(label)}
  end
end
