helpers do
  def link_date_navigator(university, date, &block)
    result = link_navigator university, date - 1, 'fa-arrow-left'
    result.concat(capture(&block))
    result.concat link_navigator university, date + 1, 'fa-arrow-right'
    @_out_buf.concat(result)
  end

  def group_dishes(meals)
    dishes = meals.map(&:dishes)
    max_dishes = dishes.map(&:length).max
    dishes.map { |dish| dish.values_at(0...max_dishes) }.transpose
  end

  private

  def link_navigator(university, date, icon)
    formatted_date = date.strftime('%Y-%m-%d')
    "<a href=/daily/#{university.name}?day=#{formatted_date}><i class='fa #{icon}'></i></a>"
  end
end
