def time_travel!(future=(Time.now + 1.minute))
  Timecop.travel(future)
end