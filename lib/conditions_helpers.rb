module ConditionsHelpers

    #create_conditions([cond1, :or, cond2], cond3, cond4)
    #
    #create_conditions([
    #    [ "category = ?", category ],
    #    :and,
    #    [ ["user_id IS NULL"], :or, ["user_id = ?", user_id]],
    #    :and,
    #    [ ["project_id IS NULL"], :or, [project_id = ?", project_id]]
    #  ])
    #
    #
    # note 1: delimiters can be represented as symbols. :and is a default separator
    #         and can be omitted.
    #
    #         [ ["user_id IS NULL"], ["project_id IS NULL"] ]
    #         is a shorthand for
    #         [ ["user_id IS NULL"], :and, ["project_id IS NULL"] ]
    #
    # note 2: parentheses in SQL statement will be placed in the same order as square brackets in array

    def create_conditions(*conditions)
      (res = build_conditions([""], conditions)) == [""] ? nil : res
    end

  protected
    def build_conditions(res, params) #:nodoc:
      junction = nil
      params.inject(res) do |res, item|
        if item.instance_of?(Array)
          if item[0].instance_of?(String)
            add_condition_to_result(res, item[0], junction)
            item[1..-1].each {|r| res << r }
          else
            child_res = build_conditions([""], item)
            add_condition_to_result(res, child_res[0], junction)
            child_res[1..-1].each {|r| res << r}
          end
          junction = nil
        elsif item.instance_of?(String)
          add_condition_to_result(res, item, junction)
          junction = nil
        elsif item.instance_of?(Symbol)
          junction = " #{item.to_s} "
        end
        res
      end
    end

    def add_condition_to_result(res, condition, junction, enclose = true) #:nodoc:
      res[0] = add_junction_if_neccesary(res[0], junction) unless condition.empty?
      res[0] +=  (enclose ? "(#{condition})" : "#{condition}") unless condition.empty?
    end

    def add_junction_if_neccesary(condition_str, junction_str) #:nodoc:
      junction_to_add = junction_str.nil? ? " AND " : junction_str.upcase unless condition_str.empty?
      junction_to_add.nil? ? condition_str : (condition_str + junction_to_add)
    end

end