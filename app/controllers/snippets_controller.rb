class SnippetsController < ApplicationController

  # ----- CREATE -----

  get '/snippets/new' do
    if logged_in?
      erb :'/snippets/new'
    else
      redirect to '/login'
    end
  end


  get '/snippets' do
    if logged_in?
      erb :'/snippets/snippets'
    else
      redirect to '/login'
    end
  end





  get '/snippet_library' do
    if logged_in?
      erb :'/snippets/snippet_library'
    else
      redirect to '/login'
    end
  end

end
