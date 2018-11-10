# frozen_string_literal: true

describe MealRepresenter do
  it 'renders element correctly' do
    dishes = build_stubbed_list(:dish, 4)
    meal = build_stubbed(:meal, dishes: dishes)

    json = described_class.represent(meal).to_json
    object = JSON.parse(json, symbolize_names: true)

    date = meal.meal_date.strftime('%Y-%m-%d')
    expect(object[:date]).to eq date
    expect(object[:period]).to eq meal.period.name
    expect(object[:dishes].size).to eq dishes.count
    expect(object[:dishes].first[:name]).to eq dishes.first.name
  end

  it 'renders collection correctly' do
    dishes = build_stubbed_list(:dish, 4)
    meal = build_stubbed_list(:meal, 4, dishes: dishes)

    json = described_class.represent(meal).to_json
    object = JSON.parse(json, symbolize_names: true)

    expect(object.size).to eq meal.size
  end
end
