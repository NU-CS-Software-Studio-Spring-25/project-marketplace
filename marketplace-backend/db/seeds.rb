# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Add Faker gem if not already included
# Make sure to add gem 'faker' to your Gemfile and run bundle install
require 'faker'

# Set a fixed seed for reproducible results
Faker::Config.random = Random.new(42)

# Clear existing data
CoursePrerequisite.destroy_all
Enrollment.destroy_all
Course.destroy_all
Instructor.destroy_all
Label.destroy_all
Quarter.destroy_all
User.destroy_all

# Create users
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
  name = Faker::Name.name
  email = Faker::Internet.email(name: name)
  users << User.create!(
    name: name,
    email: email,
    password_digest: 'password',
  )
end

puts "Created #{User.count} users"

# Create quarters
quarters = ['Fall', 'Winter', 'Spring', 'Summer']
quarter_instances = {}
quarters.each do |q|
  quarter_instances[q.downcase.to_sym] = Quarter.create!(name: q)
end

# Create instructors
# Original instructors
instructors = [
  { name: 'Branden Ghena', email: 'branden.ghena@northwestern.edu' },
  { name: 'Joe Hummel', email: 'joe.hummel@northwestern.edu' },
  { name: 'Sara Owsley Sood', email: 'sara.sood@northwestern.edu' },
  { name: 'Aravindan Vijayaraghavan', email: 'aravindan.vijayaraghavan@northwestern.edu' },
  { name: 'Miklos Racz', email: 'miklos.racz@northwestern.edu' },
  { name: 'Anjali Agarwal', email: 'anjali.agarwal@northwestern.edu' },
  { name: 'Peter Dinda', email: 'pdinda@northwestern.edu' },
  { name: 'Nikos Hardavellas', email: 'nikos.hardavellas@northwestern.edu' },
  { name: 'Michael Horn', email: 'michael.horn@northwestern.edu' },
  { name: 'Connor Bain', email: 'connor.bain@northwestern.edu' },
  { name: 'Aleksandar Kuzmanovic', email: 'aleksandar.kuzmanovic@northwestern.edu' },
  { name: 'Jack Tumblin', email: 'jack.tumblin@northwestern.edu' },
  { name: 'Michalis Mamakos', email: 'michalis.mamakos@northwestern.edu' },
  { name: 'Anastasia Kurdia', email: 'anastasia.kurdia@northwestern.edu' },
  { name: 'Dietrich Geisler', email: 'dietrich.geisler@northwestern.edu' },
  { name: 'Ian Horswill', email: 'ian.horswill@northwestern.edu' },
  { name: 'Vincent St-Amour', email: 'vincent.stamour@northwestern.edu' },
  { name: 'Sruti Bhagavatula', email: 'sruti.bhagavatula@northwestern.edu' },
  { name: 'Lydia Tse', email: 'lydia.tse@northwestern.edu' },
  { name: 'Robby Findler', email: 'robby.findler@northwestern.edu' },
  { name: 'Christos Dimoulas', email: 'christos.dimoulas@northwestern.edu' },
  { name: 'Maia Jacobs', email: 'maia.jacobs@northwestern.edu' },
  { name: 'Haoqi Zhang', email: 'haoqi.zhang@northwestern.edu' },
  { name: 'O\'Rourke', email: 'orourke@northwestern.edu' },
  { name: 'Matthew Kay', email: 'matthew.kay@northwestern.edu' },
  { name: 'Victoria Chávez', email: 'victoria.chavez@northwestern.edu' }
]

# Add 20 more fictional instructors
20.times do
  instructors << {
    name: Faker::Name.name,
    email: Faker::Internet.email(domain: 'northwestern.edu')
  }
end

instructor_instances = {}
instructors.each do |i|
  instructor_instances[i[:name].downcase.gsub(' ', '_').to_sym] = Instructor.create!(i)
end

# Create labels
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
  { name: 'project_based', display_name: 'Project-Based Learning' }
]

# Add 10 more fictional labels
additional_labels = [
  { name: 'machine_learning', display_name: 'Machine Learning' },
  { name: 'artificial_intelligence', display_name: 'Artificial Intelligence' },
  { name: 'databases', display_name: 'Databases' },
  { name: 'quantum_computing', display_name: 'Quantum Computing' },
  { name: 'blockchain', display_name: 'Blockchain' },
  { name: 'mobile_development', display_name: 'Mobile Development' },
  { name: 'embedded_systems', display_name: 'Embedded Systems' },
  { name: 'javascript', display_name: 'JavaScript' },
  { name: 'java', display_name: 'Java' },
  { name: 'theory', display_name: 'Theory' }
]

