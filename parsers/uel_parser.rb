module Parser
  class UelParser
    include Fetcher

    # This is a temporary workaround
    # In the future, we will use tesseract and friends to read from the image
    # Thanks, GuiaUEL.
    URL = 'https://guiauel.wordpress.com/cardapio-r-u-2'

    def parse
      doc = fetch_html URL
      trs = doc.css('.cardapio tr')
      trs[1..-1].map do |meal_tr|
        meal_tds = meal_tr.children.reject { |item| item.text.squish.empty? }
        date_text = meal_tds[0].text.split(' ').last
        date = DateTime.strptime(date_text, '%d/%M')
        dishes = meal_tds[1..-1].each_with_index.map do |dish_td, i|
          if i == 3
            Dish.new(name: 'Prato Vegetariano: ' + dish_td.text)
          else
            Dish.new(name: dish_td.text)
          end
        end
        Meal.new(dishes: dishes, meal_date: date, period: Period.both)
      end
    end
  end
end
