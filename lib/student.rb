require 'pry'

class Student
  attr_accessor :id, :name, :grade

  
  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.grade = row[2]
    new_student.name = row[1]
    new_student.id = row[0]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * from students
    SQL

    students_table = DB[:conn].execute(sql)
    students_table.map do |student|
      if self.find_by_name(student[1])
        self.find_by_name(student[1])
      else
        self.new_from_db(student)
      end
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    found_student = DB[:conn].execute(sql, name)[0]
    self.new_from_db(found_student)

  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT name FROM students WHERE grade = ?
    SQL

    grade_9_students = DB[:conn].execute(sql, 9)[0]
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT name FROM students WHERE grade < ?
    SQL

    below_grade_12_students = DB[:conn].execute(sql, 12)[0]
    below_grade_12_students.map do |student|
      self.find_by_name(student)
    end
  end

  def self.first_X_students_in_grade_10(number_x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ? LIMIT ?
    SQL
    first_X_students = DB[:conn].execute(sql, 10, number_x)
    first_X_students.map do |each_student|
      self.new_from_db(each_student)
    end
  end

  def self.first_student_in_grade_10
    first_student = self.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade_x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL
    grade_X_students = DB[:conn].execute(sql, grade_x)
    grade_X_students.map do |each_student|
      self.new_from_db(each_student)
    end 
  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
