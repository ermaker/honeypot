require 'honeypot/workable'

module Honeypot
  module Worker
    # Center Worker
    class Center
      include Workable

      def initialize
        @notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URI'] # , channel: '#center'
      end

      def critera
        Log.where(type: 'center')
      end

      def notify(prev, now)
        @notifier.ping "<!channel> #{now.to_json}"
      end

      def check(prev, now)
        notify(prev, now) if prev[:status] != now[:status]
      end
    end
  end
end
