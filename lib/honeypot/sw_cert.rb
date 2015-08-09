require 'models/log'

module Honeypot
  # The worker class for SW Cert
  class SWCert
    def critera
      Log.where(type: 'sw_cert')
    end

    def notify_if_modified(prev, now)
      return false if prev.status == now.status
      true
    end
  end
end
