get '/' do
  json 'OK'
end

get '/university' do
  universities = University.find_campus
  json UniversityRepresenter.represent(universities.to_a)
end

get '/university/:university_name' do
  university = University.by_name params[:university_name]
  json UniversityRepresenter.represent(university)
end

get '/weekly/meals/:university_name' do
  university_name = params[:university_name]
  university = University.by_name university_name
  meals = Meal.weekly(university)

  json MealRepresenter.represent(meals)
end
