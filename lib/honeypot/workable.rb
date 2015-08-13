module Honeypot
  # The workerable module
  module Workable
    def run
      critera.tailable_diff do |prev, now|
        check(prev, now)
      end
    end
  end
end
