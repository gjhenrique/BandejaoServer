class Meal < ActiveRecord::Base
  has_many :dishes
  belongs_to :period
  belongs_to :university

  # We could override hash and eql? in the meal model
  # There is a bug in the preloading of activities
  # Call dishes inside hash overrided method duplicates associated objects
  MealStruct = Struct.new(:meal_date, :period_id, :university_id, :dishes) do
    def to_model
      Meal.new(
        meal_date: meal_date,
        period: Period.find(period_id),
        university: University.find(university_id),
        dishes: dishes.map { |dish| Dish.new(name: dish) }
      )
    end
  end

  DEFAULT_FILTER = "'+1 day',  'weekday 0', '-7 day'"

  scope :by_year, (lambda do |date|
    where("strftime('%Y', date(?, #{DEFAULT_FILTER})) = " \
          "strftime('%Y', date(meal_date, #{DEFAULT_FILTER}))", date.strftime('%Y-%m-%d'))
  end)

  # Sqlite uses ISO dates (begins at monday and finishes at sunday)
  # This workaround sums 1 day to fix this (begins at sunday and finishes at saturday).
  scope :by_week, (lambda do |date|
    where("strftime('%W', date(?, #{DEFAULT_FILTER})) = strftime('%W', date(meal_date, #{DEFAULT_FILTER}))",
          date.strftime('%Y-%m-%d'))
  end)

  def self.weekly(university, date = DateTime.now)
    meals = where(university: university).by_week(date).by_year(date)
            .order('meal_date, period_id, updated_at DESC').includes(:dishes).to_a

    meals.uniq { |meal| [meal.period_id, meal.meal_date] }
  end

  def to_struct
    MealStruct.new(
      meal_date,
      period.id,
      university.id,
      dishes.map(&:name)
    )
  end

  def as_json(_)
    { date: meal_date, period: period.name, dishes: dishes.map(&:name) }
  end

  def to_s
    "Period: #{period} <-> meal_date: #{meal_date.strftime('#%Y-%M-%d')} " \
      "<-> #{dishes.map(&:name) unless dishes.nil?}"
  end
end
