# Given a new ActivityDatum, determine if it can be merged into another Report
#
# One ActivityData can be merged into a Report if the ActivityDatum is adjacent
# to one or more existing Reports
#
# Two records are adjacent if we do not expect to receive data in the timeline
# between them. Example:
#
# Given records are 2 seconds apart (HH:MM:SS):
# (09:00:00) and (09:00:02) are adjacent
# (09:00:00) and (09:00:04) are not adjacent (since we could later receive (09:00:02))
class MergeReportPolicy

  attr_reader :new_datum

  def initialize(new_datum)
    @new_datum = new_datum
  end

  def mergable?
    adjacent_activity_reports.any?
  end

  def adjacent_activity_reports
    base_query = ActivityReport.where(company_id: new_datum.company_id).
                                where(driver_id: new_datum.driver_id)
    earlier_reports = base_query.where(to: adjacent_times.first)
    later_reports = base_query.where(from: adjacent_times.last)
    earlier_reports + later_reports
  end

  protected

  def adjacent_times
    [new_datum.timestamp - 2.seconds, new_datum.timestamp + 2.seconds]
  end

end
