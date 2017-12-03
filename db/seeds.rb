ActivityDatum.destroy_all
ActivityReport.destroy_all

def create_report(from, to, activity)
  ActivityReport.create!(company_id: 1,
                         driver_id: 1,
                         from: from,
                         to: to,
                         activity: activity)
end

create_report(Time.new(2017,10,30,9,0,0), Time.new(2017,10,30,9,30,0), "driving")
create_report(Time.new(2017,10,30,10,0,0), Time.new(2017,10,30,11,30,0), "repairing")
create_report(Time.new(2017,10,30,11,30,02), Time.new(2017,10,30,12,30,30), "cultivating")

create_report(Time.new(2017,10,31,8,0,0), Time.new(2017,10,30,9,30,0), "cultivating")
create_report(Time.new(2017,10,31,10,30,0), Time.new(2017,10,30,11,30,0), "repairing")
create_report(Time.new(2017,10,31,11,30,02), Time.new(2017,10,30,14,30,30), "driving")
