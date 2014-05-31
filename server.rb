require 'sinatra'
require 'pg'
require 'pry'

def db_connection
  begin
    connection = PG.connect(dbname: 'movies')

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
    @recipes = conn.exec('SELECT * FROM recipes ORDER BY name LIMIT 20;')
  end
  @recipes = @recipes.to_a
  erb :recipes
end

get "/recipes/:id" do

  db_connection do |conn|
    @recipe_info = conn.exec_params('SELECT * FROM recipes ORDER BY name WHERE recipes.id = #{params[:id]} LIMIT 20;')
  end
  @actor_info = @recipe_info.to_a
  erb :actor_info
end