describe Parser::UfacParser, :vcr do
  it 'receives the correct meals for 2017-10-28' do
    expect(true).to be_truthy
    meals = described_class.new.parse
    dish_names = ['Fruta', 'Pão francês com manteiga', 'Leite integral', 'Café preto']

    expect(meals.first.period).to eq Period.breakfast
    expect(meals.first.meal_date.strftime('%Y-%m-%d')).to eq '2017-10-28'
    expect(meals.first.dishes.map(&:name)).to eq dish_names
  end
end
