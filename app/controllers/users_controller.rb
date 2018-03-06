class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'/users/signup'
    else
      erb :'/snippets/snippets'
    end
  end

  post '/signup' do
    session[:user_id] = current_user.id # log the user in after signup
    erb :'/snippets/snippets'
  end



end
