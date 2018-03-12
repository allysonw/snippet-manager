class LabelsController < ApplicationController

  get '/labels/:id' do
    if logged_in?
      if label = Label.find_by(id: params[:id])

        public_snippets = Snippet.all.where("access_level = 'Public'") # show only public snippets

        # Data for labels navigator
        label_ids = get_label_ids(public_snippets) # label ids to show in navigator
        @labels = Label.find(label_ids) # labels to show in navigator
        @user_page = false # flag for labels layout page so it knows to show library links

        # Filter snippets for this label
        @snippets = filter_snippets_by_label(public_snippets, label)

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
      if label = Label.find_by(id: params[:id])

        user_snippets = current_user.snippets # show only user's snippets

        # Data for labels navigator
        label_ids = get_label_ids(user_snippets) # label ids to show in navigator
        @labels = Label.find(label_ids) # labels to show in navigator
        @user_page = true # flag for labels layout page so it knows to show user links

        # Filter snippets for this label
        @snippets = filter_snippets_by_label(user_snippets, label)

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
