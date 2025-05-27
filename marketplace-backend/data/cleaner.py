#!/usr/bin/env python3
"""
CS Course Data Extractor for Rails Models

This script extracts Computer Science course data from Northwestern's course JSON files
and formats it for loading into PostgreSQL Rails database.

Data Sources:
- plan.json: Contains all course information without instructors
- Quarter-specific JSONs (e.g., 2025Winter.json): Contains instructor information

Output:
- courses.csv: Course data for the courses table
- instructors.csv: Instructor data for the instructors table  
- quarters.csv: Quarter data for the quarters table
- course_instructor_mappings.csv: Many-to-many relationships between courses and instructors
- course_quarter_mappings.csv: Many-to-many relationships between courses and quarters
"""

import json
import csv
import os
import re
from pathlib import Path
from typing import Dict, List, Set, Tuple, Optional
from collections import defaultdict

class CSCourseExtractor:
    def __init__(self, data_dir: str = "Paper Data"):
        self.data_dir = Path(data_dir)
        self.courses = {}
        self.instructors = set()
        self.quarters = set()
        self.course_instructor_mappings = []
        self.course_quarter_mappings = []
        
        # Quarter code to name mapping (based on the pattern observed)
        self.quarter_codes = {
            "4960": "2024 Fall",
            "4970": "2024 Winter", 
            "4980": "2024 Spring",
            "4990": "2024 Summer",
            "5000": "2025 Winter",
            "5010": "2025 Spring",
            "5020": "2025 Summer"
        }
    
    def load_plan_data(self) -> List[Dict]:
        """Load the main plan.json file containing all course data."""
        plan_file = self.data_dir / "plan.json"
        print(f"Loading plan data from {plan_file}")
        
        with open(plan_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Remove the leading comma if present
        content = content.lstrip(',')
        
        try:
            data = json.loads(content)
            
            # Check if it's a dict with "courses" key
            if isinstance(data, dict) and "courses" in data:
                courses = data["courses"]
                print(f"Successfully loaded plan data with {len(courses)} courses")
                return courses
            # Check if it's already an array
            elif isinstance(data, list):
                print(f"Successfully loaded plan data with {len(data)} courses")
                return data
            else:
                print(f"Unexpected data structure in plan.json: {type(data)}")
                return []
                
        except json.JSONDecodeError as e:
            print(f"Error parsing plan.json: {e}")
            # Try to extract just the array part
            start = content.find('[')
            end = content.rfind(']') + 1
            if start != -1 and end != 0:
                try:
                    data = json.loads(content[start:end])
                    print(f"Successfully loaded plan data with {len(data)} courses (extracted array)")
                    return data
                except json.JSONDecodeError as e2:
                    print(f"Error parsing extracted array: {e2}")
                    return []
            return []
    
    def load_quarter_data(self, quarter_file: str) -> Dict:
        """Load quarter-specific JSON file containing instructor data."""
        file_path = self.data_dir / quarter_file
        print(f"Loading quarter data from {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            # Remove leading comma if present
            content = content.lstrip(',')
            
            data = json.loads(content)
            
            # Handle different possible structures
            courses_data = []
            if isinstance(data, dict):
                # Check for common keys that might contain course arrays
                if "courses" in data:
                    courses_data = data["courses"]
                elif "data" in data:
                    courses_data = data["data"]
                else:
                    # If it's a dict but no obvious array, treat each value as a course
                    courses_data = list(data.values()) if all(isinstance(v, dict) for v in data.values()) else []
            elif isinstance(data, list):
                courses_data = data
            else:
                print(f"Unexpected data structure in {quarter_file}: {type(data)}")
                return {}
                    
            print(f"Successfully loaded {len(courses_data)} courses from {quarter_file}")
            
            # Convert to dict keyed by course ID
            result = {}
            for item in courses_data:
                if isinstance(item, dict) and 'i' in item:
                    result[item['i']] = item
                    
            return result
            
        except (json.JSONDecodeError, FileNotFoundError) as e:
            print(f"Error loading {quarter_file}: {e}")
            return {}
    
    def is_cs_course(self, course_id: str, department: str = None) -> bool:
        """Check if a course is a Computer Science course."""
        # For plan.json format where course ID includes department
        if course_id.startswith('COMP_SCI '):
            return True
        # For quarter files where department is separate
        if department == 'COMP_SCI':
            return True
        return False
    
    def clean_course_name(self, name: str) -> str:
        """Clean and normalize course names."""
        if not name:
            return ""
        # Remove extra whitespace and normalize
        return ' '.join(name.split())
    
    def clean_instructor_name(self, name: str) -> str:
        """Clean and normalize instructor names."""
        if not name:
            return ""
        # Remove extra whitespace and normalize
        name = ' '.join(name.split())
        # Remove common titles/suffixes that might cause duplicates
        name = re.sub(r'\s+(Jr\.?|Sr\.?|III|II|IV)$', '', name, flags=re.IGNORECASE)
        return name.strip()
    
    def extract_course_number_and_name(self, course_id: str, course_name: str) -> Tuple[str, str]:
        """Extract course number and clean name from course data."""
        # Extract course number (e.g., "COMP_SCI 308-0" -> "308-0")
        course_number = course_id.replace('COMP_SCI ', '') if course_id.startswith('COMP_SCI ') else course_id
        
        # Clean course name
        clean_name = self.clean_course_name(course_name)
        
        return course_number, clean_name
    
    def process_plan_data(self, plan_data: List[Dict]):
        """Process the main plan data to extract CS courses."""
        print("Processing plan data for CS courses...")
        
        cs_course_count = 0
        
        for course in plan_data:
            if not isinstance(course, dict):
                continue
                
            course_id = course.get('i', '')
            if not self.is_cs_course(course_id):
                continue
                
            cs_course_count += 1
            course_name = course.get('n', '')
            course_number, clean_name = self.extract_course_number_and_name(course_id, course_name)
            
            # Extract description if available
            description = course.get('d', '') or ''
            
            # Extract terms offered
            terms_offered = course.get('t', [])
            if isinstance(terms_offered, list):
                for term_code in terms_offered:
                    if term_code in self.quarter_codes:
                        quarter_name = self.quarter_codes[term_code]
                        self.quarters.add(quarter_name)
                        self.course_quarter_mappings.append((course_number, quarter_name))
            
            # Store course data
            self.courses[course_number] = {
                'course_number': course_number,
                'name': clean_name,
                'description': description
            }
        
        print(f"Found {cs_course_count} CS courses in plan data")
    
    def process_quarter_files(self):
        """Process all quarter-specific files to extract instructor data and special topics courses."""
        quarter_files = [
            "2025Winter.json", "2025Spring.json", "2024Fall.json", 
            "2024Winter.json", "2024Spring.json", "2024Summer.json",
            "2025Summer.json", "2023Fall.json"
        ]
        
        special_topics_courses = {}  # Track special topics courses
        
        for quarter_file in quarter_files:
            if not (self.data_dir / quarter_file).exists():
                print(f"Quarter file {quarter_file} not found, skipping...")
                continue
                
            quarter_data = self.load_quarter_data(quarter_file)
            if not quarter_data:
                continue
                
            # Extract quarter name from filename
            quarter_name = quarter_file.replace('.json', '')
            # Convert to readable format (e.g., "2025Winter" -> "2025 Winter")
            quarter_name = re.sub(r'(\d{4})([A-Z][a-z]+)', r'\1 \2', quarter_name)
            self.quarters.add(quarter_name)
            
            print(f"Processing {quarter_file} for instructor data and special topics...")
            
            cs_courses_in_quarter = 0
            special_topics_found = 0
            
            for course_id, course_data in quarter_data.items():
                department = course_data.get('u', '')
                if not self.is_cs_course(course_id, department):
                    continue
                    
                cs_courses_in_quarter += 1
                
                # For quarter files, the course number is in the 'n' field
                course_number = course_data.get('n', '')
                if not course_number:
                    continue
                
                # Check if this is a special topics course (396, 397, 496, 497)
                base_course_num = course_number.split('-')[0]
                is_special_topics = base_course_num in ['396', '397', '496', '497']
                
                # Add quarter mapping for regular courses
                if not is_special_topics:
                    self.course_quarter_mappings.append((course_number, quarter_name))
                
                # Extract instructor data from sections
                sections = course_data.get('s', [])
                if isinstance(sections, list):
                    for section in sections:
                        if not isinstance(section, dict):
                            continue
                        
                        section_number = section.get('s', '')
                        section_topic = section.get('k', '')  # This is the specific topic
                        
                        # Handle special topics courses
                        if is_special_topics and section_topic and section_number:
                            special_course_number = f"{course_number}-{section_number}"
                            
                            # Create or update special topics course
                            if special_course_number not in special_topics_courses:
                                special_topics_courses[special_course_number] = {
                                    'course_number': special_course_number,
                                    'name': section_topic,
                                    'description': f"Special topics course: {section_topic}",
                                    'base_course': course_number
                                }
                                special_topics_found += 1
                            
                            # Add quarter mapping for special topics course
                            self.course_quarter_mappings.append((special_course_number, quarter_name))
                            
                            # Process instructors for special topics course
                            instructors = section.get('r', [])
                            if isinstance(instructors, list):
                                for instructor in instructors:
                                    if isinstance(instructor, dict):
                                        instructor_name = instructor.get('n', '')
                                        if instructor_name:
                                            clean_name = self.clean_instructor_name(instructor_name)
                                            if clean_name:
                                                self.instructors.add(clean_name)
                                                self.course_instructor_mappings.append((special_course_number, clean_name))
                        else:
                            # Regular course instructor processing
                            instructors = section.get('r', [])
                            if isinstance(instructors, list):
                                for instructor in instructors:
                                    if isinstance(instructor, dict):
                                        instructor_name = instructor.get('n', '')
                                        if instructor_name:
                                            clean_name = self.clean_instructor_name(instructor_name)
                                            if clean_name:
                                                self.instructors.add(clean_name)
                                                self.course_instructor_mappings.append((course_number, clean_name))
            
            print(f"Found {cs_courses_in_quarter} CS courses and {special_topics_found} special topics sections in {quarter_file}")
        
        # Add special topics courses to the main courses dictionary
        for special_course_number, special_course_data in special_topics_courses.items():
            self.courses[special_course_number] = {
                'course_number': special_course_number,
                'name': special_course_data['name'],
                'description': special_course_data['description']
            }
        
        print(f"Total special topics courses added: {len(special_topics_courses)}")
        if special_topics_courses:
            print("Sample special topics courses:")
            for i, (course_num, course_data) in enumerate(list(special_topics_courses.items())[:5]):
                print(f"  {course_num}: {course_data['name']}")
            if len(special_topics_courses) > 5:
                print(f"  ... and {len(special_topics_courses) - 5} more")
    
    def write_csv_files(self):
        """Write all extracted data to CSV files."""
        print("Writing CSV files...")
        
        # Write courses.csv
        with open('courses.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['course_number', 'name', 'description'])
            for course in self.courses.values():
                writer.writerow([
                    course['course_number'],
                    course['name'],
                    course['description']
                ])
        print(f"Written {len(self.courses)} courses to courses.csv")
        
        # Write instructors.csv
        with open('instructors.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['name', 'email'])
            for instructor in sorted(self.instructors):
                writer.writerow([instructor, ''])  # Email not available in source data
        print(f"Written {len(self.instructors)} instructors to instructors.csv")
        
        # Write quarters.csv
        with open('quarters.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['name'])
            for quarter in sorted(self.quarters):
                writer.writerow([quarter])
        print(f"Written {len(self.quarters)} quarters to quarters.csv")
        
        # Write course_instructor_mappings.csv
        with open('course_instructor_mappings.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['course_number', 'instructor_name'])
            # Remove duplicates while preserving order
            seen = set()
            unique_mappings = []
            for mapping in self.course_instructor_mappings:
                if mapping not in seen:
                    seen.add(mapping)
                    unique_mappings.append(mapping)
            
            for course_number, instructor_name in unique_mappings:
                writer.writerow([course_number, instructor_name])
        print(f"Written {len(unique_mappings)} course-instructor mappings to course_instructor_mappings.csv")
        
        # Write course_quarter_mappings.csv
        with open('course_quarter_mappings.csv', 'w', newline='', encoding='utf-8') as f:
            writer = csv.writer(f)
            writer.writerow(['course_number', 'quarter_name'])
            # Remove duplicates while preserving order
            seen = set()
            unique_mappings = []
            for mapping in self.course_quarter_mappings:
                if mapping not in seen:
                    seen.add(mapping)
                    unique_mappings.append(mapping)
            
            for course_number, quarter_name in unique_mappings:
                writer.writerow([course_number, quarter_name])
        print(f"Written {len(unique_mappings)} course-quarter mappings to course_quarter_mappings.csv")
    
    def generate_summary_report(self):
        """Generate a summary report of the extracted data."""
        print("\n" + "="*60)
        print("CS COURSE DATA EXTRACTION SUMMARY")
        print("="*60)
        print(f"Total CS Courses: {len(self.courses)}")
        print(f"Total Instructors: {len(self.instructors)}")
        print(f"Total Quarters: {len(self.quarters)}")
        print(f"Course-Instructor Mappings: {len(set(self.course_instructor_mappings))}")
        print(f"Course-Quarter Mappings: {len(set(self.course_quarter_mappings))}")
        
        print("\nSample Courses:")
        for i, (course_num, course_data) in enumerate(list(self.courses.items())[:5]):
            print(f"  {course_num}: {course_data['name']}")
        
        print("\nSample Instructors:")
        for i, instructor in enumerate(sorted(list(self.instructors))[:5]):
            print(f"  {instructor}")
        
        print("\nQuarters Found:")
        for quarter in sorted(self.quarters):
            print(f"  {quarter}")
        
        print("\nFiles Generated:")
        print("  - courses.csv")
        print("  - instructors.csv") 
        print("  - quarters.csv")
        print("  - course_instructor_mappings.csv")
        print("  - course_quarter_mappings.csv")
        print("="*60)
    
    def run(self):
        """Main execution method."""
        print("Starting CS Course Data Extraction...")
        print("="*60)
        
        # Load and process plan data
        plan_data = self.load_plan_data()
        if not plan_data:
            print("Error: Could not load plan data. Exiting.")
            return
            
        self.process_plan_data(plan_data)
        
        # Process quarter files for instructor data
        self.process_quarter_files()
        
        # Write CSV files
        self.write_csv_files()
        
        # Generate summary report
        self.generate_summary_report()
        
        print("\nExtraction completed successfully!")

def main():
    """Main entry point."""
    extractor = CSCourseExtractor()
    extractor.run()

if __name__ == "__main__":
    main()
