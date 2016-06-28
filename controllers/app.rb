after do
  response.header['Content-Type'] += ';charset=utf-8' if response.header['Content-Type']
end

get '/' do
  erb :index
end

get '/weekly/:university_name' do
  @university = University.by_name params[:university_name]
  if @university
    @meals = Meal.weekly @university
    @meals.to_json
  else
    halt 404, { error: 'University not found' }.to_json
  end
end

get '/daily/:university_name' do
  @university = University.by_name params[:university_name]
  halt(404, erb(:university_not_found)) if @university.nil?
  @university = University.random.where(university: @university).first if @university.has_campus?
  @date = if params[:day].nil?
            DateTime.now
          else
            DateTime.strptime(params[:day], '%Y-%m-%d')
          end
  @meals = Meal.daily @university, @date
  erb :daily
end

get '/university/weekly/:university_name' do
  university_name = params[:university_name]
  if university_name.downcase ==  'all'
    universities = University.find_campus
  else
    university = University.by_name university_name
    universities = university.has_campus? ? university.universities : [university]
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
