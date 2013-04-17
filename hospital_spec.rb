require 'rubygems'
require 'rspec'
require './hospital'


describe Patient do
  it 'has a name' do
    alice = Patient.new
    alice.name = 'Alice Kramden'
    alice.name.should == 'Alice Kramden'
  end

  it 'has a condition' do
    alice = Patient.new
    alice.condition = 'stable'
    alice.condition.should == 'stable'
  end
end

describe Employee do
  let(:bob){ Employee.new }
  it 'has a name' do
    bob.name = 'Bobby Digital'
    bob.name.should == 'Bobby Digital'
  end

  it 'has a salary' do
    bob.salary = 100
    bob.salary.should == 100
  end

  it 'has a username' do
    bob.username = 'bobbyd'
    bob.username.should == 'bobbyd'
  end

  it 'has a password' do
    bob.password = 'seekrit'
    bob.password.should == 'seekrit'
  end
end

describe Doctor do
  it "should have a salary of 250K" do
    Doctor.new.salary.should == 250_000
  end

  it 'can list patients' do
    Doctor.new.can_list_patients?.should be_true
  end
end

describe Janitor do
  it "should have a salary of 50K" do
    Janitor.new.salary.should == 50_000
  end
end

describe Receptionist do
  it "should have a salary of 80K" do
    Receptionist.new.salary.should == 80_000
  end
end

describe Hospital do
  let(:the_hospital){ Hospital.new }
  it 'has a name' do
    the_hospital.name = 'St. Elsewhere'
    the_hospital.name.should == 'St. Elsewhere'
  end

  it 'has patients' do
    the_hospital.patients.count.should == 0
  end

  it 'can add a patient' do
    patient = Patient.new
    the_hospital.add(patient)
    the_hospital.patients.count.should == 1
  end

  it 'has employees' do
    the_hospital.employees.count.should == 0
  end

  it 'can add a employee' do
    employee = Employee.new
    the_hospital.add(employee)
    the_hospital.employees.count.should == 1
  end

  it 'can add a Janitor' do
    employee = Janitor.new
    the_hospital.add(employee)
    the_hospital.employees.count.should == 1
  end

  describe 'logging in' do
    let(:employee){Employee.new}
    before(:each) do
      employee.username = 'abc'
      employee.password = 'xyz'
      employee.name = 'Fred'
      the_hospital.add(employee)
    end

    it 'can log in an employee' do
      the_hospital.login('abc','xyz').should == employee
    end

    it 'will not login with a bad username/password' do
      the_hospital.login('foo','xyz').should be_false
      the_hospital.login('abc','foo').should be_false
    end

  end

end
