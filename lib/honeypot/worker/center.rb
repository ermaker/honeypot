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
          text: "Changed: [click for detail](%{uri})\n<!channel>",
          contents: now.to_json
        )
      end

      def check(prev, now)
        Logger.new($stderr).debug do
          now
            .as_json
            .to_options
            .reject { |k, _| [:_id, :status].include?(k) }
            .merge(status_count: now[:status]&.size)
        end
        notify(prev, now) if prev[:status] != now[:status]
      end
    end
  end
end
