class User < ApplicationRecord
    # has_secure_password
    has_many :enrollments
    has_many :courses, through: :enrollments
    has_and_belongs_to_many :labels, join_table: :user_labels
end
