require 'test_helper'

class Person < Less::Value
  attribute :first_name, String
  attribute :last_name, String
  attribute :single, Less::Bool
  attribute :age, Integer
end

class AgelessPerson < Less::Value
  attribute :first_name, String
  attribute :last_name, String
  attribute :single, Less::Bool
  attribute :age, Integer, allow_nil: true
end

class ProbablySinglePerson < Less::Value
  attribute :first_name, String
  attribute :last_name, String
  attribute :single, Less::Bool, default: false
  attribute :age, Integer
end

class Less::Values::Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Less::Values::VERSION
  end

  def test_we_can_instantiate
    p = Person.new(first_name: 'Eugen', last_name: 'Minciu', single: false, age: 31)
    assert_equal 'Eugen', p.first_name
    assert_equal 'Minciu', p.last_name
    assert_equal false, p.single
    assert_equal 31, p.age
  end

  def test_question_attr_reader
    p = Person.new(first_name: 'Eugen', last_name: 'Minciu', single: false, age: 31)
    assert_equal false, p.single?
  end

  def test_with
    p = Person.new(first_name: 'Eugen', last_name: 'Minciu', single: false, age: 31)
    p2 = p.with(age: 32)
    assert_equal 32, p2.age
    assert_equal 31, p.age
  end

  def test_missing_attributes
    assert_raises Less::Values::MissingAttributeError do
      Person.new(first_name: 'Eugen', last_name: 'Minciu', single: false)
    end
  end

  def test_wrong_types
    assert_raises Less::Values::WrongTypeError do
      Person.new(first_name: 100, last_name: 'Minciu', single: false, age: 31)
    end
  end

  def test_allowing_nil
    AgelessPerson.new(first_name: 'Eugen', last_name: 'Minciu', single: false)
    pass
  end

  def test_with_default
    p = ProbablySinglePerson.new(first_name: 'Eugen', last_name: 'Minciu', age: 31)
    assert_equal false, p.single
  end

  def test_parsing
    p = Person.parse(first_name: 'Eugen', last_name: 'Minciu', single: '0', age: '31')
    assert_equal 'Eugen', p.first_name
    assert_equal 'Minciu', p.last_name
    assert_equal false, p.single
    assert_equal 31, p.age
  end
end
