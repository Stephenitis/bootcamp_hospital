class Person
  attr_accessor :name
end

class Patient < Person
  attr_accessor :condition
end

class Employee < Person
  DEFAULT_SALARY = nil
  attr_writer :salary
  attr_accessor :username, :password
  def can_list_patients?
    false
  end
  def can_view_records?
    false
  end
  def can_add_records?
    false
  end
  def salary
    self.class::DEFAULT_SALARY || @salary
  end
end

class Doctor < Employee
  DEFAULT_SALARY = 250_000
  def can_list_patients?
    true
  end
  def can_view_records?
    true
  end
end

class Receptionist < Employee
  DEFAULT_SALARY = 80_000
  def can_list_patients?
    true
  end
  def can_add_records?
    true
  end
end

class Janitor < Employee
  DEFAULT_SALARY = 50_000
end

class Hospital
  attr_accessor :name

  def initialize
    @database = []
  end

  def patients
    @database.select{|obj| obj.is_a? Patient}
  end

  def employees
    @database.select{|obj| obj.is_a? Employee}
  end

  def add(patient_or_employee)
    @database << patient_or_employee
  end

  def login(username, password)
    @database.detect{|obj| obj.is_a? Employee && obj.username == username && obj.password == password}
  end
end

class HospitalAdmin
  @hospital = Hospital.new
  @hospital.name = 'Misty River Hospital'


  def self.run
    add_employees
    add_patients
    str = "Welcome to #{@hospital.name}"
    puts str
    puts '-'*str.size
    @user = do_login
    if @user
      puts "Welcome, #{@user.name}. Your access level is #{@user.class.name.upcase}"
      while true do
        puts "\n\n"
        show_menu
        get_command
      end
    else
      puts "Hacker begone!"
    end
  end

  def self.do_login
    puts 'Please enter your username:'
    username = gets
    username.chomp!
    puts 'Please enter your password:'
    password = gets
    password.chomp!
    return @hospital.login(username, password)
  end

  def self.show_menu
    if @user.can_list_patients?
      puts "Type 'list' to list patients"
    end
    if @user.can_view_records?
      puts "Type 'view <name>' to see condition"
    end
    if @user.can_add_records?
      puts "Type 'add <name> <condition>' to add record"
    end
  end

  def self.get_command
    command = gets.chomp
    case command
    when 'list'
      if @user.can_list_patients?
        @hospital.patients.each do |patient|
          puts patient.name
        end
      else
        show_access_denied
      end
    when /^view (.*)/
      if @user.can_view_records?
        patient = @hospital.patients.detect{|p|p.name == $1}
        if patient
          puts patient.condition
        else
          puts "I can't find that patient"
        end
      else
        show_access_denied
      end
    when /^add (.*) (.*)/
      if @user.can_add_records?
        add_person(Patient, $1, :condition => $2)
      else
        show_access_denied
      end
    when 'exit'
      exit 0
    else
      exit 1
    end
  end

  def self.show_access_denied
    puts "you can't do that"
  end

  def self.add_employees
    add_person(Doctor, 'Marcus', :username => 'doctor', :password => 'password')
    add_person(Janitor, 'John', :username => 'john', :password => 'password')
    add_person(Receptionist, 'Sally', :username => 'sally', :password => 'password')
  end

  def self.add_patients
    add_person(Patient, 'Alice', :condition => 'stable')
    add_person(Patient, 'Bob'  , :condition => 'stable')
    add_person(Patient, 'Carol', :condition => 'critical')
  end

  def self.add_person(klass, name, opts={})
    @person = klass.new
    @person.name = name
    if @person.kind_of? Employee
      @person.username = opts[:username]
      @person.password = opts[:password]
    else
      @person.condition = opts[:condition]
    end
    @hospital.add(@person)
  end
end

HospitalAdmin.run
