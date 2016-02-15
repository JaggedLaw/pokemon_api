require 'net/http'
require 'json'
require 'pry'

class PokemonService

  attr_accessor :evolutions

  def initialize
    @evolutions = Array.new
  end


  def get(url: "http://pokeapi.co/api/v1/", path: path)
    uri = URI(url + path + "/")
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def pokemon_info(info)
    path = "pokemon/#{info}"
    get(path: path)
  end

  def type_info
    path = "type"
    get(path: path)
  end

  def get_moves_for(pokemon)
    response = pokemon_info(pokemon)
    response["moves"].map do |move|
      move["name"]
    end
  end

  def get_evolutions(pokemon)
    response = pokemon_info(pokemon)
    if response["evolutions"] != []
      new_pokemon = response["evolutions"][0]["to"]
      @evolutions << new_pokemon
      get_evolutions(new_pokemon.downcase)
    end

    return evolutions
  end

  def get_types(pokemon)
    i = 0
    response = pokemon_info(pokemon)
    output_array = Array.new
    type_array = response["types"]
    type_array.each do |type|
      output_array << response["types"][i]["name"]
      i += 1
    end
    output_array
  end

  def get_pokemon_by_type(type)
    i = 1
    pokemons = Array.new
    while i < 50 do            # supposed to be 719 but takes too long to run
      response = get(path: "pokemon/#{i}")
      if get_types(response["name"].downcase).include?(type)
        pokemons << response["name"]
      end
      i += 1
    end
    pokemons
    # binding.pry
  end

end

ps = PokemonService.new
puts ps.get_evolutions("wartortle")
puts ps.get_types(6)
puts ps.get_pokemon_by_type("fire")
