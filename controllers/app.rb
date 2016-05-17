after do
  response.header['Content-Type'] += ';charset=utf-8' if response.header['Content-Type']
end

get '/' do
  @university = University.random
  meals_response @university
end

get '/weekly/:university_name' do
  @university = University.by_name params[:university_name]
  meals_response @university
end

def meals_response(university)
  @universities = University.all
  respond_to do |format|
    if university
      @meals = Meal.weekly university
      format.html { erb :index }
      format.json { @meals.to_json }
    else
      format.html { halt(404, erb(:university_not_found)) }
      format.json { halt(404, { error: 'University not found' }.to_json) }
    end
  end
end

get '/university/weekly/:university_name' do
  university_name = params[:university_name]
  if university_name.downcase == 'all'
    universities = University.find_campus
  else
    university = University.by_name university_name
    universities = university.has_campus? ? university.universities : [university]
  end
  universities_dict = universities.map do |un|
    {
      name: un.name,
      long_name: un.long_name,
      meals: Meal.weekly(un)
    }
  end
  json universities_dict
end
