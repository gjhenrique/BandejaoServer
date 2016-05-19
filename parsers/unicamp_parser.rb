# -*- coding: utf-8 -*-
require File.expand_path '../fetcher.rb', __FILE__

module Parser
  class Unicamp
    include Fetcher

    def translate_period(period_name)
      period_name = period_name.upcase
      if period_name == 'JANTAR'
        Period.dinner
      elsif period_name == 'ALMOçO' || period_name == 'ALMOÇO'
        Period.lunch
      elsif period_name == 'ALMOçO VEGETARIANO' || period_name == 'ALMOÇO VEGETARIANO'
        # Ruby does not have uppercase cedilla mark
        Period.vegetarian_lunch
      elsif period_name == 'JANTAR VEGETARIANO'
        Period.vegetarian_dinner
      end
    end

  end

  class UnicampCotucaParser < Unicamp
    URL = 'https://www1.sistemas.unicamp.br/Mobile/CardapioPrefeituraCampinasJSON'

    def parse
      response = fetch_json URL

      response['CARDAPIO'].map do |meal_json|
        meal = Meal.new
        meal_json.each do |k,v|
          if k == 'DATA'
            meal.meal_date = Date.strptime(v, '%Y-%m-%d')
          elsif k == 'TIPO'
            meal.period = translate_period v
          else
            meal.dishes << Dish.new(name: (k + ': ' + v))
          end
        end
        meal
      end
    end
  end

  class UnicampPflParser < Unicamp
    URL = 'https://www1.sistemas.unicamp.br/Mobile/CardapioPFL'

    def parse
      response = fetch_json URL
      return if response.key? 'erro'
      meals_response = response['cardapio'].nil? ? response : response['cardapio']

      meals_response.map do |meal_info|
        meal_filtered = meal_info.split(%r{<[BRbr]+\s+\/>})
                        .select { |dish| !dish.empty? }
                        .select { |dish| dish != 'OBSERVA&CCEDIL;&ATILDE;O:' }
                        .map { |dish| dish.gsub(%r{(<STRONG>|<\/STRONG>)}, '') }

        period = translate_period meal_filtered[0]
        date = extract_date meal_filtered[1]
        dishes = meal_filtered[2..-1].map { |dish| Dish.new name: dish }
        Meal.new period: period, meal_date: date, dishes: dishes
      end
    end

    # CONVERT 10 DE MAIO DE 2016 to DateTime(2016-05-10)
    def extract_date(raw_date)
      date_list = raw_date.split(' DE ')
      index = I18n.t('date.month_names', locale: 'pt-BR')
              .map { |month| month.upcase unless month.nil? }
              .find_index(date_list[1])
      date_list[1] = I18n.t('date.month_names', locale: 'en')[index]
      DateTime.strptime(date_list.join('/'), '%d/%B/%Y')
    end
  end
end
