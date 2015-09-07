namespace :jobs do
  namespace :worker do
    desc 'Do jobs of SW Cert Worker'
    task sw_cert: [:environment] do
      Moped.logger.level = Logger::INFO
      require 'honeypot/sw_cert_worker'
      Honeypot::SWCertWorker.new.run
    end

    desc 'Do jobs of Get Student Worker'
    task get_student: [:environment] do
      Moped.logger.level = Logger::INFO
      require 'honeypot/get_student_worker'
      Honeypot::GetStudentWorker.new.run
    end
  end
end
