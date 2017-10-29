module Parser
  class UemParser
    URL = 'http://www.dct.uem.br/cardapio.htm'.freeze

    def parse
      response = fetch_html URL, encoding: 'UTF-16'
      response.css('table.MsoNormalTable tr').map do |tr|
        tds =  tr.css 'td'
        date = parse_date tds[1]
        lunch_dishes =  parse_dishes tds[2]
        dinner_dishes = parse_dishes tds[3]
        [Meal.new(dishes: lunch_dishes, meal_date: date, period: Period.lunch),
         Meal.new(dishes: dinner_dishes, meal_date: date, period: Period.dinner)]
      end.flatten
    end

    def parse_date td
      date = td.text.squish
      date += "/#{Time.now.year}"
      Date.strptime(date, '%d/%m/%Y')
    end

    def parse_dishes td
      dishes = td.children.map do |td_text|
        Dish.new(name: td_text.text.squish)
      end
      dishes.reject { |dish| dish.name.empty? }
    end
  end
end
