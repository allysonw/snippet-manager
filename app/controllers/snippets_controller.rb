class SnippetsController < ApplicationController

  get '/snippets' do
    erb :'/snippets/snippets'
  end

  get '/snippet_library' do
    erb :'/snippets/snippet_library'
  end

end
