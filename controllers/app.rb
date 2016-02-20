get '/' do
  university = University.random
  meals_response university
end

get '/weekly/:university_name' do
  university = University.where(name: params[:university_name]).first
  meals_response university
end

def meals_response(university)
  respond_to do |format|
    @meals = Meal.weekly university
    format.html { erb :index }
    format.json { @meals.to_json }
  end
end
