require 'honeypot/workable'

module Honeypot
  module Worker
    # SWCert Worker
    class SWCert
      include Workable

      def critera
        Log.where(type: 'swcert')
      end

      def filter(status)
        status[:status].select do |item|
          item['CNT4'].to_i < item['PERSON_CNT'].to_i
        end
      end

      def certi_nm(item)
        "#{item['CERTI_NM'][0, 3]}#{'(F)' if item['FOREIGNER_YN'] == 'Y'}"
      end

      def date(item)
        [item['QUAL_DT'][0, 4],
         item['QUAL_DT'][4, 2],
         item['QUAL_DT'][6, 2]].join('-')
      end

      def time(attr_)
        [attr_[0, 2], attr_[2, 2]].join(':')
      end

      def to_inspect(item)
        "*#{item['PERSON_CNT'].to_i - item['CNT4'].to_i}*: " \
          "#{certi_nm(item)} " \
          "#{date(item)} " \
          "#{time(item['QUAL_ST_TIME'])} ~ #{time(item['QUAL_ED_TIME'])} " \
          "#{item['EDU_PLACE_NM']} " \
          "#{item['LANGUAGE_TYPE']}"
      end

      def sum(status)
        status.map do |item|
          item['PERSON_CNT'].to_i - item['CNT4'].to_i
        end.reduce(0, :+)
      end

      def notify(prev, now)
        prev_ = filter(prev)
        now_ = filter(now)
        MShard::MShard.new.set_safe(
          slack: true,
          webhook_url: ENV['SLACK_WEBHOOK_URI'],
          channel: '#swcert',
          attachments: [
            {
              fallback: "#{sum(prev_)} -> #{sum(now_)}",
              pretext: "*#{sum(prev_)}* -> *#{sum(now_)}* <!channel>",
              title: "Available exams",
              text: now_.map { |item| to_inspect(item) }.join("\n"),
              mrkdwn_in: %w(pretext text)
            }
          ],
        )
      end

      def check(prev, now)
        Logger.new($stderr).debug do
          "[#{prev[:status] == now[:status] ? 'Same' : 'Different'}]"
        end
        notify(prev, now) unless prev[:status] == now[:status]
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
