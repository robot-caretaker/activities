require 'rails_helper'

describe DailyReport do

  before do
    Timecop.freeze(Time.new(2017,12,2,12,0,0))
  end

  after do
    Timecop.return
  end

  let(:company_id) { 242 }
  let(:driver_id)  { 23 }
  let!(:yesterday) { Fabricate(:activity_report,
                               company_id: company_id,
                               driver_id: driver_id,
                               activity: :driving,
                               from: Time.current - 1.day,
                               to: Time.current - 1.day + 2.hours) }
  let!(:today1) { Fabricate(:activity_report,
                            company_id: company_id,
                            driver_id: driver_id,
                            activity: :repairing,
                            from: Time.current,
                            to: Time.current + 2.hours) }
  let!(:today2) { Fabricate(:activity_report,
                            company_id: company_id,
                            driver_id: driver_id,
                            activity: :awol,
                            from: today1.to,
                            to: today1.to + 30.minutes) }

  subject { described_class.new(company_id, driver_id) }

  it 'builds the report' do
    expect(subject.report).to eq(
      [
        {
          date: Date.yesterday, activities: [
           {
             from: yesterday.from.strftime('%k:%M'),
             to: yesterday.to.strftime('%k:%M'),
             activity: "driving",
             time: "2h 0m"
           }
         ]
        }, {
          date: Date.today, activities: [
           {
             from: today1.from.strftime('%k:%M'),
             to: today1.to.strftime('%k:%M'),
             activity: "repairing",
             time: "2h 0m"
           }, {
             from: today2.from.strftime('%k:%M'),
             to: today2.to.strftime('%k:%M'),
             activity: "awol",
             time: "0h 30m"
           }
         ]
        },
      ]
    )
  end

end
