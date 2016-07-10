require 'honeypot/workable'

module Honeypot
  module Worker
    # Center Worker
    class Center
      include Workable

      def critera
        Log.where(type: 'center')
      end

      def notify(user, prev, now)
        user.push(
          type: :note,
          title: 'Center',
          body: now.to_json
        )
      end

      def check(prev, now)
        User.all.each do |user|
          notify(user, prev, now) if prev[:status] != now[:status]
        end
      end
    end
  end
end
