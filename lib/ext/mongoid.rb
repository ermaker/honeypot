module Mongoid
  class Criteria # rubocop:disable Style/Documentation
    def tailable_cursor
      query.tailable.skip(size).cursor
    end

    def tailable_diff
      tailable_cursor.each_cons(2) do |args|
        yield(*args.map { |arg| klass.new(arg) })
      end
    end
  end
end
