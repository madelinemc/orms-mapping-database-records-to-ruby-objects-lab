class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row) # takes a row from the database and creates a new Student object
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all # retrieves all rows from the students database
    sql = <<-SQL 
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do |row| #use .new_from_db method to create a student instance for each row that comes back from the database
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name) # accepts a name of a student, runs SQL query to get the result from the database where name = the passed in name, the argument
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row| # uses the .new_from_db method to take the result and create a new student instance.
      self.new_from_db(row)
    end.first
  
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

  def self.all_students_in_grade_9 #class method. no argument. return an array of all students in grade 9. 
    sql = <<-SQL
    SELECT COUNT(*)
    FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade #class method. no argument. return an array of all the students below 12th grade. 
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number) #class method. takes in an argument of number of students to select. returns array of exactly that number of students. 
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10 
    ORDER BY students.id 
    LIMIT ?
    SQL

    DB[:conn].execute(sql,number).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10 #class method. does not need arugment. return the first student that is in grade 10. 
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10
    ORDER BY students.id
    LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first #.first will return the first element in the array
  end

  def self.all_students_in_grade_X(grade) #class method. takes in argument of a grade and retreives the roster returning an array of all students for grade X
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql,grade).map do |row|
      self.new_from_db(row)
    end
  end

end
