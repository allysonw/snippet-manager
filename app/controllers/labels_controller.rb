class LabelsController < ApplicationController

  get '/labels/:id' do
    if logged_in?
      if @label = Label.find_by(id: params[:id])
        @user = current_user
        @labels = Label.all
        @snippets = Snippet.all.where("access_level = 'Public'")
        
        erb :"labels/show", :layout => :layout do
          erb :"labels_layout"
        end
      else
        redirect to "/snippet-library"
      end
    else
      redirect to "/login"
    end
  end
end
