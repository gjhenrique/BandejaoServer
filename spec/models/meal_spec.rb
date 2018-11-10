# frozen_string_literal: true

describe Meal, type: :model do
  let(:meals) do
    university = build(:meal).university
    date = DateTime.now.monday
    Meal.weekly university, date
  end

  context 'in same week' do
    before do
      setup_meals(:sunday, :monday, :outdated_monday)
    end

    it 'does not repeat same day meals' do
      expect(meals.count).to eq(2)
    end

    it 'is ordered by meal_date' do
      sunday = build(:meal, :sunday)
      expect(meals.first.meal_date).to eq(sunday.meal_date)
    end

    it 'discards outdated meal' do
      monday = build(:meal, :monday)
      pending("investigate why this is faling")
      expect(meals.last.updated_at.strftime('%Y-%m-%d')).to eq(monday.updated_at.strftime('%Y-%m-%d'))
    end
  end

  context 'in different week' do
    before do
      setup_meals(:previous_saturday, :monday, :this_saturday)
    end

    it 'contains only meals of this week' do
      expect(meals.count).to eq(2)
    end

    it 'contains the saturday of this week' do
      this_saturday = build(:meal, :this_saturday)
      expect(meals.last.meal_date).to eq(this_saturday.meal_date)
    end
  end

  context 'in different period' do
    before do
      create(:meal, :monday_dinner)
      setup_meals(:monday, :outdated_monday, :previous_saturday)
    end

    it 'does not duplicate same meal_date and period' do
      expect(meals.size).to eq(2)
    end
  end

  context 'in different year' do
    before do
      setup_meals(:end_of_year, :beginning_of_year)
    end

    it 'includes both meals from different meals in previous year' do
      check_meal :beginning_of_year
    end

    it 'includes both meals from different meals in next year' do
      check_meal :end_of_year
    end

    def check_meal(trait)
      meal = build(:meal, trait)
      meals = Meal.weekly(meal.university, meal.meal_date)
      expect(meals.size).to eq(2)
    end
  end

  context 'with dishes' do
    it 'returns two dishes' do
      meal = create(:meal, :one_dish)
      meal.dishes << build(:dish, :rice)

      meals = Meal.includes(:dishes).to_a
      expect(meals.first.dishes.size).to eq(2)
    end
  end

  private

  def setup_meals(*traits)
    traits.each do |trait|
      create(:meal, trait)
    end
  end
end
