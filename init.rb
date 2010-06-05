require 'conditions_helpers'

ActiveRecord::Base.class_eval do
  include ConditionsHelpers
  extend ConditionsHelpers
end
