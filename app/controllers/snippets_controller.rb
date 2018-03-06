class SnippetsController < ApplicationController

  get '/snippets' do
    if logged_in?
      erb :'/snippets/snippets'
    else
      redirect to '/login'
    end
  end

  get '/snippet_library' do
    erb :'/snippets/snippet_library'
  end

end
