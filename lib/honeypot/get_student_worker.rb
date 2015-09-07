require 'honeypot/workable'

module Honeypot
  # The worker class for GetStudent
  class GetStudentWorker
    include Workable

    def critera
      Log.where(type: 'get_student')
    end

    def body(info)
      info.map { |k, v| "#{k}: #{v}" }.join("\n")
    end

    def notify(user, info)
      user.push(
        type: :note,
        title: info['학 년'],
        body: body(info)
      )
    end

    def check(_prev, info)
      User.all.each do |user|
        notify(user, info[:status])
      end
    end
  end
end
