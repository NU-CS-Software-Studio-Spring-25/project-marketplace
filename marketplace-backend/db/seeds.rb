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

# Create 5 meaningful users
users << User.create!(
  name: 'Alice Johnson',
  email: 'alice.johnson@northwestern.edu',
  password_digest: 'password',
)

users << User.create!(
  name: 'Bob Chen',
  email: 'bob.chen@northwestern.edu',
  password_digest: 'password',
)

users << User.create!(
  name: 'Carol Martinez',
  email: 'carol.martinez@northwestern.edu',
  password_digest: 'password',
)

users << User.create!(
  name: 'David Kim',
  email: 'david.kim@northwestern.edu',
  password_digest: 'password',
)

users << User.create!(
  name: 'Emma Williams',
  email: 'emma.williams@northwestern.edu',
  password_digest: 'password',
)

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

# Create labels (student review categories)
labels = [
  # Workload & Time Management
  { name: 'minimal_homework', display_name: 'Minimal Homework' },
  { name: 'heavy_workload', display_name: 'Heavy Workload' },
  { name: 'time_consuming', display_name: 'Time Consuming' },
  { name: 'manageable_workload', display_name: 'Manageable Workload' },
  { name: 'cramming_possible', display_name: 'Cramming Possible' },
  
  # Teaching Quality & Style
  { name: 'great_professor', display_name: 'Great Professor' },
  { name: 'clear_lectures', display_name: 'Clear Lectures' },
  { name: 'engaging_material', display_name: 'Engaging Material' },
  { name: 'well_organized', display_name: 'Well Organized' },
  { name: 'responsive_instructor', display_name: 'Responsive Instructor' },
  { name: 'helpful_feedback', display_name: 'Helpful Feedback' },
  
  # Course Structure & Format
  { name: 'group_projects', display_name: 'Group Projects' },
  { name: 'individual_work', display_name: 'Individual Work' },
  { name: 'project_heavy', display_name: 'Project Heavy' },
  { name: 'exam_heavy', display_name: 'Exam Heavy' },
  { name: 'participation_matters', display_name: 'Participation Matters' },
  { name: 'attendance_required', display_name: 'Attendance Required' },
  
  # Practical Value & Relevance
  { name: 'industry_relevant', display_name: 'Industry Relevant' },
  { name: 'useful_topics', display_name: 'Useful Topics' },
  { name: 'practical_skills', display_name: 'Practical Skills' },
  { name: 'career_focused', display_name: 'Career Focused' },
  { name: 'resume_worthy', display_name: 'Resume Worthy' },
  { name: 'theoretical_focus', display_name: 'Theoretical Focus' },
  
  # Difficulty & Prerequisites
  { name: 'challenging', display_name: 'Challenging' },
  { name: 'easy_A', display_name: 'Easy A' },
  { name: 'beginner_friendly', display_name: 'Beginner Friendly' },
  { name: 'requires_math_background', display_name: 'Requires Math Background' },
  { name: 'programming_intensive', display_name: 'Programming Intensive' },
  { name: 'conceptually_difficult', display_name: 'Conceptually Difficult' },
  
  # Support & Resources
  { name: 'helpful_TAs', display_name: 'Helpful TAs' },
  { name: 'office_hours_available', display_name: 'Office Hours Available' },
  { name: 'good_resources', display_name: 'Good Resources' },
  { name: 'active_piazza', display_name: 'Active Piazza' },
  
  # Overall Experience
  { name: 'fun_course', display_name: 'Fun Course' },
  { name: 'interesting_topics', display_name: 'Interesting Topics' },
  { name: 'dry_material', display_name: 'Dry Material' },
  { name: 'would_recommend', display_name: 'Would Recommend' },
  { name: 'skip_if_possible', display_name: 'Skip If Possible' },
  { name: 'life_changing', display_name: 'Life Changing' },
  
  # Special Categories
  { name: 'required_course', display_name: 'Required Course' },
  { name: 'good_for_non_majors', display_name: 'Good for Non-Majors' },
  { name: 'research_opportunities', display_name: 'Research Opportunities' },
  { name: 'networking_opportunities', display_name: 'Networking Opportunities' },
  
  # General Topic Categories
  { name: 'artificial_intelligence', display_name: 'Artificial Intelligence' },
  { name: 'machine_learning', display_name: 'Machine Learning' },
  { name: 'computer_systems', display_name: 'Computer Systems' },
  { name: 'software_engineering', display_name: 'Software Engineering' },
  { name: 'algorithms_data_structures', display_name: 'Algorithms & Data Structures' },
  { name: 'cybersecurity', display_name: 'Cybersecurity' },
  { name: 'web_development', display_name: 'Web Development' },
  { name: 'mobile_development', display_name: 'Mobile Development' },
  { name: 'databases', display_name: 'Databases' },
  { name: 'human_computer_interaction', display_name: 'Human-Computer Interaction' },
  { name: 'computer_graphics', display_name: 'Computer Graphics' },
  { name: 'networking', display_name: 'Networking' },
  { name: 'programming_languages', display_name: 'Programming Languages' },
  { name: 'theory_mathematics', display_name: 'Theory & Mathematics' },
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

# Assign labels to courses based on student review patterns
puts "Assigning labels to courses..."

# Define keyword mappings for automatic label assignment based on course descriptions
label_keywords = {
  beginner_friendly: ['introduction', 'intro', 'fundamentals', 'basic', 'beginning'],
  programming_intensive: ['programming', 'coding', 'development', 'software'],
  requires_math_background: ['mathematical', 'math', 'discrete', 'calculus', 'statistics'],
  theoretical_focus: ['theory', 'theoretical', 'foundations', 'principles'],
  practical_skills: ['practical', 'hands-on', 'real-world', 'industry'],
  project_heavy: ['project', 'projects', 'studio', 'practicum'],
  challenging: ['advanced', 'complex', 'difficult', 'rigorous'],
  industry_relevant: ['industry', 'professional', 'career', 'workplace'],
  group_projects: ['team', 'group', 'collaborative', 'cooperation'],
  research_opportunities: ['research', 'investigation', 'exploration'],
  
  # Topic-based keywords
  artificial_intelligence: ['artificial intelligence', 'ai', 'intelligent systems'],
  machine_learning: ['machine learning', 'ml', 'neural networks', 'deep learning'],
  computer_systems: ['systems', 'operating systems', 'computer systems', 'system design'],
  software_engineering: ['software engineering', 'agile', 'development process', 'software design'],
  algorithms_data_structures: ['algorithms', 'data structures', 'algorithm design'],
  cybersecurity: ['security', 'cybersecurity', 'cryptography', 'forensics'],
  web_development: ['web', 'internet', 'web development', 'full stack'],
  databases: ['database', 'data management', 'sql'],
  human_computer_interaction: ['human computer interaction', 'hci', 'user interface', 'ux'],
  computer_graphics: ['graphics', 'computer graphics', 'visualization', 'rendering'],
  networking: ['networking', 'networks', 'distributed systems'],
  programming_languages: ['programming languages', 'language design', 'compilers'],
  theory_mathematics: ['mathematical foundations', 'discrete math', 'theoretical computer science'],
  game_development: ['game', 'games', 'interactive media']
}

course_instances.each do |course_number, course|
  # Define special courses that have specific label assignments
  special_courses = ['110-0', '111-0', '150-0', '211-0', '212-0', '213-0', '214-0', '303-0', '308-0', '310-0', '321-0', '329-0', '330-0']
  
  # Only apply keyword matching to non-special courses
  unless special_courses.include?(course_number)
    course_text = "#{course.name} #{course.description}".downcase
    
    # Assign labels based on keywords
    label_keywords.each do |label_key, keywords|
      if keywords.any? { |keyword| course_text.include?(keyword) }
        label = label_instances[label_key]
        course.labels << label if label && !course.labels.include?(label)
      end
    end
  end
  
  # Special cases for specific courses based on typical student experiences
  case course_number
  when '110-0' # Intro Programming for non-majors
    course.labels << [
      label_instances[:beginner_friendly], 
      label_instances[:good_for_non_majors],
      label_instances[:manageable_workload],
      label_instances[:practical_skills]
    ].compact
  when '111-0' # Fundamentals of CS
    course.labels << [
      label_instances[:required_course], 
      label_instances[:beginner_friendly],
      label_instances[:programming_intensive]
    ].compact
  when '150-0' # Intro to OOP
    course.labels << [
      label_instances[:beginner_friendly],
      label_instances[:office_hours_available],
      label_instances[:dry_material]
    ].compact
  when '211-0' # Fundamentals of Programming
    course.labels << [
      label_instances[:required_course], 
      label_instances[:programming_intensive],
      label_instances[:challenging],
      label_instances[:time_consuming],
      label_instances[:helpful_TAs],
      label_instances[:great_professor]
    ].compact
  when '212-0' # Mathematical Foundations
    course.labels << [
      label_instances[:required_course], 
      label_instances[:requires_math_background],
      label_instances[:theoretical_focus],
      label_instances[:dry_material],
      label_instances[:theory_mathematics]
    ].compact
  when '213-0' # Computer Systems
    course.labels << [
      label_instances[:required_course], 
      label_instances[:challenging],
      label_instances[:programming_intensive],
      label_instances[:useful_topics],
      label_instances[:computer_systems],
      label_instances[:great_professor]
    ].compact
  when '214-0' # Data Structures
    course.labels << [
      label_instances[:required_course], 
      label_instances[:programming_intensive],
      label_instances[:exam_heavy],
      label_instances[:algorithms_data_structures]
    ].compact
  when '303-0' # Agile Software Development
    course.labels << [
      label_instances[:project_heavy], 
      label_instances[:group_projects],
      label_instances[:industry_relevant],
      label_instances[:practical_skills],
      label_instances[:software_engineering],
      label_instances[:web_development]
    ].compact
  when '308-0' # Security
    course.labels << [
      label_instances[:interesting_topics], 
      label_instances[:industry_relevant],
      label_instances[:resume_worthy],
      label_instances[:challenging],
      label_instances[:cybersecurity],
      label_instances[:great_professor]
    ].compact
  when '310-0' # Scalable Systems
    course.labels << [
      label_instances[:easy_A], 
      label_instances[:industry_relevant],
      label_instances[:career_focused],
      label_instances[:software_engineering],
      label_instances[:great_professor]
    ].compact
  when '321-0' # Programming Languages
    course.labels << [
      label_instances[:theoretical_focus], 
      label_instances[:conceptually_difficult],
      label_instances[:interesting_topics],
      label_instances[:programming_intensive],
      label_instances[:programming_languages]
    ].compact
  when '329-0' # Human-Computer Interaction
    course.labels << [
      label_instances[:fun_course], 
      label_instances[:project_heavy],
      label_instances[:group_projects],
      label_instances[:human_computer_interaction],
    ].compact
  when '330-0' # Human-Computer Interaction
    course.labels << [
      label_instances[:interesting_topics],
      label_instances[:engaging_material],
      label_instances[:human_computer_interaction],
      label_instances[:easy_A]
    ].compact
  end
  
  # Add some random positive/negative labels to make it more realistic
  # But exclude courses that already have specific assignments
  unless special_courses.include?(course_number)
    course_number_int = course_number.split('-').first.to_i
    
    # Lower level courses (100-200) tend to be more structured
    if course_number_int < 300
      possible_labels = [
        label_instances[:well_organized],
        label_instances[:helpful_TAs],
        label_instances[:clear_lectures],
        label_instances[:office_hours_available]
      ]
      course.labels << possible_labels.sample(rand(1..2))
    else
      # Upper level courses have more varied experiences
      possible_labels = [
        label_instances[:would_recommend],
        label_instances[:great_professor],
        label_instances[:engaging_material],
        label_instances[:research_opportunities],
        label_instances[:networking_opportunities]
      ]
      course.labels << possible_labels.sample(rand(1..2))
    end
    
    # Ensure each course has at least 3-4 labels
    if course.labels.count < 3
      available_labels = label_instances.values - course.labels.to_a
      course.labels << available_labels.sample(3 - course.labels.count)
    end
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

puts "Seeding completed successfully!"
puts "Summary:"
puts "- Users: #{User.count}"
puts "- Quarters: #{Quarter.count}"
puts "- Instructors: #{Instructor.count}"
puts "- Labels: #{Label.count}"
puts "- Courses: #{Course.count}"
puts "- Course Prerequisites: #{CoursePrerequisite.count}"