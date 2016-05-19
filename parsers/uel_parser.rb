# -*- coding: utf-8 -*-
require File.expand_path '../parser_helper.rb', __FILE__
require File.expand_path '../fetcher.rb', __FILE__

module Parser
  class UelParser
    include ParserHelper
    include Fetcher

    URL = 'http://www.uel.br/ru/pages/cardapio.php'

    # ZERO WIDTH NO-BREAK SPACE (U+FEFF)
    WEIRD_CHAR = 65_279.chr(Encoding::UTF_8)

    # <tr>
    # <td>Monday - 20/01/2016 </td>
    # <td>Tuesday - 21/01/2016 </td>
    # <tr>
    # <td>Rice</td> <!-- 1st dish of monday -->
    # <td>Rice</td> <!-- 1st dish of tuesday -->
    # </tr>
    # <tr>
    # <td><p>Beans</p><p>Pasta</p></td>
    # <!-- 2nd dish of monday. Sometimes there are two options inside a table data -->
    # <td><p>VEGETARIAN OPTION:</p><p>Lettuce</p>
    # <!-- 2nd dish of tuesday. We have to consider the vegetarian option as one dish-->
    # </tr>
    def parse
      doc = fetch_html URL, encoding: 'ISO-8859-1'

      odd_meals = parse_meals(doc, '#conteudoCT table tr td:nth-child(odd)')
      even_meals = parse_meals(doc, '#conteudoCT table tr td:nth-child(even)')

      odd_meals.concat(even_meals).sort_by(&:meal_date)
    end

    def parse_meals(doc, selector)
      td_list = doc.css(selector)

      meals_list = chunk_by_condition(td_list) { |td| td.text.squish.include? 'Feira' }

      # Because we have a odd days (Monday - Friday), the even tds of last tr is empty
      # <tr>
      # <td>Friday</td>
      # <td></td>
      # </tr>
      # <tr>
      meals_list.last[1] = meals_list.last[1].take_while do |td|
        !(td.xpath('./preceding-sibling::td').text.include?('Feira') && td.text.squish.empty?)
      end

      meal_builder = proc do |td|
        date_string = td.text.split(' ').last
        date = DateTime.strptime(date_string, '%d/%m/%Y')

        Meal.new(meal_date: date, period: Period.both)
      end

      dish_builder = proc do |td|
        p_list = td.css('p')
        if p_list.size > 0 && !(p_list[0].text.include? 'VEGETARIANA:')
          p_list.map do |p|
            dish_text = filter_text(p.text)
            Dish.new(name: dish_text) unless dish_text.empty?
          end
        else
          Dish.new(name: filter_text(td.text)) unless filter_text(td.text).empty?
        end
      end

      build_meals_from_list(meals_list, meal_builder: meal_builder, dish_builder: dish_builder)
    end

    def filter_text(text)
      text.squish.gsub(WEIRD_CHAR, '')
    end
  end
end
