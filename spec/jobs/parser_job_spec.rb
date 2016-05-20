require File.expand_path '../../spec_helper.rb', __FILE__

RSpec.describe ParserJob do
  it 'returns new meals from this week' do
    meals = sync_meals(build(:meal, :sunday), build(:meal, :monday))
    expect(meals.length).to eq(2)
  end

  it 'discards previous week meals' do
    meals = sync_meals(build(:meal, :previous_saturday))
    expect(meals).to eq(nil)
  end

  it 'discards next week meals' do
    meals = sync_meals(build(:meal, :next_monday))
    expect(meals).to eq(nil)
  end

  it 'can not create duplicated meals' do
    create(:meal, :monday)
    meals = sync_meals(build(:meal, :monday))
    expect(meals).to eq(nil)
  end

  it 'can not create duplicated meals with same dishes' do
    create(:meal, :monday, :one_dish)
    meals = sync_meals(build(:meal, :monday, :one_dish))
    expect(meals).to eq(nil)
  end

  it 'creates same meals with different dishes' do
    # one_fake_dish trait generates different dishes every time
    create(:meal, :monday, :one_fake_dish)
    meals = sync_meals(build(:meal, :monday, :one_fake_dish))
    expect(meals.length).to eq(1)
  end

  it 'creates meals with different periods' do
    create(:meal, :monday, :one_dish)
    meals = sync_meals(build(:meal, :monday_dinner, :one_dish))
    expect(meals.length).to eq(1)
  end

  private

  def sync_meals(*meals)
    parser_stub = double('parser')
    allow(parser_stub).to receive(:parse).and_return(meals)

    university = build(:meal).university
    logger = double('logger').as_null_object

    meal_sync = MealSynchronizer.new university, parser_stub, logger
    meal_sync.sync_meals
  end
end
