require 'mshard'
require 'models/log'

module Honeypot
  # The worker class for SW Cert
  class SWCert
    def critera
      Log.where(type: 'sw_cert')
    end

    def to_hash(log)
      Hash[log[:status].map { |l| [l[0...-1], l[-1][/\d+$/].to_i] }]
    end

    CHANNEL_TAG_POSTFIX = {
      '인재개발원(서천)' => 's',
      '첨단기술연수소(영통)' => 'y',
      '스마트시티(구미)' => 'g',
      '첨단기술연수소(영통) (외국인 전용)' => 'f'
    }

    def notify(k, v)
      channel_tag = "#{ENV['CHANNEL_TAG']}#{CHANNEL_TAG_POSTFIX[k[3]]}"
      title = k.join(' ')
      body = v
      MShard::MShard.new.set_safe(
        pushbullet: true,
        channel_tag: channel_tag,
        type: 'note',
        title: title,
        body: body
      )
    end

    def notify_if_modified(prev, now)
      now = to_hash(now)
      prev = to_hash(prev)
      now.reject { |k, v| v == prev[k] }.tap do |diff|
        diff.each do |k, v|
          notify(k, v)
        end
      end
    end
  end
end
