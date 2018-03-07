class SnippetsController < ApplicationController

  # ----- INDEX -----

  get '/snippet-library' do
    if logged_in?
      @snippets = Snippet.all.where("access_level = 'Public'")
      erb :'/snippets/index'
    else
      redirect to '/login'
    end
  end

  # ----- CREATE -----

  get '/snippets/new' do
    if logged_in?
      erb :'/snippets/new'
    else
      redirect to '/login'
    end
  end


  post '/snippets' do
    if !params[:content].empty?
      current_user.snippets.create(params)
      redirect to "/snippets"
    else
      flash[:warning] = "Please fill in all fields"
      redirect to "/snippets/new"
    end
  end

  # ----- READ -----

  get "/snippets/:id" do
    if logged_in?
      @snippet = Snippet.find_by(id: params[:id])
      @user = current_user
      erb :"snippets/show"
    else
      redirect to "/login"
    end
  end

  # ----- UPDATE -----

  get "/snippets/:id/edit" do
    @snippet = Snippet.find_by(id: params[:id])

    if logged_in? && current_user.snippets.include?(@snippet)
      erb :"snippets/edit"
    else
      redirect to "/login"
    end
  end

  patch "/snippets/:id" do
    @snippet = Snippet.find_by(id: params[:id])

    if !params[:name].empty? && !params[:content].empty?
      @snippet.update(name: params[:name], content: params[:content], language: params[:language], access_level: params[:access_level])
      @user = current_user

      erb :"snippets/show"
    else
      redirect to "/snippets/#{@snippet.id}/edit"
    end
  end

  # ----- DELETE -----

  delete "/snippets/:id/delete" do
    @snippet = Snippet.find_by(id: params[:id])

    if logged_in? && current_user.snippets.include?(@snippet)
      Snippet.find_by(id: params[:id]).destroy
      redirect to "/snippets"
    else
      redirect to "/snippets"
    end
  end
end
