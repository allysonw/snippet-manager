class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'/users/signup'
    else
      redirect to '/snippets'
    end
  end

  post '/signup' do
    if User.find_by(username: params[:username]) # username is taken
      flash[:warning] = "That username is already taken."
      redirect to '/signup'
    else
      user = User.new(params)

      if user.save
        session[:user_id] = user.id # log the user in after signup
        redirect to '/snippets'
      else
        redirect to '/signup'
      end
    end
  end

  get '/login' do
    if logged_in?
      redirect to "/snippets"
    else
      erb :"users/login"
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/snippets"
    else
      redirect to "/login"
  end
  end

  get '/logout' do
    if logged_in?
      session.destroy
    end

    redirect to '/login'
  end

end
