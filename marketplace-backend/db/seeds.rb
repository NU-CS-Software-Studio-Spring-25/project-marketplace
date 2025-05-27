# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'csv'

# Set a fixed seed for reproducible results
srand(42)

# Clear existing data
CoursePrerequisite.destroy_all
Enrollment.destroy_all
Course.destroy_all
Instructor.destroy_all
Label.destroy_all
Quarter.destroy_all
User.destroy_all

puts "Creating users..."
users = []
# Create admin user
users << User.create!(
  name: 'Admin',
  email: 'admin@example.com',
  password_digest: 'password',
)

# Create 40 fake users
40.times do |i|
  name = "User #{i + 1}"
  email = "user#{i + 1}@example.com"
  users << User.create!(
    name: name,
    email: email,
    password_digest: 'password',
  )
end

puts "Created #{User.count} users"

# Load quarters from CSV
puts "Loading quarters from CSV..."
quarter_instances = {}
CSV.foreach(Rails.root.join('data', 'quarters.csv'), headers: true) do |row|
  quarter = Quarter.create!(name: row['name'])
  quarter_instances[row['name']] = quarter
end
puts "Created #{Quarter.count} quarters"

# Load instructors from CSV
puts "Loading instructors from CSV..."
instructor_instances = {}
CSV.foreach(Rails.root.join('data', 'instructors.csv'), headers: true) do |row|
  # Generate email if not provided
  email = row['email'].present? ? row['email'] : "#{row['name'].downcase.gsub(' ', '.')}@northwestern.edu"
  
  instructor = Instructor.create!(
    name: row['name'],
    email: email
  )
  instructor_instances[row['name']] = instructor
end
puts "Created #{Instructor.count} instructors"

# Create labels (keeping the original label system)
labels = [
  { name: 'c', display_name: 'C' },
  { name: 'c_plus_plus', display_name: 'C++' },
  { name: 'core', display_name: 'Core' },
  { name: 'for_non_cs_majors', display_name: 'For Non-CS Majors' },
  { name: 'great_course_staff', display_name: 'Great Course Staff' },
  { name: 'introductory', display_name: 'Introductory' },
  { name: 'math_heavy', display_name: 'Math Heavy' },
  { name: 'object_oriented', display_name: 'Object Oriented' },
  { name: 'programming', display_name: 'Programming' },
  { name: 'projects_heavy', display_name: 'Projects Heavy' },
  { name: 'python', display_name: 'Python' },
  { name: 'racket', display_name: 'Racket' },
  { name: 'required', display_name: 'Required' },
  { name: 'systems', display_name: 'Systems' },
  { name: 'time_consuming', display_name: 'Time Consuming' },
  { name: 'data_structures', display_name: 'Data Structures' },
  { name: 'algorithms', display_name: 'Algorithms' },
  { name: 'full_stack', display_name: 'Full Stack' },
  { name: 'web_development', display_name: 'Web Development' },
  { name: 'security', display_name: 'Security' },
  { name: 'cybersecurity', display_name: 'Cybersecurity' },
  { name: 'scalability', display_name: 'Scalability' },
  { name: 'cloud', display_name: 'Cloud Computing' },
  { name: 'programming_languages', display_name: 'Programming Languages' },
  { name: 'hci', display_name: 'Human-Computer Interaction' },
  { name: 'ui', display_name: 'User Interface' },
  { name: 'ux', display_name: 'User Experience' },
  { name: 'studio_based', display_name: 'Studio-Based Learning' },
  { name: 'project_based', display_name: 'Project-Based Learning' },
  { name: 'machine_learning', display_name: 'Machine Learning' },
  { name: 'artificial_intelligence', display_name: 'Artificial Intelligence' },
  { name: 'databases', display_name: 'Databases' },
  { name: 'quantum_computing', display_name: 'Quantum Computing' },
  { name: 'blockchain', display_name: 'Blockchain' },
  { name: 'mobile_development', display_name: 'Mobile Development' },
  { name: 'embedded_systems', display_name: 'Embedded Systems' },
  { name: 'javascript', display_name: 'JavaScript' },
  { name: 'java', display_name: 'Java' },
  { name: 'theory', display_name: 'Theory' },
  { name: 'graphics', display_name: 'Computer Graphics' },
  { name: 'networking', display_name: 'Networking' },
  { name: 'distributed_systems', display_name: 'Distributed Systems' },
  { name: 'parallel_computing', display_name: 'Parallel Computing' },
  { name: 'robotics', display_name: 'Robotics' },
  { name: 'nlp', display_name: 'Natural Language Processing' },
  { name: 'computer_vision', display_name: 'Computer Vision' },
  { name: 'game_development', display_name: 'Game Development' }
]

