class Label < ApplicationRecord
    has_and_belongs_to_many :courses
    has_and_belongs_to_many :users, join_table: :user_labels
end
