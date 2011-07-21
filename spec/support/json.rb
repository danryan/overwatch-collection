def last_json
  Yajl.load(last_response.body)
end