class ActivityReportController < ApplicationController
  def show
    reporter = DailyReport.new(params[:company_id].to_i, params[:driver_id].to_i)
    render json: reporter.report
  end
end
