require File.expand_path '../../spec_helper.rb', __FILE__

shared_examples 'a meal parser' do |university_name|
  let(:fixtures) do
    file = File.dirname(__FILE__) + "/fixtures/#{university_name}.yml"
    YAML.load(ERB.new(File.read(file)).result)
  end

  let(:list_meals) do
    html_file = File.dirname(__FILE__) + "/files/#{university_name}.html"

    doc = File.open(html_file) { |f| Nokogiri::HTML(f) }

    klass = "Parser::#{university_name.camelize}Parser".constantize
    allow(klass).to receive(:open).and_return(nil)
    allow(Nokogiri).to receive(:HTML).and_return(doc)

    klass.parse
  end

  it 'has the same size' do
    expect(list_meals.size).to eq(fixtures.size)
  end

  it 'has the same period' do
    list_meals.each_with_index do |meal, i|
      expect(meal.period.id).to eq(fixtures[i]['period_id'])
    end
  end

  it 'has the same date' do
    list_meals.each_with_index do |meal, i|
      expect(meal.meal_date).to eq(fixtures[i]['meal_date'])
    end
  end

  it 'has the same # of dishes' do
    list_meals.each_with_index do |meal, i|
      expect(meal.dishes.size).to eq(fixtures[i]['dishes'].size)
    end
  end

  it 'has the same dishes' do
    list_meals.each_with_index do |meal, i|
      meal.dishes.each_with_index do |dish, j|
        expect(dish.name).to eq(fixtures[i]['dishes'][j])
      end
    end
  end
end

RSpec.describe :uel_parser, type: :model do
  it_behaves_like 'a meal parser', 'uel'
  it_behaves_like 'a meal parser', 'ufac'
end
