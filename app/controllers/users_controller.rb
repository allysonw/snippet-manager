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
      flash[:notice] = "That username is already taken."
      binding.pry
      redirect to '/signup'
    else
      user = User.new(params)

      if user.save
        session[:user_id] = current_user.id # log the user in after signup
        redirect to '/snippets'
      else
        redirect to '/signup'
      end
    end
  end

  get '/logout' do
    session.destroy
    redirect to '/'
  end

end
