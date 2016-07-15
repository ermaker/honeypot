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

      def to_inspect(item)
        "#{item['CERTI_NM']}#{'(Foreigner)' if item['FOREIGNER_YN'] == 'Y'} " \
          ": #{item['PERSON_CNT'].to_i - item['CNT4'].to_i} " \
          "[#{item['QUAL_DT']} #{item['EDU_PLACE_NM']} " \
          "#{item['QUAL_ST_TIME']} ~ #{item['QUAL_ED_TIME']} " \
          "#{item['LANGUAGE_TYPE']}]"
      end

      def notify(prev, now)
        MShard::MShard.new.set_safe(
          slack: true,
          webhook_url: ENV['SLACK_WEBHOOK_URI'],
          # channel: '#center',
          attachments: [
            {
              fallback: "SWCERT TEST",
              pretext: "SWCERT TEST <!channel>",
              title: "TITLE",
              text: filter(now).map { |item| to_inspect(item) }.join("\n"),
              footer: "FOOTER"
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
