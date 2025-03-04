class Student
  attr_accessor :id, :name, :grade

  # def initialize(id, name, grade)
  #   @id=id
  #   @name=name
  #   @grade=grade
  # end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_song=self.new
    new_song.id=row[0]
    new_song.name=row[1]
    new_song.grade=row[2]
    new_song
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students").collect do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE name=?",name).collect do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_9
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE grade=?",9).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE grade<?",12).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number_of_students)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE grade=? LIMIT ?",10,number_of_students).collect do |row|
      self.new_from_db(row)
    end
  end
  def self.first_student_in_grade_10
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE grade=? LIMIT ?",10,1).collect do |row|
      self.new_from_db(row)
    end.first
  end
  def self.all_students_in_grade_X(grade)
    # find the student in the database given a name
    # return a new instance of the Student class
    DB[:conn].execute("SELECT * FROM students WHERE grade=?",grade).collect do |row|
      self.new_from_db(row)
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
