require 'rails_helper'

describe DataManager do

  let(:new_datum) { Fabricate(:activity_datum, activity: "cultivating") }

  subject { described_class.new(new_datum) }

  context 'not mergeable' do
    it 'creates a new report' do
      expect { subject.process }.to change { ActivityReport.count }.by(1)
    end
  end

  context 'mergeable into one later report' do
    let!(:adjacent) { Fabricate(:activity_report,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                activity: new_datum.activity,
                                from: new_datum.timestamp + 2.seconds,
                                to: new_datum.timestamp + 2.hours) }
    it 'merges it into an existing report' do
      expect { subject.process }.to change { ActivityReport.count }.by(0)
      adjacent.reload
      expect(adjacent.from).to eq new_datum.timestamp
      expect(adjacent.to).to eq new_datum.timestamp + 2.hours
    end
  end

  context 'mergeable into one earlier report' do
    let!(:adjacent) { Fabricate(:activity_report,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                activity: new_datum.activity,
                                from: new_datum.timestamp - 2.hours,
                                to: new_datum.timestamp - 2.seconds) }
    it 'merges it into an existing report' do
      expect { subject.process }.to change { ActivityReport.count }.by(0)
      adjacent.reload
      expect(adjacent.to).to eq new_datum.timestamp
    end
  end

  context 'two mergeable reports' do
    let!(:adjacent_earlier) { Fabricate(:activity_report,
                                        company_id: new_datum.company_id,
                                        driver_id: new_datum.driver_id,
                                        activity: new_datum.activity,
                                        from: new_datum.timestamp - 2.hours,
                                        to: new_datum.timestamp - 2.seconds) }
    let!(:adjacent_later) { Fabricate(:activity_report,
                                      company_id: new_datum.company_id,
                                      driver_id: new_datum.driver_id,
                                      activity: new_datum.activity,
                                      from: new_datum.timestamp + 2.seconds,
                                      to: new_datum.timestamp + 2.hours) }
    it 'merges into the later report and deletes the earlier one' do
      expect { subject.process }.to change { ActivityReport.count }.by(-1)
      expect(ActivityReport.where(id: adjacent_earlier.id).first).to be_nil
      adjacent_later.reload
      expect(adjacent_later.from).to eq new_datum.timestamp - 2.hours
      expect(adjacent_later.to).to eq new_datum.timestamp + 2.hours
    end
  end
end
