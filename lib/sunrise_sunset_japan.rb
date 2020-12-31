# frozen_string_literal: true

require File.join(__dir__, 'sunrise_sunset_japan', 'scraper')

# 日の出・日の入り時刻を取得し、地域名で検索
class SunriseSunsetJapan
  attr_reader :target_date, :sunrise_sunset_list

  def initialize(target_date)
    @target_date = target_date

    @sunrise_sunset_list =
      Scraper.new(target_date)
             .sunrise_sunset_list
  end

  def find_by(prefecture: nil, city: nil)
    raise 'Required argument not present. (prefecture or city)' if prefecture.nil? && city.nil?

    return find_by_prefecture(prefecture) unless prefecture.nil?
    return find_by_city(city) unless city.nil?
  end

  alias list sunrise_sunset_list

  private

  def find_by_prefecture(value)
    sunrise_sunset_list.find { |sunrise_sunset| sunrise_sunset.prefecture.eql?(value) }
  end

  def find_by_city(value)
    sunrise_sunset_list.find { |sunrise_sunset| sunrise_sunset.city.eql?(value) }
  end
end
