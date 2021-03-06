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
        flash[:warning] = "There was an error with your sign up. Please try again."
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
      flash[:warning] = "There was an error signing you in. Please try again."
      redirect to "/login"
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
    end

    flash[:success] = "You have been logged out."
    redirect to '/login'
  end

  get '/profile' do
    if logged_in?
      @user = current_user
      erb :'users/profile'
    else
      redirect to '/login'
    end
  end

  get '/snippets' do
    if logged_in?
      @snippets = current_user.snippets

      # Data for labels navigator
      label_ids = get_label_ids(@snippets)
      @labels = Label.find(label_ids)
      @user_page = true # flag for labels layout page so it knows to show user links

      erb :labels_layout, :layout => :layout do
        erb :'/users/show'
      end
    else
      redirect to '/login'
    end
  end
end
