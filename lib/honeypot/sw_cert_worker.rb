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

    def select_by_user(hash, user)
      hash.select { |k, _| user.sw_cert_setting.include?(k) }
    end

    def notify(user, prev, now)
      prev = select_by_user(to_hash(prev), user)
      now = select_by_user(to_hash(now), user)
      now.reject { |k, v| v == prev[k] }.tap do |diff|
        user.push(
          type: :note,
          title: diff.values.sum,
          body: diff.map { |k, v| "#{k}: #{prev[k]} -> #{v}" }.join("\n")
        ) unless diff.empty?
      end
    end

    def check(prev, now)
      User.all.each do |user|
        notify(user, prev, now)
      end
    end
  end
end