labels.concat(additional_labels)

label_instances = {}
labels.each do |l|
  label_instances[l[:name].to_sym] = Label.create!(
    name: l[:name],
    display_name: l[:display_name]
  )
end

# =============== ORIGINAL COURSES ===============
# Create original courses
comp_sci_110 = Course.create!(
  course_number: 'COMP_SCI 110',
  name: 'Intro to Computer Programming',
  description: 'Introduction to programming practice using Python. Analysis and formulation of problems for computer solution. Systematic design, construction, and testing of programs. Substantial programming assignments in Python. This introductory programming course is not part of the major. It provides an introduction to programming for those that can benefit from becoming better programmers, but without committing to the major student\'s version of the course.'
)

comp_sci_111 = Course.create!(
  course_number: 'COMP_SCI 111',
  name: 'Fundamentals of Computer Programming I',
  description: 'This is an introductory course on the fundamentals of computer programming. I see this class as an opportunity for you, the student, to see what computer programming is all about and (more importantly) to see whether you want to spend the next few years doing more of it. This course will include weekly programming projects, readings, a midterm, and final examinations. Class participation is not optional.'
)

comp_sci_150 = Course.create!(
  course_number: 'COMP_SCI 150',
  name: 'Fundamentals of Computer Programming 1.5',
  description: 'Intended for students who have completed COMP_SCI 111, but don\'t have any other formal Computer Science background. It will provide an introduction to object-oriented programming in Python, preparing students for future courses such as COMP_SCI 211. Students should NOT take this course if they have completed the AP Computer Science course or have substantial experience programming in languages such as Java, Python or C++. Students are strongly advised to take CS 150 before CS 211.'
)

comp_sci_211 = Course.create!(
  course_number: 'COMP_SCI 211',
  name: 'Fundamentals of Computer Programming II',
  description: 'CS 211 teaches foundational software design skills at a small-to-medium scale. We aim to provide a bridge from the student-oriented *How to Design Programs* languages to real, industry-standard languages and tools. In the first half of the course, you\'ll learn the basics of imperative programming and manual memory management using the C programming language. In the second half of the course, we\'ll transition to C++, which provides abstraction mechanisms such as classes and templates that we use to express our design ideas.'
)

comp_sci_212 = Course.create!(
  course_number: 'COMP_SCI 212',
  name: 'Mathematical Foundations of CS Part 1: Discrete mathematics for computer science',
  description: 'This course will discuss fundamental concepts and tools in discrete mathematics with emphasis on their applications to computer science. Example topics include logic and Boolean circuits; sets, functions, relations, databases, and finite automata; deterministic algorithms and randomized algorithms; analysis techniques based on counting methods and recurrence equations; trees and more general graphs.'
)

comp_sci_213 = Course.create!(
  course_number: 'COMP_SCI 213',
  name: 'Intro to Computer Systems',
  description: 'This course has four purposes: (1) to learn about the hierarchy of abstractions and implementations that comprise a modern computer system; (2) to demystify the machine and the tools that we use to program it; (3) to come up to speed on systems programming in C in the Unix environment; (4) to prepare students for upper-level systems courses.'
)

comp_sci_214 = Course.create!(
  course_number: 'COMP_SCI 214',
  name: 'Data Structures and Algorithms',
  description: 'The design, implementation, and analysis of abstract data types, data structures and their algorithms. Topics include: data and procedural abstraction, amortized data structures, trees and search trees, hash tables, priority queues, graphs, shortest paths, searching, and sorting. Required for computer science majors.'
)

comp_sci_303 = Course.create!(
  course_number: 'COMP_SCI 303',
  name: 'Full Stack Software Engineering',
  description: 'Modern software frameworks such as Next.js, Django, and Spring Boot provide the foundational components to quickly develop and deploy full-stack software applications. These frameworks, which are reusable abstractions of code wrapped in well-defined Application Programming Interfaces (APIs), provide several benefits for software developers, such as easier development and maintenance, standardization and compatibility, improved security, increased productivity, and easier collaboration. In this course we will explore one of these frameworks to create, iteratively refine, and deploy a real-world application.'
)

comp_sci_308 = Course.create!(
  course_number: 'COMP_SCI 308',
  name: 'Foundations of Security',
  description: 'The goal of this class is to provide a practical, defense-focused introduction to security foundations. We will cover a variety of topics including (but not limited to) threat modeling, security of applications, authentication, cryptography, access control, data security, social engineering, and ethics of cybersecurity decisions (or lack, thereof). For a portion of the class, we will work with web applications, however, we do not expect any prior background and will provide required background as needed.'
)

