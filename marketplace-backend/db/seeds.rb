# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
CoursePrerequisite.destroy_all
Course.destroy_all
Instructor.destroy_all
Label.destroy_all
Quarter.destroy_all

# Create quarters
quarters = ['Fall', 'Winter', 'Spring', 'Summer']
quarter_instances = {}
quarters.each do |q|
  quarter_instances[q.downcase.to_sym] = Quarter.create!(name: q)
end

# Create instructors
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
  { name: 'Ian Horswill', email: 'ian.horswill@northwestern.edu' }
]
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
]

label_instances = {}
labels.each do |l|
  label_instances[l[:name].to_sym] = Label.create!(
    name: l[:name],
    display_name: l[:display_name]
  )
end
# Create courses
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

# Set up prerequisites
comp_sci_150.prerequisites << comp_sci_111
comp_sci_211.prerequisites << comp_sci_111
comp_sci_211.prerequisites << comp_sci_150
comp_sci_212.prerequisites << comp_sci_110
comp_sci_212.prerequisites << comp_sci_111
comp_sci_213.prerequisites << comp_sci_211

# Set up instructor associations
comp_sci_110.instructors << instructor_instances[:michael_horn]
comp_sci_110.instructors << instructor_instances[:connor_bain]
comp_sci_110.instructors << instructor_instances[:aleksandar_kuzmanovic]
comp_sci_110.instructors << instructor_instances[:michalis_mamakos]
comp_sci_110.instructors << instructor_instances[:jack_tumblin]

comp_sci_111.instructors << instructor_instances[:connor_bain]
comp_sci_111.instructors << instructor_instances[:sara_owsley_sood]
comp_sci_111.instructors << instructor_instances[:ian_horswill]

comp_sci_150.instructors << instructor_instances[:anastasia_kurdia]
comp_sci_150.instructors << instructor_instances[:dietrich_geisler]
comp_sci_150.instructors << instructor_instances[:sara_owsley_sood]

comp_sci_211.instructors << instructor_instances[:branden_ghena]
comp_sci_211.instructors << instructor_instances[:joe_hummel]
comp_sci_211.instructors << instructor_instances[:sara_owsley_sood]

comp_sci_212.instructors << instructor_instances[:aravindan_vijayaraghavan]
comp_sci_212.instructors << instructor_instances[:miklos_racz]
comp_sci_212.instructors << instructor_instances[:anjali_agarwal]

comp_sci_213.instructors << instructor_instances[:peter_dinda]
comp_sci_213.instructors << instructor_instances[:branden_ghena]
comp_sci_213.instructors << instructor_instances[:nikos_hardavellas]

# Set up quarter offerings
comp_sci_110.quarters << quarter_instances[:fall]
comp_sci_110.quarters << quarter_instances[:winter]
comp_sci_110.quarters << quarter_instances[:spring]
comp_sci_110.quarters << quarter_instances[:summer]

comp_sci_111.quarters << quarter_instances[:fall]
comp_sci_111.quarters << quarter_instances[:winter]
comp_sci_111.quarters << quarter_instances[:spring]

comp_sci_150.quarters << quarter_instances[:fall]
comp_sci_150.quarters << quarter_instances[:winter]
comp_sci_150.quarters << quarter_instances[:spring]

comp_sci_211.quarters << quarter_instances[:fall]
comp_sci_211.quarters << quarter_instances[:winter]
comp_sci_211.quarters << quarter_instances[:spring]

comp_sci_212.quarters << quarter_instances[:fall]
comp_sci_212.quarters << quarter_instances[:winter]

comp_sci_213.quarters << quarter_instances[:fall]
comp_sci_213.quarters << quarter_instances[:winter]
comp_sci_213.quarters << quarter_instances[:spring]

# Set up labels
comp_sci_110.labels << label_instances[:introductory]
comp_sci_110.labels << label_instances[:for_non_cs_majors]

comp_sci_111.labels << label_instances[:core]
comp_sci_111.labels << label_instances[:required]
comp_sci_111.labels << label_instances[:introductory] 
comp_sci_111.labels << label_instances[:racket]

comp_sci_150.labels << label_instances[:introductory]
comp_sci_150.labels << label_instances[:python]
comp_sci_150.labels << label_instances[:object_oriented]

comp_sci_211.labels << label_instances[:core]
comp_sci_211.labels << label_instances[:required]
comp_sci_211.labels << label_instances[:programming]
comp_sci_211.labels << label_instances[:c]
comp_sci_211.labels << label_instances[:c_plus_plus]
comp_sci_211.labels << label_instances[:projects_heavy]
comp_sci_211.labels << label_instances[:time_consuming]
comp_sci_211.labels << label_instances[:great_course_staff]

comp_sci_212.labels << label_instances[:core]
comp_sci_212.labels << label_instances[:required]
comp_sci_212.labels << label_instances[:math_heavy]
comp_sci_212.labels << label_instances[:programming]

comp_sci_213.labels << label_instances[:core]
comp_sci_213.labels << label_instances[:required]
comp_sci_213.labels << label_instances[:systems]
comp_sci_213.labels << label_instances[:projects_heavy]


puts "Seed data created successfully!"