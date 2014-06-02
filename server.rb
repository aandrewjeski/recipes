require 'sinatra'
require 'pg'
require 'pry'
require 'will_paginate'
require 'will_paginate/array'
#require 'will_paginate/active_record'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

get "/" do
	redirect '/recipes'
end

get "/recipes" do
  @recipes = nil
  db_connection do |conn|
    @recipes = conn.exec('SELECT * FROM recipes ORDER BY name;')
  end
  @recipes = @recipes.to_a
  @recipes = @recipes.paginate(:page => params[:page], :per_page => 20)
  erb :recipes
end

get "/recipes/:id" do
	@recipe_info = nil
  db_connection do |conn|
    @recipe_info = conn.exec_params("SELECT recipes.name AS name,
    	recipes.instructions AS instructions, recipes.description AS description, 
    	ingredients.name AS ingredients
    	FROM recipes
    	JOIN ingredients ON recipes.id = ingredients.recipe_id
    	WHERE recipes.id = #{params[:id]};")
  end
  @recipe_info = @recipe_info.to_a
  erb :recipe_info
end