comp_sci_310 = Course.create!(
  course_number: 'COMP_SCI 310',
  name: 'Scalable Software Architectures',
  description: 'We\'ll study the architecture of high-scale Internet services, using well-known case studies like Google Search, Netflix, and Uber. System at these scales have many custom-built components, but they also contain many common building blocks that can be reused in other systems. Students will apply lessons learned from case studies to build software systems in the cloud capable of scaling to millions of users, and they will do so with surprisingly little code.'
)

comp_sci_321 = Course.create!(
  course_number: 'COMP_SCI 321',
  name: 'Programming Languages',
  description: 'This course introduces students to the key features of programming languages. Students implement a series of interpreters that nail down the precise details of how various aspects of programming languages behave. Students are assumed to understand trees and (mathematical) functions that process them; the course builds up to the features of real programming languages from there.'
)

comp_sci_329 = Course.create!(
  course_number: 'COMP_SCI 329',
  name: 'HCI Studio',
  description: 'Human-Computer Interaction (HCI) serves as the bridge between computing and humanity. The effective design of HCI systems requires a keen understanding of how interfaces and computer systems usefully support human endeavors (or not). Through the studio method, we will, as a learning community, learn to ask and answer these questions for ourselves. One focus will be on developing our critical thinking and problem solving skills through team projects and studio critique, with special emphasis on learning more effective structures and representations for thinking about the design of HCI systems.'
)

comp_sci_330 = Course.create!(
  course_number: 'COMP_SCI 330',
  name: 'Human Computer Interaction',
  description: 'Introduction to human-computer interaction and the design of systems that work for people and their organizations. The goal is to understand the manner in which humans interact with, and use, their computers for productive work. The course focus is on the interface as designed artifact. The interface is a design problem without a single "correct" solution but which has many "good" solutions and a plethora of "bad" solutions.'
)

# =============== ADDITIONAL COURSES ===============
# Create 40 more courses with realistic CS course titles and descriptions using Faker
additional_courses = []

# Course topic components for generating realistic course names
course_topics = [
  ['Advanced', 'Introduction to', 'Foundations of', 'Topics in', 'Seminar in', 'Principles of', 'Studies in'],
  ['Artificial Intelligence', 'Machine Learning', 'Computer Vision', 'Natural Language Processing', 
   'Robotics', 'Data Science', 'Algorithms', 'Systems Programming', 'Database Systems', 
   'Computer Networks', 'Operating Systems', 'Computer Security', 'Software Engineering',
   'Web Development', 'Mobile Computing', 'Game Development', 'Computer Graphics',
   'Human-Computer Interaction', 'Distributed Systems', 'Parallel Computing',
   'Cloud Computing', 'Blockchain', 'Quantum Computing', 'Compilers', 'Programming Languages']
]

# CS course descriptions templates
course_description_templates = [
  "This course explores %s. Students will learn about %s, %s, and %s. The course includes practical assignments where students apply theoretical concepts to real-world problems.",
  "An introduction to the principles of %s, focusing on %s and %s. Students will implement various algorithms and techniques including %s and %s.",
  "This course provides a comprehensive overview of %s. Topics include %s, %s, and %s. Students will complete a significant project demonstrating mastery of key concepts.",
  "Advanced topics in %s with emphasis on %s. The course covers theoretical foundations including %s as well as practical applications such as %s and %s.",
  "A hands-on course focused on %s. Students will gain experience with %s and %s while working on team-based projects involving %s.",
  "This course examines the intersection of %s and %s. Topics include %s, %s, and emerging research in %s. Students will analyze and implement current techniques in the field."
]

# Generate topic components for descriptions
ai_topics = ['neural networks', 'deep learning', 'reinforcement learning', 'computer vision', 'natural language processing', 'knowledge representation', 'expert systems', 'machine perception']
systems_topics = ['operating system design', 'distributed computing', 'concurrency', 'virtualization', 'memory management', 'file systems', 'networking protocols', 'system security']
programming_topics = ['algorithm analysis', 'data structures', 'software design patterns', 'language semantics', 'type systems', 'compilers', 'interpreters', 'runtime systems']
security_topics = ['cryptography', 'authentication', 'access control', 'network security', 'penetration testing', 'secure coding', 'threat modeling', 'security protocols']
data_topics = ['database design', 'query optimization', 'big data processing', 'data mining', 'data warehousing', 'NoSQL systems', 'data analytics', 'information retrieval']
general_topics = ai_topics + systems_topics + programming_topics + security_topics + data_topics

# Create 40 additional courses
# Extract existing course numbers from original courses
existing_course_numbers = Course.all.pluck(:course_number).map { |cn| cn.split(' ').last.to_i }

