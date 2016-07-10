module Mongoid
  class Criteria # rubocop:disable Style/Documentation
    def tailable_cursor
      skip_value = size - 1
      skip_value = 0 if skip_value < 0
      cursor_type(:tailable).skip(skip_value)
    end

    def tailable_diff(&blk)
      tailable_cursor.each_cons(2, &blk)
    end
  end
end
