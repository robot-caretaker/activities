require 'rails_helper'

describe MergeReportPolicy do

  let(:new_datum) { Fabricate(:activity_datum, activity: "cultivating") }

  subject { described_class.new(new_datum) }

  let!(:non_adjacent_report) { Fabricate(:activity_report,
                                         to: new_datum.timestamp + 1.hour,
                                         from: new_datum.timestamp + 2.hours,
                                         activity: new_datum.activity) }

  context "with no adjacent data" do
    it { is_expected.to_not be_mergeable }
    it 'returns no data' do
      expect(subject.adjacent_activity_reports.length).to be 0
    end
  end

  context "with an adjacent report" do
    let!(:adjacent) { Fabricate(:activity_report,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                activity: new_datum.activity,
                                from: from_timestamp,
                                to: to_timestamp) }
    context "later in time" do
      let(:from_timestamp) { new_datum.timestamp + 2.seconds }
      let(:to_timestamp) { new_datum.timestamp + 2.hours }
      it { is_expected.to be_mergeable }
      it "returns the report" do
        expect(subject.adjacent_activity_reports.first).to eq adjacent
      end
    end
    context "earlier in time" do
      let(:from_timestamp) { new_datum.timestamp - 2.hours }
      let(:to_timestamp) { new_datum.timestamp - 2.seconds }
      it { is_expected.to be_mergeable }
      it "returns the report" do
        expect(subject.adjacent_activity_reports.first).to eq adjacent
      end
    end
  end

  context "with an adjacent report of different activity" do
    let!(:adjacent) { Fabricate(:activity_report,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                activity: "driving",
                                from: new_datum.timestamp + 2.seconds,
                                to: new_datum.timestamp + 2.hours) }
    it { is_expected.to_not be_mergeable }
    it 'returns no data' do
      expect(subject.adjacent_activity_reports.length).to be 0
    end
  end

end
