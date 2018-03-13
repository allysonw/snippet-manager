# Specifications for the Sinatra Assessment

Specs:
- [X] Use Sinatra to build the app
Class ApplicationController inherits from Sinatra::Base and all other controllers inherit from ApplicationController.
- [X] Use ActiveRecord for storing information in a database
Created 3 tables to hold Users, Snippets, and Labels, and 1 join table to associate Snippets and Labels.
- [X] Include more than one model class (list of model class names e.g. User, Post, Category)
Created 4 model classes: User, Snippet, Label, and Snippet_Label
- [X] Include at least one has_many relationship (x has_many y e.g. User has_many Posts)
User has many Snippets
User has many Labels through Snippets
Snippet has many SnippetLabels, and has many Labels through SnippetLabels
Label has many SnippetLabels, and has many Snippets through SnippetLabels
- [X] Include user accounts
Users can log in and log out
- [X] Ensure that users can't modify content created by other users
Edit and delete buttons on the individual snippet show page (lists a single snippet) are only shown if the snippet belongs to the current user. Also, in snippets_controller, I check if the snippet referenced by ID in the GET snippets/:id/edit request belongs to the logged in user before loading the snippet edit view. Finally, in the user's controller, upon a request to /snippets (loads the user's show page, listing all of their snippets), I retrieve only the current user's snippets before loading the show page.
- [X] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying
Snippets belong to users and can be created, read, updated, and deleted. Snippets can be created using a button in the navbar. Snippets can be edited and deleted from the user's show page (list of all a user's snippets), or from an individual snippet show page (lists a single snippet).
- [X] Include user input validations
I use Bootstrap forms for input validation and mark required fields as such in the forms. I use Bootstrap email validation for user emails. On creating an editing a snippet, a user is warned that pertinent fields are required. I use the ActiveRecord validation validates_presence_of on all tables to ensure no new objects are persisted with any blank fields.
- [X] Display validation failures to user with error message (example form URL e.g. /posts/new)v
- [ ] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [X] You have a large number of small Git commits
- [X] Your commit messages are meaningful
- [X] You made the changes in a commit that relate to the commit message
- [X] You don't include changes in a commit that aren't related to the commit message
