require 'rails_helper'

describe ActivityReportController, type: :controller do

  describe "GET #show" do

    let(:report) { Fabricate(:activity_report) }
    let(:params) { { company_id: report.company_id, driver_id: report.driver_id } }
    let(:expected_report) { [ { 'date' => 'first' }, { 'date' => 'second' } ] }

    before do
      report_double = double(:daily_report, report: expected_report)
      allow(DailyReport).to receive(:new).with(report.company_id, report.driver_id).and_return(report_double)
    end

    it "returns http success" do
      get :show, params: params

      expect(response).to have_http_status(:success)
      body = JSON.parse(response.body)
      expect(body).to eq expected_report
    end
  end

end
