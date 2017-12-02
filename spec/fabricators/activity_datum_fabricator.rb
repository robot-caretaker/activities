Fabricator(:activity_datum) do
  company_id 1
  driver_id  1
  timestamp  "2017-12-02 16:16:13"
  latitude   1.5
  longitude  1.5
  accuracy   1.5
  speed      1.5
  activity :driving
end
