class DailyReport

  include ActionView::Helpers::DateHelper

  attr_reader :company_id, :driver_id

  def initialize(company_id, driver_id)
    @company_id = company_id
    @driver_id = driver_id
  end

  def report
    all_reports.group_by {|r| r.from.to_date}.map{|date,reports| {date: date, activities: to_activities(reports) } }
  end

  protected

  def to_activities(reports)
    reports.map{|r| to_activity(r) }
  end

  def to_activity(report)
    {
      from: report.from.strftime('%k:%M'),
      to: report.to.strftime('%k:%M'),
      activity: report.activity,
      time: calculate_time(report)
    }
  end

  def calculate_time(report)
    time_diff = TimeDifference.between(report.from, report.to).in_general
    "#{time_diff[:hours]}h #{time_diff[:minutes]}m"
  end

  def all_reports
    ActivityReport.where(company_id: company_id,
                         driver_id: driver_id).order(from: :asc)
  end

end
