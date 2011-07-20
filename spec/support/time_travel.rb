def time_travel!
  Timecop.travel(Time.now + 1.minute)
end