class LabelsController < ApplicationController

  get '/labels/:id' do
    if logged_in?
      if @label = Label.find_by(id: params[:id])
        @user = current_user

        # Data for labels navigator
        @snippets = Snippet.all.where("access_level = 'Public'")
        @label_ids = @snippets.collect {|snippet| snippet.label_ids}.flatten.uniq
        @labels = Label.find(@label_ids)  # get only labels for public snippets
        @user = false

        erb :labels_layout, :layout => :layout do
          erb :'/labels/show_library'
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
        @snippets = current_user.snippets
        @label_ids = @snippets.collect {|snippet| snippet.label_ids}.uniq.flatten
        @labels = Label.find(@label_ids) # get all labels for this user's snippets
        @user = true

        erb :labels_layout, :layout => :layout do
          erb :'/labels/show_user'
        end
      else
        redirect to "/snippets"
      end
    else
      redirect to "/login"
    end
  end
end
