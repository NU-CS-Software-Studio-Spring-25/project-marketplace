class Course < ApplicationRecord
    has_and_belongs_to_many :instructors
    has_and_belongs_to_many :quarters
    has_and_belongs_to_many :labels
    
    has_many :course_prerequisites
    has_many :prerequisites, through: :course_prerequisites, source: :prerequisite
end
