class SakeTasteTag < ApplicationRecord
  belongs_to :sake
  belongs_to :taste_tag
end
