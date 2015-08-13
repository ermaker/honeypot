module Honeypot
  # The workerable module
  module Workerable
    def run
      critera.tailable_diff do |prev, now|
        check(prev, now)
      end
    end
  end
end
