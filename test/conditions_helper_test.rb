require 'test/unit'

require 'rubygems'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

class ConditionsHelperTest < Test::Unit::TestCase

  include ConditionsHelpers

  def test_should_return_nil_for_empty_conditions
    conditions = create_conditions([])
    assert_nil conditions
  end

  def test_should_return_nil_for_empty_conditions_array
    conditions = create_conditions([[""],[""]])
    assert_nil conditions
  end

  def test_should_return_nil_for_empty_conditions_array_with_separators
    conditions = create_conditions([[""],[nil, :or, ""]])
    assert_nil conditions
  end

  def test_should_build_conditions_without_seperators
    conditions = create_conditions(["condition1"], ["condition2"])
    assert_equal ["(condition1) AND (condition2)"], conditions
  end

  def test_should_build_simple_conditions_without_array
    conditions = create_conditions("condition1", "condition2", :or, "condition3")
    assert_equal ["(condition1) AND (condition2) OR (condition3)"], conditions
  end

  def test_should_build_conditions_with_separators
    conditions = create_conditions(["condition1"], :and, ["condition2"], :or, ["condition3"])
    assert_equal ["(condition1) AND (condition2) OR (condition3)"], conditions
  end

  def test_should_set_paranthess_the_same_as_square_brackets
    conditions = create_conditions(["condition1"], [["condition2"], :or, ["condition3"]])
    assert_equal ["(condition1) AND ((condition2) OR (condition3))"], conditions
  end
  
  def test_should_add_params_after_conditions
    conditions = create_conditions(["condition1"], [["condition2 = ?", 2], :or, ["condition3 = ?", 3]])
    assert_equal ["(condition1) AND ((condition2 = ?) OR (condition3 = ?))", 2, 3], conditions
  end

  def test_should_build_conditions_with_nil_before_separator
    conditions = create_conditions(["condition1"], [nil, :or, ["condition3 = ?", 3]])
    assert_equal ["(condition1) AND ((condition3 = ?))", 3], conditions
  end

  def test_should_build_conditions_with_nils_after_separator
    conditions = create_conditions(["condition1"], [["condition2 = ?", 2], :or, nil, :and, ""])
    assert_equal ["(condition1) AND ((condition2 = ?))", 2], conditions
  end


end
