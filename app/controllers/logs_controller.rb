# The Log controller
class LogsController < ApplicationController
  respond_to :json
  skip_before_action :verify_authenticity_token

  def create
    @log = Log.new(log_params)
    @log.save
    respond_with(@log, location: -> { logs_path }, status: :created)
  end

  private

  def log_params
    params.permit!
  end
end
