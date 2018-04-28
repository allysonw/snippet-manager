class SnippetsController < ApplicationController

  # ----- INDEX -----

  get '/snippet-library' do
    if logged_in?
      @snippets = Snippet.all.where("access_level = 'Public'")

      # Data for labels navigator
      label_ids = get_label_ids(@snippets) # label ids to show in navigator
      @labels = Label.find(label_ids) # labels to show in navigator
      @user_page = false # flag for labels layout page so it knows to show library links

      # Display labels_layout within main layout and nest snippets/index within labels_layout
      erb :labels_layout, :layout => :layout do
        erb :'/snippets/index'
      end
    else
      redirect to '/login'
    end
  end

  # ----- CREATE -----

  get '/snippets/new' do
    if logged_in?
      @labels = Label.all
      erb :'/snippets/new'
    else
      redirect to '/login'
    end
  end

# params => {snippet: {name: "Allyson Wesman", content: "code", language: "Ruby", acccess_level: "Private"}, labels => {name: "work", name: "project X"}, new_label => {name: "new_label"}}

  post '/snippets' do

    if !params[:snippet][:content].empty?
      new_snippet = Snippet.create(params[:snippet])
      current_user.snippets << new_snippet

      if params[:labels] && !params[:labels].empty?
        params[:labels].each do |label|
          label = Label.find_or_create_by(name: label)
          new_snippet.labels << label
        end
      end

      if !params[:new_label].empty?
        new_label = Label.find_or_create_by(name: params[:new_label])
        new_snippet.labels << new_label
      end

      redirect to "/snippets"
    else
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

    if logged_in? && current_user.snippets.include?(@snippet) # ensure a user can only edit their own snippet
      @labels = Label.all
      erb :"snippets/edit"
    else
      redirect to "/login"
    end
  end

  patch "/snippets/:id" do
    @snippet = Snippet.find_by(id: params[:id])
    if current_user.snippets.include?(@snippet) # ensure a user can only update their own snippet

      if !params[:name].empty? && !params[:content].empty?
        @snippet.update(name: params[:name], content: params[:content], language: params[:language], access_level: params[:access_level])
        @snippet.labels.clear # get ready to update the labels, or remove them all if none are selected

        if params[:labels] && !params[:labels].empty?
          params[:labels].each do |label|
            label = Label.find_or_create_by(name: label)
            @snippet.labels << label
          end
        end

        if !params[:new_label].empty?
          new_label = Label.find_or_create_by(name: params[:new_label])
          @snippet.labels << new_label
        end

        @user = current_user
        flash[:success] = "Snippet successfully updated."
        redirect to "snippets/#{@snippet.id}"
      else
        flash[:warning] = "Snippets must have a name and content."
        redirect to "/snippets/#{@snippet.id}/edit"
      end

    else
      flash[:warning] = "STOP HACKING!!!"
      redirect_to '/login'
    end
  end

  # ----- DELETE -----

  delete "/snippets/:id/delete" do
    @snippet = Snippet.find_by(id: params[:id])

    if logged_in? && current_user.snippets.include?(@snippet) # ensure a user can only delete their own snippet
      Snippet.find_by(id: params[:id]).destroy
      flash[:success] = "Snippet successfully deleted."
      redirect to "/snippets"
    else
      redirect to "/snippets"
    end
  end
end
