require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'recipes')

    yield(connection)

  ensure
    connection.close
  end
end

get "/" do
end

get "/recipes" do
  @recipes = nil
  db_connection do |conn|
    @recipes = conn.exec('SELECT * FROM recipes ORDER BY name;')
  end
  @recipes = @recipes.to_a
  erb :recipes
end

get "/recipes/:id" do
	@recipe_info = nil
  db_connection do |conn|
    @recipe_info = conn.exec_params("SELECT * FROM recipes WHERE id = #{params[:id]};")
  end
  @recipe_info = @recipe_info.to_a
  erb :recipe_info
end