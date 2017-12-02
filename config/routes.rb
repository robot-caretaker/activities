Rails.application.routes.draw do
  get  'activity_reports/:company_id/:driver_id', to: 'activity_report#show'

  post 'activity_data/create'
end
