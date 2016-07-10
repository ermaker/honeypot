namespace :jobs do
  namespace :worker do
    desc 'Do jobs of SW Cert Worker'
    task sw_cert: [:environment] do
      require 'honeypot/sw_cert_worker'
      Mongo::Logger.logger.level = Logger::INFO
      Honeypot::SWCertWorker.new.run
    end

    desc 'Do jobs of Get Student Worker'
    task get_student: [:environment] do
      require 'honeypot/get_student_worker'
      Mongo::Logger.logger.level = Logger::INFO
      Honeypot::GetStudentWorker.new.run
    end

    desc 'Do jobs of Center Worker'
    task center: [:environment] do
      require 'honeypot/worker/center'
      Mongo::Logger.logger.level = Logger::INFO
      Honeypot::Worker::Center.new.run
    end
  end
end
