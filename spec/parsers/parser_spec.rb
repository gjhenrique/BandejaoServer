require File.expand_path '../../spec_helper.rb', __FILE__

shared_examples 'a meal parser' do |options|

  university_name = options[:uni]
  response_file = options[:file] || "#{university_name}.html"
  parser_class = options[:class] || "#{university_name.camelize}Parser"
  type = options[:parser_type] || :html

  let(:fixtures) do
    file = File.dirname(__FILE__) + "/fixtures/#{university_name}.yml"
    YAML.load(ERB.new(File.read(file)).result)
  end

  let(:list_meals) do
    file = File.dirname(__FILE__) + "/files/#{response_file}"
    klass = "Parser::#{parser_class}".constantize
    parser = klass.new
    if type == :html
      doc = File.open(file) { |f| Nokogiri::HTML(f) }
      allow(parser).to receive(:open).and_return(nil)
      allow(Nokogiri).to receive(:HTML).and_return(doc)
    elsif type == :json
      contents = File.open(file).read
      allow(Net::HTTP).to receive(:post_form).and_return(contents)
      allow(contents).to receive(:body).and_return(contents)
    end

    parser.parse
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

RSpec.describe :parsers, type: :model do
  it_behaves_like 'a meal parser', uni: 'ufac'
end
