def snapshot_data
  { 
    :load_average => { 
      :one_minute => sprintf("%.2f", rand).to_f, :five_minutes => sprintf("%.2f", rand).to_f
    }
  }
end