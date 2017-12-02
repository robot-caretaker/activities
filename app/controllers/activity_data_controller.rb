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
    notify_data_manager(datum)
  end

  protected

  def determinte_location_type(datum)
    LocationLookup.new(datum.latitude, datum.longitude).location_type
  end

  def notify_data_manager(datum)
    # TODO This could be handle as a background/delayed job
    DataManager.new(datum).process
  end

end