# Filter out existing course numbers from the available range
available_numbers = (301..499).to_a - existing_course_numbers

# Sample 40 unique numbers from remaining available numbers
course_numbers = available_numbers.sample(40)
course_numbers.sort!

40.times do |i|
  # Generate course number and name
  course_number = course_numbers[i]
  prefix = course_topics[0].sample
  main_topic = course_topics[1].sample
  course_name = "#{prefix} #{main_topic}"
  
  # Generate course description using templates
  template = course_description_templates.sample
  main_subject = main_topic.downcase
  subtopics = general_topics.sample(4)
  description = format(template, main_subject, *subtopics)
  
  # Create the course
  course = Course.create!(
    course_number: "COMP_SCI #{course_number}",
    name: course_name,
    description: description
  )
  
  additional_courses << course
end

# =============== ASSIGN INSTRUCTORS, LABELS, AND QUARTERS TO COURSES ===============
puts "Assigning instructors, labels, and quarters to courses..."

# Get all courses
all_courses = Course.all.to_a

# For the original courses, specifically assign relevant labels and instructors
comp_sci_110.labels << [label_instances[:introductory], label_instances[:python], label_instances[:for_non_cs_majors]]
comp_sci_110.instructors << instructor_instances[:connor_bain] if instructor_instances[:connor_bain]
comp_sci_110.instructors << instructor_instances[:sara_owsley_sood] if instructor_instances[:sara_owsley_sood]
comp_sci_110.quarters << [quarter_instances[:fall], quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_111.labels << [label_instances[:introductory], label_instances[:programming], label_instances[:racket], label_instances[:required]]
comp_sci_111.instructors << instructor_instances[:robby_findler] if instructor_instances[:robby_findler]
comp_sci_111.instructors << instructor_instances[:christos_dimoulas] if instructor_instances[:christos_dimoulas]
comp_sci_111.quarters << [quarter_instances[:fall], quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_150.labels << [label_instances[:introductory], label_instances[:programming], label_instances[:python], label_instances[:object_oriented]]
comp_sci_150.instructors << instructor_instances[:connor_bain] if instructor_instances[:connor_bain]
comp_sci_150.instructors << instructor_instances[:ian_horswill] if instructor_instances[:ian_horswill]
comp_sci_150.quarters << [quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_211.labels << [label_instances[:programming], label_instances[:c], label_instances[:c_plus_plus], label_instances[:required], label_instances[:core]]
comp_sci_211.instructors << instructor_instances[:branden_ghena] if instructor_instances[:branden_ghena]
comp_sci_211.instructors << instructor_instances[:sara_owsley_sood] if instructor_instances[:sara_owsley_sood]
comp_sci_211.quarters << [quarter_instances[:fall], quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_212.labels << [label_instances[:math_heavy], label_instances[:required], label_instances[:core]]
comp_sci_212.instructors << instructor_instances[:miklos_racz] if instructor_instances[:miklos_racz]
comp_sci_212.instructors << instructor_instances[:aravindan_vijayaraghavan] if instructor_instances[:aravindan_vijayaraghavan]
comp_sci_212.quarters << [quarter_instances[:fall], quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_213.labels << [label_instances[:c], label_instances[:systems], label_instances[:required], label_instances[:core]]
comp_sci_213.instructors << instructor_instances[:peter_dinda] if instructor_instances[:peter_dinda]
comp_sci_213.instructors << instructor_instances[:nikos_hardavellas] if instructor_instances[:nikos_hardavellas]
comp_sci_213.quarters << [quarter_instances[:fall], quarter_instances[:spring]]

comp_sci_214.labels << [label_instances[:programming], label_instances[:data_structures], label_instances[:algorithms], label_instances[:required], label_instances[:core]]
comp_sci_214.instructors << instructor_instances[:vincent_st_amour] if instructor_instances[:vincent_st_amour] 
comp_sci_214.instructors << instructor_instances[:joe_hummel] if instructor_instances[:joe_hummel]
comp_sci_214.quarters << [quarter_instances[:fall], quarter_instances[:winter], quarter_instances[:spring]]

comp_sci_303.labels << [label_instances[:full_stack], label_instances[:web_development], label_instances[:project_based]]
comp_sci_303.instructors << instructor_instances[:joe_hummel] if instructor_instances[:joe_hummel]
comp_sci_303.quarters << [quarter_instances[:fall], quarter_instances[:spring]]

comp_sci_308.labels << [label_instances[:security], label_instances[:cybersecurity]]
comp_sci_308.instructors << instructor_instances[:sruti_bhagavatula] if instructor_instances[:sruti_bhagavatula]
comp_sci_308.quarters << [quarter_instances[:winter]]

comp_sci_310.labels << [label_instances[:systems], label_instances[:scalability], label_instances[:cloud]]
comp_sci_310.instructors << instructor_instances[:aleksandar_kuzmanovic] if instructor_instances[:aleksandar_kuzmanovic]
comp_sci_310.quarters << [quarter_instances[:fall]]

comp_sci_321.labels << [label_instances[:programming_languages], label_instances[:racket]]
comp_sci_321.instructors << instructor_instances[:robby_findler] if instructor_instances[:robby_findler]
comp_sci_321.instructors << instructor_instances[:christos_dimoulas] if instructor_instances[:christos_dimoulas]
comp_sci_321.quarters << [quarter_instances[:winter]]

comp_sci_329.labels << [label_instances[:hci], label_instances[:ui], label_instances[:ux], label_instances[:studio_based]]
comp_sci_329.instructors << instructor_instances[:haoqi_zhang] if instructor_instances[:haoqi_zhang]
comp_sci_329.instructors << instructor_instances[:michael_horn] if instructor_instances[:michael_horn]
comp_sci_329.quarters << [quarter_instances[:spring]]

comp_sci_330.labels << [label_instances[:hci], label_instances[:ui], label_instances[:ux]]
comp_sci_330.instructors << instructor_instances[:maia_jacobs] if instructor_instances[:maia_jacobs]
comp_sci_330.instructors << instructor_instances[:matthew_kay] if instructor_instances[:matthew_kay]
comp_sci_330.quarters << [quarter_instances[:fall], quarter_instances[:winter]]

# For additional courses, assign random instructors, labels, and quarters
additional_courses.each do |course|
  # Assign 1-3 random instructors from available instructors
  valid_instructors = instructor_instances.values.compact
  course.instructors << valid_instructors.sample(rand(1..3))
  
  # Assign 2-5 random labels
  course.labels << label_instances.values.sample(rand(2..5))
  
  # Assign 1-4 random quarters
  course.quarters << quarter_instances.values.sample(rand(1..4))
end

puts "Assigned instructors, labels, and quarters to all courses"

# =============== SET UP PREREQUISITES ===============
# Original prerequisites
comp_sci_150.prerequisites << comp_sci_111
comp_sci_211.prerequisites << comp_sci_111
comp_sci_211.prerequisites << comp_sci_150
comp_sci_212.prerequisites << comp_sci_110
comp_sci_212.prerequisites << comp_sci_111
comp_sci_213.prerequisites << comp_sci_211
comp_sci_214.prerequisites << comp_sci_111
comp_sci_214.prerequisites << comp_sci_211
comp_sci_303.prerequisites << comp_sci_213
comp_sci_303.prerequisites << comp_sci_214
comp_sci_308.prerequisites << comp_sci_211
comp_sci_308.prerequisites << comp_sci_214
comp_sci_310.prerequisites << comp_sci_213
comp_sci_310.prerequisites << comp_sci_214
comp_sci_321.prerequisites << comp_sci_111
comp_sci_321.prerequisites << comp_sci_211
comp_sci_321.prerequisites << comp_sci_214
comp_sci_329.prerequisites << comp_sci_214
comp_sci_330.prerequisites << comp_sci_214

# Randomly assign prerequisites to additional courses
basic_courses = [comp_sci_111, comp_sci_211, comp_sci_212, comp_sci_213, comp_sci_214]
all_courses = [comp_sci_110, comp_sci_111, comp_sci_150, comp_sci_211, comp_sci_212, comp_sci_213, comp_sci_214, 
              comp_sci_303, comp_sci_308, comp_sci_310, comp_sci_321, comp_sci_329, comp_sci_330]

additional_courses.each do |course|
  # Skip some courses to have courses without prerequisites (about 20%)
  next if Faker::Boolean.boolean(true_ratio: 0.2)
  
  # Determine number of prerequisites (1-3)
  num_prereqs = rand(1..3)
  
  # For 300-level courses, use basic courses as prerequisites
  if course.course_number.include?('3')
    prereq_pool = basic_courses
  else
    # For 400-level courses, can use any course as prerequisite except itself and ensuring no circular dependencies
    # (assuming course numbers reflect dependency hierarchy)
    prereq_pool = all_courses + additional_courses.select { |c| c.course_number.split(' ').last.to_i < course.course_number.split(' ').last.to_i }
    prereq_pool.delete(course) # Remove self
  end
  
  # Assign random prerequisites
  prereq_pool.sample(num_prereqs).each do |prereq|
    course.prerequisites << prereq unless course.prerequisites.include?(prereq)
  end
end