module Honeypot
  # The worker class for SW Cert
  class SWCertWorker
    include Workerable

    def critera
      Log.where(type: 'sw_cert')
    end

    def to_hash(log)
      Hash[log[:status].map { |l| [l[0...-1], l[-1][/\d+$/].to_i] }]
    end

    def notify(diff)
      User.all.each do |user|
        user.push(
          type: :note,
          title: diff.values.sum,
          body: diff.map { |k, v| "#{k}: #{v}" }.join("\n")
        )
      end
    end

    def check(prev, now)
      prev = to_hash(prev)
      now = to_hash(now)
      now.reject { |k, v| v == prev[k] }.tap do |diff|
        notify(diff)
      end
    end
  end
end