label_instances = {}
labels.each do |l|
  label_instances[l[:name].to_sym] = Label.create!(
    name: l[:name],
    display_name: l[:display_name]
  )
end
puts "Created #{Label.count} labels"

# Load courses from CSV
puts "Loading courses from CSV..."
course_instances = {}
CSV.foreach(Rails.root.join('data', 'courses.csv'), headers: true) do |row|
  # Convert course number format from "110-0" to "COMP_SCI 110"
  course_number = "COMP_SCI #{row['course_number']}"
  
  course = Course.create!(
    course_number: course_number,
    name: row['name'],
    description: row['description']
  )
  course_instances[row['course_number']] = course
end
puts "Created #{Course.count} courses"

# Load course-instructor mappings
puts "Loading course-instructor mappings..."
CSV.foreach(Rails.root.join('data', 'course_instructor_mappings.csv'), headers: true) do |row|
  course = course_instances[row['course_number']]
  instructor = instructor_instances[row['instructor_name']]
  
  if course && instructor
    course.instructors << instructor unless course.instructors.include?(instructor)
  end
end
puts "Loaded course-instructor mappings"

# Load course-quarter mappings
puts "Loading course-quarter mappings..."
CSV.foreach(Rails.root.join('data', 'course_quarter_mappings.csv'), headers: true) do |row|
  course = course_instances[row['course_number']]
  quarter = quarter_instances[row['quarter_name']]
  
  if course && quarter
    course.quarters << quarter unless course.quarters.include?(quarter)
  end
end
puts "Loaded course-quarter mappings"

# Assign labels to courses based on course content and keywords
puts "Assigning labels to courses..."

# Define keyword mappings for automatic label assignment
label_keywords = {
  introductory: ['introduction', 'intro', 'fundamentals', 'basic'],
  programming: ['programming', 'coding', 'development'],
  systems: ['systems', 'operating', 'computer systems'],
  algorithms: ['algorithms', 'algorithm'],
  data_structures: ['data structures'],
  math_heavy: ['mathematical', 'math', 'discrete', 'foundations'],
  security: ['security', 'cryptography', 'forensics'],
  artificial_intelligence: ['artificial intelligence', 'ai'],
  machine_learning: ['machine learning', 'ml'],
  databases: ['database', 'data management'],
  networking: ['networking', 'networks', 'internet'],
  graphics: ['graphics', 'computer graphics', 'visualization'],
  hci: ['human computer interaction', 'hci', 'interaction'],
  web_development: ['web', 'internet'],
  robotics: ['robotics', 'robot'],
  theory: ['theory', 'theoretical'],
  distributed_systems: ['distributed'],
  parallel_computing: ['parallel', 'massively parallel'],
  quantum_computing: ['quantum'],
  nlp: ['natural language', 'nlp'],
  computer_vision: ['vision', 'computer vision'],
  game_development: ['game', 'games'],
  project_based: ['studio', 'practicum', 'projects'],
  required: ['fundamentals', 'required for the computer science degree']
}

