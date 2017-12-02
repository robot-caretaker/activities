require 'rails_helper'

describe ProcessPolicy do

  let(:new_datum) { Fabricate(:activity_datum) }

  subject { described_class.new(new_datum) }

  let!(:non_adjacent) { Fabricate(:activity_datum, timestamp: new_datum.timestamp + 1.hour) }

  context "with no adjacent data" do
    it { is_expected.to_not be_processable }
    it 'returns no data' do
      expect(subject.adjacent_activity_data.length).to be 0
    end
  end

  context "with an adjacent datum available" do
    let!(:adjacent) { Fabricate(:activity_datum,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                timestamp: timestamp) }

    context "later in time" do
      let(:timestamp) { new_datum.timestamp + 2.seconds }
      it { is_expected.to be_processable }
      it 'returns the datum' do
        expect(subject.adjacent_activity_data.first).to eq adjacent
      end
    end
    context "earlier in time" do
      let(:timestamp) { new_datum.timestamp - 2.seconds }
      it { is_expected.to be_processable }
      it 'returns the datum' do
        expect(subject.adjacent_activity_data.first).to eq adjacent
      end
    end
  end

  context "with an adjacent report" do
    let!(:adjacent) { Fabricate(:activity_report,
                                company_id: new_datum.company_id,
                                driver_id: new_datum.driver_id,
                                from: from_timestamp,
                                to: to_timestamp) }
    context "later in time" do
      let(:from_timestamp) { new_datum.timestamp + 2.seconds }
      let(:to_timestamp) { new_datum.timestamp + 2.hours }
      it { is_expected.to be_processable }
      it "returns the report" do
        expect(subject.adjacent_activity_reports.first).to eq adjacent
      end
    end
    context "earlier in time" do
      let(:from_timestamp) { new_datum.timestamp - 2.hours }
      let(:to_timestamp) { new_datum.timestamp - 2.seconds }
      it { is_expected.to be_processable }
      it "returns the report" do
        expect(subject.adjacent_activity_reports.first).to eq adjacent
      end
    end
  end

  context "with both an adjacent datum and report" do
    let!(:adjacent_report) { Fabricate(:activity_report,
                                       company_id: new_datum.company_id,
                                       driver_id: new_datum.driver_id,
                                       from: from_timestamp,
                                       to: to_timestamp) }
    let!(:adjacent_datum) { Fabricate(:activity_datum,
                                      company_id: new_datum.company_id,
                                      driver_id: new_datum.driver_id,
                                      timestamp: timestamp) }
    context "report is earlier, datum later" do
      let(:from_timestamp) { new_datum.timestamp - 2.hours }
      let(:to_timestamp) { new_datum.timestamp - 2.seconds }
      let(:timestamp) { new_datum.timestamp + 2.seconds }
      it { is_expected.to be_processable }
    end
    context "report is later, datum earlier" do
      let(:from_timestamp) { new_datum.timestamp + 2.seconds }
      let(:to_timestamp) { new_datum.timestamp + 2.hours }
      let(:timestamp) { new_datum.timestamp - 2.seconds }
      it { is_expected.to be_processable }
    end
  end

end
