class SnippetLabels < ActiveRecord::Base
  belongs_to :label
  belongs_to :snippet
end
