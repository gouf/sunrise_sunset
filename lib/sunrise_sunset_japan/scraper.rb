# frozen_string_literal: true

require 'mechanize'
require 'ostruct'
require 'date'
require File.join(__dir__, 'scraper', 'constants')

# 日の出・日の入り時刻を取得し、地域名で検索
class SunriseSunsetJapan
  # Web ページから情報を取得
  class Scraper
    attr_reader :sunrise_sunset_list, :target_date

    TABLE_DATA =
      Struct.new(
        :prefecture,
        :city,
        :sunrise,
        :sunset
      )

    def initialize(target_date)
      @target_date = target_date

      prefecture_elements =
        target_page.search('.MainTable td')
                   .find_all { |td| Constants::TARGET_PREFECTURES.include?(td.text) }

      @sunrise_sunset_list = prefecture_elements.map(&:recapture_as_struct)
    end

    private

    def target_page
      Mechanize.new
               .get("#{Constants::BASE_URL}?TargetDate=#{target_date}&PCMode=")
    end

    def recapture_as_struct(prefecture_element)
      # 都道府県に該当する <td/> を基準として、一度親要素 (<tr/>) を辿り、各要素の値にアクセスする
      prefecture, city, sunrise, sunset =
        prefecture_element.parent
                          .search('td')
                          .map(&:text)

      # Struct として再構成
      TABLE_DATA.new(
        prefecture,
        city,
        DateTime.parse("#{target_date} #{sunrise} +09:00"),
        DateTime.parse("#{target_date} #{sunset} +09:00")
      )
    end
  end
end
