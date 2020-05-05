task(:umbrella) do
  # define variables
  user_location = "Merchandise Mart"
  DARKSKY_API_KEY = ENV.fetch("DARKSKY_API_KEY")
  GEOCODING_API_KEY = ENV.fetch("GEOCODING_API_KEY")

  # ask user input
  p "What is the location?"
  user_location = STDIN.gets.chomp

  # connect to API to get location
  geocoding_url = "https://maps.googleapis.com/maps/api/geocode/json?address=" + user_location + "&key=" + GEOCODING_API_KEY
  geocoding_raw_file = open(geocoding_url).read
  geocoding_parsed_file = JSON.parse(geocoding_raw_file)

  # fetch lat/lng and put into string
  result = geocoding_parsed_file.fetch("results")
  location = result.at(0).fetch("geometry").fetch("location")
  address_lat = location.fetch("lat").round(4).to_s
  address_lng = location.fetch("lng").round(4).to_s

  # connect to API and fetch data given the previous lat/lng
  weather_url = "https://api.darksky.net/forecast/" + DARKSKY_API_KEY + "/" + address_lat + "," + address_lng
  weather_raw_file = open(weather_url).read
  weather_parsed_file = JSON.parse(weather_raw_file)

  currently = weather_parsed_file.fetch("currently")
  hourly = weather_parsed_file.fetch("hourly").fetch("data")

  # Print Current Temp
  p "Current Temperature: " + currently.fetch("temperature").round(2).to_s

  # Print Outloock fopr next hour
  p "Temperature in 1 hour: " + hourly.at(0).fetch("temperature").round(2).to_s

  # Print whether a person should carry or not an umbrella
  rain = false 
  i = 0
  
  15.times do
    prob = hourly.at(i).fetch("precipProbability")
    #time = Time.at(hourly.fetch("data").at(i).fetch("time"))

    if prob > 0.5 then
       rain = true
       break
    end
    i += 1
  end

  if rain then
    p "Carry an umbrella"
  else
    p "Don't carrry an umbrella"
  end

end