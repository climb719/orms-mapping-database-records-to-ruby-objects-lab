class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_student = self.new  # creates an instance/new student object with corresponding attribute values from the row
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all # retrieve all the rows from the Students database
    sql = <<-SQL
    SELECT *         
    FROM students 
    SQL

    DB[:conn].execute(sql).map do |row|  #create a student instance for each row that comes back from the database
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name) # find the student in the database given a name
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first # return a new instance of the Student class, grabbing first element of array returned by map
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

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade < 12
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(num)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE grade = 10 
    ORDER BY students.id 
    LIMIT ?
    SQL
    
    DB[:conn].execute(sql, num).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade = 10
    ORDER BY students.id
    LIMIT 1
    SQL
    
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * 
    FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql, grade).map do |row|
      self.new_from_db(row)
    end
  end

end
