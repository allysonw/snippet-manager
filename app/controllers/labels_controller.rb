class LabelsController < ApplicationController

  get '/labels/:id' do
    if logged_in?
      if @label = Label.find_by(id: params[:id])
        @user = current_user

        # Data for labels navigator
        @label_snippets = Snippet.all.where("access_level = 'Public'")
        @label_ids = @label_snippets.collect {|snippet| snippet.label_ids}.flatten.uniq
        @labels = Label.find(@label_ids)  # get only labels for public snippets
        @user = false

        # Filter snippets for this label
        @snippets = @label_snippets.select {|snippet| snippet.labels.include?(@label)}

        erb :labels_layout, :layout => :layout do
          erb :'/snippets/index'
        end
      else
        redirect to "/snippet-library"
      end
    else
      redirect to "/login"
    end
  end

  get '/labels/user/:id' do
    if logged_in?
      if @label = Label.find_by(id: params[:id])
        @user = current_user

        # Data for labels navigator
        @label_snippets = current_user.snippets
        @label_ids = @label_snippets.collect {|snippet| snippet.label_ids}.uniq.flatten
        @labels = Label.find(@label_ids) # get all labels for this user's snippets
        @user = true

        # Filter snippets for this label
        @snippets = @label_snippets.select {|snippet| snippet.labels.include?(@label)}

        erb :labels_layout, :layout => :layout do
          erb :'/users/show'
        end
      else
        redirect to "/snippets"
      end
    else
      redirect to "/login"
    end
  end
end
