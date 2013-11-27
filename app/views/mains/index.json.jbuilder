json.array!(@mains) do |main|
  json.extract! main, :index
  json.url main_url(main, format: :json)
end
