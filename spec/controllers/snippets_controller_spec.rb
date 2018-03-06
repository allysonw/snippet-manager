require 'spec_helper'

describe SnippetsController do

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new snippet form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit '/snippets/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a snippet if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/snippets/new'
        fill_in(:name, :with => "Print all the snippet names")
        fill_in(:content, :with => "snippets.each {|snippet| puts snippet.name}")
        fill_in(:language, :with => "Ruby")
        # checkbox for access level
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        snippet = Snippet.find_by(:content => "snippets.each {|snippet| puts snippet.name}")
        expect(snippet).to be_instance_of(Snippet)
        expect(snippet.user_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create a snippet for another user' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/snippets/new'

        fill_in(:name, :with => "Print all the snippet names")
        fill_in(:content, :with => "snippets.each {|snippet| puts snippet.name}")
        fill_in(:language, :with => "Ruby")
        # checkbox for access level
        click_button 'submit'

        user = User.find_by(:id=> user.id)
        user2 = User.find_by(:id => user2.id)
        snippet = Snippet.find_by(:content => "snippets.each {|snippet| puts snippet.name}")
        expect(snippet).to be_instance_of(Snippet)
        expect(snippet.user_id).to eq(user.id)
        expect(snippet.user_id).not_to eq(user2.id)
      end

      it 'does not let a user create a blank snippet' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/snippets/new'

        fill_in(:name, :with => "")
        fill_in(:content, :with => "")
        fill_in(:content, :with => "")
        fill_in(:language, :with => "")
        # checkbox for access level

        click_button 'submit'

        expect(Snippet.find_by(:content => "")).to eq(nil)
        expect(page.current_path).to eq("/snippets/new")
      end
    end

    context 'logged out' do
      it 'does not let user view new snippet form if not logged in' do
        get '/snippets/new'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'show action' do
    context 'logged in' do
      it 'displays a single snippet' do

        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        snippet = Snippet.create(:name => "Print all the snippet names", :content => "snippets.each {|snippet| puts snippet.name}", :language => "Ruby", :access_level => "Private", :user_id => user.id)

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit "/snippets/#{snippet.id}"
        expect(page.status_code).to eq(200)
        #expect(page.body).to include("Delete Tweet")
        expect(page.body).to include(snippet.content)
        #expect(page.body).to include("Edit Tweet")
      end

      it 'shows a public snippet to another user' do

      end

      it 'does not show a private snippet to another user' do

      end
    end

    context 'logged out' do
      it 'does not let a user view a snippet' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        snippet = Snippet.create(:name => "Print all the snippet names", :content => "snippets.each {|snippet| puts snippet.name}", :language => "Ruby", :access_level => "Private", :user_id => user.id)

        get "/snippets/#{snippet.id}"
        expect(last_response.location).to include("/login")
      end
    end
  end
  #
  # describe 'edit action' do
  #   context "logged in" do
  #     it 'lets a user view tweet edit form if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => user.id)
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'
  #       expect(page.status_code).to eq(200)
  #       expect(page.body).to include(tweet.content)
  #     end
  #
  #     it 'does not let a user edit a tweet they did not create' do
  #       user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)
  #
  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
  #       tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)
  #
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       session = {}
  #       session[:user_id] = user1.id
  #       visit "/tweets/#{tweet2.id}/edit"
  #       expect(page.current_path).to include('/tweets')
  #     end
  #
  #     it 'lets a user edit their own tweet if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'
  #
  #       fill_in(:content, :with => "i love tweeting")
  #
  #       click_button 'submit'
  #       expect(Tweet.find_by(:content => "i love tweeting")).to be_instance_of(Tweet)
  #       expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
  #       expect(page.status_code).to eq(200)
  #     end
  #
  #     it 'does not let a user edit a text with blank content' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'
  #
  #       fill_in(:content, :with => "")
  #
  #       click_button 'submit'
  #       expect(Tweet.find_by(:content => "i love tweeting")).to be(nil)
  #       expect(page.current_path).to eq("/tweets/1/edit")
  #     end
  #   end
  #
  #   context "logged out" do
  #     it 'does not load let user view tweet edit form if not logged in' do
  #       get '/tweets/1/edit'
  #       expect(last_response.location).to include("/login")
  #     end
  #   end
  # end
  #
  # describe 'delete action' do
  #   context "logged in" do
  #     it 'lets a user delete their own tweet if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit 'tweets/1'
  #       click_button "Delete Tweet"
  #       expect(page.status_code).to eq(200)
  #       expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
  #     end
  #
  #     it 'does not let a user delete a tweet they did not create' do
  #       user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)
  #
  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
  #       tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)
  #
  #       visit '/login'
  #
  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit "tweets/#{tweet2.id}"
  #       click_button "Delete Tweet"
  #       expect(page.status_code).to eq(200)
  #       expect(Tweet.find_by(:content => "look at this tweet")).to be_instance_of(Tweet)
  #       expect(page.current_path).to include('/tweets')
  #     end
  #   end
  #
  #   context "logged out" do
  #     it 'does not load let user delete a tweet if not logged in' do
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/tweets/1'
  #       expect(page.current_path).to eq("/login")
  #     end
  #   end
  # end
end
