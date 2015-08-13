module Mongoid
  class Criteria # rubocop:disable Style/Documentation
    def tailable_cursor
      skip_value = size - 1
      skip_value = 0 if skip_value < 0
      query.tailable.skip(skip_value).cursor
    end

    def tailable_diff
      tailable_cursor.each_cons(2) do |args|
        yield(*args.map { |arg| klass.new(arg) })
      end
    end
  end
end
