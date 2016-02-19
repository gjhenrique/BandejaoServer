require File.expand_path '../../spec_helper.rb', __FILE__
require File.expand_path '../../../jobs/parser_job.rb', __FILE__

RSpec.describe ParserJob do

  it 'persists new meals from this week' do
    call_job(build(:meal, :sunday), build(:meal, :monday))
    expect(Meal.count).to eq(2)
  end

  it 'discards previous week meals' do
    call_job(build(:meal, :previous_saturday))
    expect(Meal.count).to eq(0)
  end

  it 'discards next week meals' do
    call_job(build(:meal, :next_monday))
    expect(Meal.count).to eq(0)
  end

  it 'can not create duplicated meals' do
    create(:meal, :monday)
    call_job(build(:meal, :monday))
    expect(Meal.count).to eq(1)
  end

  it 'can not create duplicated meals with same dishes' do
    create(:meal, :monday, :one_dish)
    call_job(build(:meal, :monday, :one_dish))
    expect(Meal.count).to eq(1)
  end

  it 'creates same meals with different dishes' do
    # fake dish is generated with a different content
    create(:meal, :monday, :one_fake_dish)
    call_job(build(:meal, :monday, :one_fake_dish))
    expect(Meal.count).to eq(2)
  end

  it 'creates meals with different periods' do
    create(:meal, :monday, :one_dish)
    call_job(build(:meal, :monday_dinner, :one_dish))
    expect(Meal.count).to eq(2)
  end

  private

  def call_job(*meals)
    parser_stub = double('parser')

    # This is a code smell. We are relying on university always being the same instance of the factory
    university = build(:meal).university

    allow(University).to receive(:find).and_return(university)
    allow(university).to receive(:class_name).and_return(parser_stub)
    allow(parser_stub).to receive(:constantize).and_return(parser_stub)
    allow(parser_stub).to receive(:parse).and_return(meals)

    ParserJob.perform university.id
  end
end
