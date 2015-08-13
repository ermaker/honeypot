namespace :jobs do
  namespace :worker do
    desc 'Do jobs of SW Cert Worker'
    task sw_cert: [:environment] do
      require 'honeypot/sw_cert_worker'
      Honeypot::SWCertWorker.new.run
    end
  end
end
