require 'honeypot/workable'

module Honeypot
  module Worker
    # Center Worker
    class Center
      include Workable

      def critera
        Log.where(type: 'center')
      end

      def notify(prev, now)
        MShard::MShard.new.set_safe(
          slack: true,
          webhook_url: ENV['SLACK_WEBHOOK_URI'],
          # channel: '#center',
          text: '<!channel> Center Changed: [click for detail](%{uri})',
          contents: now.to_json
        )
      end

      def check(prev, now)
        notify(prev, now) if prev[:status] != now[:status]
      end
    end
  end
end