course_instances.each do |course_number, course|
  course_text = "#{course.name} #{course.description}".downcase
  
  # Assign labels based on keywords
  label_keywords.each do |label_key, keywords|
    if keywords.any? { |keyword| course_text.include?(keyword) }
      label = label_instances[label_key]
      course.labels << label if label && !course.labels.include?(label)
    end
  end
  
  # Special cases for specific courses
  case course_number
  when '110-0'
    course.labels << [label_instances[:introductory], label_instances[:python], label_instances[:for_non_cs_majors]].compact
  when '111-0'
    course.labels << [label_instances[:introductory], label_instances[:programming], label_instances[:racket], label_instances[:required]].compact
  when '150-0'
    course.labels << [label_instances[:introductory], label_instances[:programming], label_instances[:python], label_instances[:object_oriented]].compact
  when '211-0'
    course.labels << [label_instances[:programming], label_instances[:c], label_instances[:c_plus_plus], label_instances[:required], label_instances[:core]].compact
  when '212-0'
    course.labels << [label_instances[:math_heavy], label_instances[:required], label_instances[:core]].compact
  when '213-0'
    course.labels << [label_instances[:c], label_instances[:systems], label_instances[:required], label_instances[:core]].compact
  when '214-0'
    course.labels << [label_instances[:programming], label_instances[:data_structures], label_instances[:algorithms], label_instances[:required], label_instances[:core]].compact
  when '303-0'
    course.labels << [label_instances[:full_stack], label_instances[:web_development], label_instances[:project_based]].compact
  when '308-0'
    course.labels << [label_instances[:security], label_instances[:cybersecurity]].compact
  when '310-0'
    course.labels << [label_instances[:systems], label_instances[:scalability], label_instances[:cloud]].compact
  when '321-0'
    course.labels << [label_instances[:programming_languages], label_instances[:racket]].compact
  when '329-0'
    course.labels << [label_instances[:hci], label_instances[:ui], label_instances[:ux], label_instances[:studio_based]].compact
  when '330-0'
    course.labels << [label_instances[:hci], label_instances[:ui], label_instances[:ux]].compact
  end
  
  # Ensure each course has at least 2-3 labels
  if course.labels.count < 2
    # Add some random relevant labels
    available_labels = label_instances.values - course.labels.to_a
    course.labels << available_labels.sample(2 - course.labels.count)
  end
end

puts "Assigned labels to courses"

# Set up some basic prerequisites for foundational courses
puts "Setting up course prerequisites..."

# Helper method to find course by number
def find_course_by_number(course_instances, number)
  course_instances[number]
end

# Basic prerequisite structure
prerequisites = {
  '150-0' => ['111-0'],
  '211-0' => ['111-0'],
  '212-0' => ['110-0', '111-0'],
  '213-0' => ['211-0'],
  '214-0' => ['111-0', '211-0'],
  '303-0' => ['213-0', '214-0'],
  '308-0' => ['211-0', '214-0'],
  '310-0' => ['213-0', '214-0'],
  '321-0' => ['111-0', '211-0', '214-0'],
  '329-0' => ['214-0'],
  '330-0' => ['214-0']
}

prerequisites.each do |course_number, prereq_numbers|
  course = course_instances[course_number]
  next unless course
  
  prereq_numbers.each do |prereq_number|
    prereq_course = course_instances[prereq_number]
    if prereq_course
      course.prerequisites << prereq_course unless course.prerequisites.include?(prereq_course)
    end
  end
end

# Add some random prerequisites for upper-level courses
course_instances.each do |course_number, course|
  course_num = course_number.split('-').first.to_i
  
  # For 300+ level courses without prerequisites, add some basic ones
  if course_num >= 300 && course.prerequisites.empty?
    # Randomly assign 1-2 foundational courses as prerequisites
    foundational_courses = ['111-0', '211-0', '212-0', '213-0', '214-0'].map { |num| course_instances[num] }.compact
    prereqs_to_add = foundational_courses.sample([1, 2].sample)
    
    prereqs_to_add.each do |prereq|
      course.prerequisites << prereq unless course.prerequisites.include?(prereq)
    end
  end
end

puts "Set up course prerequisites"

# Create some sample enrollments
puts "Creating sample enrollments..."
users.each do |user|
  next if user.email == 'admin@example.com' # Skip admin user
  
  # Each user enrolls in 2-5 random courses
  num_enrollments = rand(2..5)
  courses_to_enroll = Course.all.sample(num_enrollments)
  
  courses_to_enroll.each do |course|
    Enrollment.create!(
      user: user,
      course: course
    )
  end
end

puts "Created #{Enrollment.count} enrollments"

puts "Seeding completed successfully!"
puts "Summary:"
puts "- Users: #{User.count}"
puts "- Quarters: #{Quarter.count}"
puts "- Instructors: #{Instructor.count}"
puts "- Labels: #{Label.count}"
puts "- Courses: #{Course.count}"
puts "- Enrollments: #{Enrollment.count}"
puts "- Course Prerequisites: #{CoursePrerequisite.count}"