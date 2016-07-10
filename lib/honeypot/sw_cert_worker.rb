require 'honeypot/workable'

module Honeypot
  # The worker class for SW Cert
  class SWCertWorker
    include Workable

    def critera
      Log.where(type: 'sw_cert')
    end

    def to_hash(log)
      Hash[log[:status].map { |l| [l[0...-1], l[-1][/\d+$/].to_i] }]
    end

    def body(now, prev)
      now.map { |k, v| "#{k}: #{prev[k]} -> #{v}" }.join("\n")
    end

    def notify(user, prev, now)
      prev = to_hash(prev)
      now = to_hash(now)
      user.push(
        type: :note,
        title: now.values.sum,
        body: body(now, prev)
      ) if now.any? { |k, v| v != prev[k] }
    end

    def check(prev, now)
      User.all.each do |user|
        notify(user, prev, now)
      end
    end
  end
end
