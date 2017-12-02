class ActivityDataController < ApplicationController
  def create
    datum = ActivityDatum.new(company_id: params[:company_id],
                              driver_id: params[:driver_id],
                              timestamp: params[:timestamp],
                              latitude: params[:latitude],
                              longitude: params[:longitude],
                              accuracy: params[:accuracy],
                              speed: params[:speed])
    location_type = determinte_location_type(datum)
    datum.activity = ChooseActivityPolicy.new(datum.speed, location_type).activity
    datum.save!
  end

  protected

  def determinte_location_type(datum)
    # TODO
    :field
  end

end
