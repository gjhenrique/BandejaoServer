get '/' do
  university = University.random
  meals_response university
end

get '/weekly/:university_name' do
  university = University.where(name: params[:university_name]).first
  meals_response university
end

def meals_response(university)
  @universities = University.all
  respond_to do |format|
    if university
      @meals = Meal.weekly university
      format.html { erb :index }
      format.json { json @meals.to_json }
    else
      format.html { halt(404, erb(:index)) }
      format.json { halt(404, { error: 'Univerisity not found' }.to_json) }
    end
  end
end
