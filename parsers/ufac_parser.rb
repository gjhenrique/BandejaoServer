# -*- coding: utf-8 -*-
module Parser
  class UfacParser
    URL = 'http://proplan.ufac.br/cardapio-ru/'

    def parse
      doc = fetch_html URL

      doc.css("ul.nav.nav-tabs li a").flat_map do |a|
        meal_date = extract_date a.text
        id = a['href'].split('/').last
        li_list = doc.css("#{id} li")
        extract_meals li_list, meal_date
      end
    end

    def extract_date(element)
      date = element.split(" de ")
      index =  I18n.t("date.month_names", locale: "pt-BR").find_index(date[1])
      date[1] = I18n.t("date.month_names", locale: "en")[index]
      DateTime.strptime(date.join("/"), "%d/%B/%Y")
    end

    def extract_meals(li_list, meal_date)
      periods = {
        'Café da Manhã' => Period.breakfast,
        'Almoço' => Period.lunch,
        'Jantar' => Period.dinner
      }

      meal_condition = proc { |li| periods.key? li.text.squish }

      meal_builder = proc do |li|
        period = periods[li.text.squish]
        fail Exception, "Period cannot be null #{b[0]}" if period.nil?
        Meal.new(period: period, meal_date: meal_date)
      end

      dish_builder = proc { |li| Dish.new(name: li.text.squish) unless li.text.squish.empty? }

      build_meal(li_list, meal_condition: meal_condition, meal_builder: meal_builder, dish_builder: dish_builder)
    end
  end
end
