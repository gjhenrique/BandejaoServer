# coding: utf-8
module Parser

  class UfscParser
    include Fetcher

    def fetch_pdf(url)
      doc = fetch_html url
      current_link = doc.css('#content .entry ul:first-of-type li:first-child a')
      current_url = current_link[0]['href']
      fetch_pdf_to_document current_url
    end
  end

  class UfscAraranguaParser < UfscParser
    include ParserHelper

    URL = 'http://ru.ufsc.br/campus-ararangua/'

    def parse
      doc = fetch_pdf URL
      filter_meals = filter_meals doc.css('body').children

      dates = I18n.t('date.day_names', locale: 'pt-BR').push('segunda')
      meals_chunk = chunk_by_condition(filter_meals) do |text|
        dates.any? { |date| date.include? text.split(' ')[0] }
      end

      handle_sunday meals_chunk

      meals_chunk.flat_map do |meal|
        raw_date = meal[0].split(' ')[1]
        date = DateTime.strptime(raw_date, '%d/%m/%Y')

        even = meal[1].select.each_with_index { |_, i| i.even? }
        dishes_even = even.map { |dish_text| Dish.new name: dish_text }

        odd = meal[1].select.each_with_index { |_, i| i.odd? }
        dishes_odd = odd.map { |dish_text| Dish.new name: dish_text }

        [Meal.new(period: Period.lunch, dishes: dishes_even, meal_date: date),
         Meal.new(period: Period.dinner, dishes: dishes_odd, meal_date: date)]
      end
    end

    private

    # Sunday has the date in the first position of the dishes
    # Also includes other useless informations
    def handle_sunday(meals_chunk)
      meals_chunk.last[0] = meals_chunk.last[0] + ' ' + meals_chunk.last[1].shift
      meals_chunk.last[1] = meals_chunk.last[1].take_while { |y| !y.include? 'Nutricionista' }
    end

    def filter_meals(elements)
      elements.drop_while { |b| !b.text.include? 'segunda'}
              .select { |b| !b.text.squish.empty? }
              .map { |b| b.text.squish.strip }
    end
  end

  class UfscCCAParser < UfscParser
    URL = 'http://ru.ufsc.br/cca-2/'

    def parse
      a = fetch_pdf URL
      puts a
    end
  end

  class UfscTrindadeParser
    include Fetcher

    URL = 'http://ru.ufsc.br/ru/'
    NBSP = Nokogiri::HTML('&nbsp;').text

    def parse
      doc = fetch_html URL

      dates_range = get_dates_range doc

      # The first table is easier to parse
      rows = doc.css('#content table:first-of-type tr')
      meals = rows[1..-1].map do |row|
        tds = row.css('td')
        date = meal_date tds[0], dates_range
        dishes = dishes tds[1..-1]
        Meal.new dishes: dishes, meal_date: date, period: Period.both
      end
    end

    private

    def get_dates_range(doc)
      dates = doc.css('#content .entry p:first-child')
      first_raw_date = dates.text.split(' ')[-3]
      second_raw_date = dates.text.split(' ')[-1]
      first_date = DateTime.strptime(first_raw_date, '%d/%m')
      second_date = DateTime.strptime(second_raw_date, '%d/%m/%Y')
      (first_date..second_date).to_a
    end

    def meal_date(td, dates_range)
      day_name = td.text.strip.gsub(NBSP, '')
      index = I18n.t('date.day_names', locale: 'pt-BR').find_index(day_name)
      day_name_en = I18n.t('date.day_names', locale: 'en')[index]
      dates_range.find { |date| day_name_en == date.strftime('%A') }
    end

    def dishes(tds)
      tds.map do |td|
        td_text = td.text.strip.gsub(NBSP, '')
        Dish.new(name: td_text) unless td_text.empty?
      end.compact
    end
  end
end
