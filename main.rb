# frozen_string_literal: true

require_relative './lib/sunrise_sunset_japan'

target_date = Date.new(2020, 12, 30)
sunrise_sunset = SunriseSunsetJapan.new(target_date)
# pp sunrise_sunset.target_date
# pp sunrise_sunset.list
pp sunrise_sunset.find_by(city: '横浜市')
