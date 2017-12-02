require 'rails_helper'

describe ActivityDataController, type: :controller do

  describe "POST #create" do
    let(:params) do
      {
         "company_id":123,
         "driver_id":456,
         "timestamp":"2017-10-30'T'13:45:23Z",
         "latitude":52.234234,
         "longitude":13.23324,
         "accuracy":12.0,
         "speed":123.45
       }
    end

    before do
      @policy_double = double(:activity_policy, activity: "cultivating")
      allow(ChooseActivityPolicy).to receive(:new).and_return(@policy_double)
    end

    it "returns http success" do
      post :create, params: params
      expect(response).to have_http_status(:success)
      new_record = ActivityDatum.where(company_id: 123,
                                       driver_id: 456,
                                       timestamp: Time.new(2017,10,30,13,45,23, "+00:00"),
                                       latitude: 52.234234,
                                       longitude: 13.23324,
                                       accuracy: 12.0,
                                       speed: 123.45).first
      expect(new_record).to_not be_nil
      expect(new_record.activity).to eq "cultivating"
    end


  end

end
