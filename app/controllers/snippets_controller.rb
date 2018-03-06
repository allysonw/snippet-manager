class SnippetsController < ApplicationController

  get '/snippets' do
    erb :'/snippets/snippets'
  end

end
