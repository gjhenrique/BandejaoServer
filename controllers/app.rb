after do
  response.header['Content-Type'] += ';charset=utf-8' if response.header['Content-Type']
end

get '/' do
  json 'OK'
end

get '/weekly/university/:university_name' do
  university_name = params[:university_name]
  universities = if university_name.downcase == 'all'
                   University.find_campus
                 else
                   university = University.by_name university_name
                   university.has_campus? ? university.universities : [university]
                 end

  universities_dict = universities.map do |un|
    {
      name: un.name,
      long_name: un.long_name,
      meals: Meal.weekly(un),
      website: un.website
    }
  end
  json universities_dict
end
