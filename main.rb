# frozen_string_literal: true

require_relative './lib/sunrise_sunset_japan'

target_date = Date.new(2020, 12, 30)
sunrise_sunset = SunriseSunsetJapan.new(target_date)
# pp sunrise_sunset.target_date
# pp sunrise_sunset.list
pp yokohama = sunrise_sunset.find_by(city: '横浜市')
# =>
# #<struct SunriseSunsetJapan::Scraper::TABLE_DATA
#  prefecture="神奈川",
#  city="横浜市",
#  sunrise=
#   #<DateTime: 2020-12-30T06:50:05+09:00 ((2459213j,78605s,0n),+32400s,2299161j)>,
#  sunset=
#   #<DateTime: 2020-12-30T16:37:59+09:00 ((2459214j,27479s,0n),+32400s,2299161j)>>
pp yokohama.sunrise # => #<DateTime: 2020-12-30T06:50:05+09:00 ((2459213j,78605s,0n),+32400s,2299161j)>
pp yokohama.sunset # => #<DateTime: 2020-12-30T16:37:59+09:00 ((2459214j,27479s,0n),+32400s,2299161j)>
