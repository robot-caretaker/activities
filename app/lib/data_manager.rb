# Given a new ActivityDatum, process it into an ActivityReport,
# either by creating a new one, or merging it with an existing one.
class DataManager

  attr_reader :new_datum, :merge_policy

  def initialize(new_datum)
    @new_datum = new_datum
    @merge_policy = MergeReportPolicy.new(new_datum)
  end

  def process
    if mergeable?
      merge
    else
      ActivityReport.create!(company_id: new_datum.company_id,
                              driver_id: new_datum.driver_id,
                              activity: new_datum.activity,
                              from: new_datum.timestamp,
                              to: new_datum.timestamp)
    end
  end

  protected

  delegate 'mergeable?', to: :merge_policy

  def merge
    preserving_record.from = earliest_timestamp
    preserving_record.to = latest_timestamp
    preserving_record.save!
    destroy_obsolete_record
  end

  def earliest_timestamp
    merge_policy&.earlier_report&.from || new_datum.timestamp
  end

  def latest_timestamp
    merge_policy&.later_report&.to || new_datum.timestamp
  end

  def preserving_record
    @preserving_record ||= merge_policy.later_report || merge_policy.earlier_report
  end

  def destroy_obsolete_record
    if merge_policy.earlier_report && merge_policy.later_report
      merge_policy.earlier_report.destroy
    end
  end

end
