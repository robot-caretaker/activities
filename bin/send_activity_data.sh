#!/bin/sh

# cultivating!
for min in `seq 0 1 3`;
do
  for sec in `seq 0 2 58`;
  do
    curl localhost:5000/activity_data/create -H "Content-Type: application/json" \
      -d "{\"company_id\":1, \"driver_id\":2, \"timestamp\":\"2017-12-01T10:$min:$sec\", \"latitude\":52.234234, \"longitude\":13.23324, \"accuracy\":12.0, \"speed\":123.45 }"
  done;
done;

# repairing
for min in `seq 5 1 15`;
do
  for sec in `seq 0 2 58`;
  do
    curl localhost:5000/activity_data/create -H "Content-Type: application/json" \
      -d "{\"company_id\":1, \"driver_id\":2, \"timestamp\":\"2017-12-01T11:$min:$sec\", \"latitude\":52.234234, \"longitude\":13.23324, \"accuracy\":12.0, \"speed\":0.5 }"
  done;
done;

# driving
for min in `seq 40 1 55`;
do
  for sec in `seq 0 2 58`;
  do
    curl localhost:5000/activity_data/create -H "Content-Type: application/json" \
      -d "{\"company_id\":1, \"driver_id\":2, \"timestamp\":\"2017-12-01T12:$min:$sec\", \"latitude\":-50.00, \"longitude\":13.23324, \"accuracy\":12.0, \"speed\":50.0 }"
  done;
done;

# Get report
curl localhost:5000/activity_reports/1/2
