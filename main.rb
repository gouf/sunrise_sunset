# frozen_string_literal: true

require 'mechanize'
require 'ostruct'
require 'date'

class SunriseSunsetJapan
  class Scraper
    attr_reader :sunrise_sunset_list, :target_date

    BASE_URL = 'https://motohasi.net/SunriseSunset/JapanSun.php'

    TABLE_DATA =
      Struct.new(
        :prefecture,
        :city,
        :sunrise,
        :sunset,
      )

    TARGET_PREFECTURES = %w[
      北海道
      青森県
      岩手県
      宮城県
      秋田県
      山形県
      福島県
      茨城県
      栃木県
      群馬県
      埼玉県
      千葉県
      東京都
      神奈川
      新潟県
      富山県
      石川県
      福井県
      山梨県
      長野県
      岐阜県
      静岡県
      愛知県
      三重県
      滋賀県
      京都府
      大阪府
      兵庫県
      奈良県
      和歌山
      鳥取県
      島根県
      岡山県
      広島県
      山口県
      徳島県
      香川県
      愛媛県
      高知県
      福岡県
      佐賀県
      長崎県
      熊本県
      大分県
      宮崎県
      鹿児島
      沖縄県
    ].freeze

    def initialize(target_date)
      @target_date = target_date

      page = Mechanize.new.get("#{BASE_URL}?TargetDate=#{target_date}&PCMode=")

      prefecture_elements =
        page.search('.MainTable td')
            .find_all { |td| TARGET_PREFECTURES.include?(td.text) }

      @sunrise_sunset_list =
        prefecture_elements.map do |prefecture_element|
          # 都道府県に該当する <td/> を基準として、一度親要素 (<tr/>) を辿り、各要素の値にアクセスする
          prefecture, city, sunrise, sunset =
            prefecture_element.parent
                              .search('td')
                              .map(&:text)

          TABLE_DATA.new(
            prefecture,
            city,
            DateTime.parse("#{target_date} #{sunrise} +09:00"),
            DateTime.parse("#{target_date} #{sunset} +09:00")
          )
        end
    end
  end
end

class SunriseSunsetJapan
  attr_reader :target_date, :sunrise_sunset_list

  def initialize(target_date)
    @target_date = target_date

    @sunrise_sunset_list = Scraper.new(target_date).sunrise_sunset_list
  end

  def find_by(prefecture: nil, city: nil)
    raise 'Required argument not present. (prefecture or city)' if prefecture.nil? && city.nil?

    return find_by_prefecture(prefecture) unless prefecture.nil?
    return find_by_city(city) unless city.nil?
  end

  alias_method :list, :sunrise_sunset_list

  private

  def find_by_prefecture(value)
    sunrise_sunset_list.find { |sunrise_sunset| sunrise_sunset.prefecture.eql?(value) }
  end

  def find_by_city(value)
    sunrise_sunset_list.find { |sunrise_sunset| sunrise_sunset.city.eql?(value) }
  end
end

target_date = Date.new(2020, 12, 30)
sunrise_sunset = SunriseSunsetJapan.new(target_date)
# pp sunrise_sunset.target_date
# pp sunrise_sunset.list
pp sunrise_sunset.find_by(city: '横浜市')
