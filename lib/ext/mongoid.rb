module Mongoid
  class Criteria # rubocop:disable Style/Documentation
    def tailable_cursor
      skip_value = size - 1
      skip_value = 0 if skip_value < 0
      cursor_type(:tailable_await).skip(skip_value).to_enum
    end

    def tailable_diff(&blk)
      tailable_cursor.each_cons(2, &blk)
    end
  end
end
