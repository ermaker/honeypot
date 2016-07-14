require 'honeypot/workable'

module Honeypot
  module Worker
    # Center Worker
    class Center
      include Workable

      def critera
        Log.where(type: 'center')
      end

      MAX = 4

      def status(center)
        (center[:status] || []).group_by {|v| v.values_at('RSV_DT', 'RSV_TM')}
      end

      def to(status_)
        to_ = Hash[status_.map { |k, v| [k, MAX - v.size] }]

        date_list = to_.keys.map(&:first)
        time_list = to_.keys.map(&:last)
        date_list.each do |date|
          time_list.each do |time|
            to_[[date, time]] = MAX unless to_.key? [date, time]
          end
        end
        to_.reject { |_, v| v.zero? }
      end

      def to_inspect(to_)
        to_.sort.map do |k, v|
          time = Time.parse(k.join).strftime('%m-%d(%a) %H:%M')
          "#{time}: #{v}"
        end
      end

      def to_sum(to_)
        to_.values.reduce(0, :+)
      end

      def lastdate_string(status_)
        return 'Data' if status_.empty?
        Date.parse(status_.keys.max[0]).strftime('%m-%d(%a)')
      end

      def notify(prev, now)
        prev_status = status(prev)
        prev_to = to(prev_status)
        prev_sum = to_sum(prev_to)
        now_status = status(now)
        now_to = to(status(now))
        now_sum = to_sum(now_to)
        lastdate = lastdate_string(now_status)
        MShard::MShard.new.set_safe(
          slack: true,
          webhook_url: ENV['SLACK_WEBHOOK_URI'],
          # channel: '#center',
          attachments: [
            {
              fallback: "#{prev_sum} -> #{now_sum}",
              pretext: "#{prev_sum} -> #{now_sum} <!channel>",
              title: "Available: #{now_sum}",
              text: to_inspect(now_to).join("\n"),
              footer: "#{lastdate} may not available yet."
            }
          ],
        )
      end

      def check(prev, now)
        Logger.new($stderr).debug do
          prev_status = status(prev)
          prev_to = to(prev_status)
          prev_sum = to_sum(prev_to)
          now_status = status(now)
          now_to = to(status(now))
          now_sum = to_sum(now_to)
          "#{prev_sum} -> #{now_sum}"
        end
        notify(prev, now) if prev[:status] != now[:status]
      end

      def peek_
        critera.order(id: :desc).limit(2).to_a.reverse
      end

      def peek
        notify(*peek_)
      end
    end
  end
end
