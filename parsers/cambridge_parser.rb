# frozen_string_literal: true

module Parser
  class CambridgeParser
    include Fetcher

    URL = 'http://www.unicen.cam.ac.uk/food-and-drink/main-dining-hall'

    def parse
      doc = fetch_html URL
      table = doc.css '.content table:first-of-type'

      start_date = table.css 'thead tr th:nth-child(2)'
      rows = table.css 'tbody tr'
      date_range = parse_range(start_date, rows.size)

      rows.map do |row|
        day = row.css('th').text.strip
        meal_date = date_range.find { |date| day == date.strftime('%A') }

        dishes = parse_dishes(row.css('td p'))
        Meal.new(meal_date: meal_date, dishes: dishes, period: Period.both)
      end
    end

    def parse_range(week, days)
      initial_date_text = week.text.split(' ')[2]
      date = Time.strptime(initial_date_text, '%d/%m/%Y')
      date..(date + days - 1)
    end

    def parse_dishes(dishes_html)
      dishes_html.map do |td|
        dish_text = td.text
        dish_text.gsub! 'Mains', ''
        dish_text.gsub! 'Desserts', ''
        dish_text.gsub! 'Soup of the day', 'Soup:'
        dish_text = dish_text.squish.strip
        Dish.new(name: dish_text) unless dish_text.empty?
      end.compact
    end
  end
end
