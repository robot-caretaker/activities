class ActivityDataController < ApplicationController
  def create
    datum = ActivityDatum.new(company_id: params[:company_id],
                              driver_id: params[:driver_id],
                              timestamp: params[:timestamp],
                              latitude: params[:latitude],
                              longitude: params[:longitude],
                              accuracy: params[:accuracy],
                              speed: params[:speed])
    unless datum.latitude && datum.longitude
      render json: { error: 'latitude and longitude must be provided' }
      return
    end
    location_type = determinte_location_type(datum)
    datum.activity = ChooseActivityPolicy.new(datum.speed, location_type).activity
    unless datum.valid?
      Rails.logger.info datum.errors
      render json: { error: 'invalid params' }
      return
    end
    datum.save!
    notify_data_manager(datum)
    render json: { status: 'success' }
  end

  protected

  def determinte_location_type(datum)
    return nil unless datum.latitude && datum.longitude
    LocationLookup.new(datum.latitude, datum.longitude).location_type
  end

  def notify_data_manager(datum)
    # TODO This could be handle as a background/delayed job
    DataManager.new(datum).process
  end

end
