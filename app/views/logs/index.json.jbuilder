json.array!(@logs) do |log|
  json.extract! log, :id, :type
  json.url log_url(log, format: :json)
end
