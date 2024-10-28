defmodule Apis do
  defp make_request(url, parser) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> {:ok, parser.(data)}
          {:error, _} -> {:error, "Failed to parse response"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, 404}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Request failed due to #{reason}"}
    end
  end

  def get_cat_fact() do
    url = "https://meowfacts.herokuapp.com/"
    make_request(url, fn(data) -> """
    Fato sobre gatos: #{data["data"]}
    """ end)
  end

  def get_cat_image() do
    url = "https://api.thecatapi.com/v1/images/search?limit=1"
    make_request(url, fn (data) ->
      data |> List.first |> Map.get("url")
    end)
  end

  def get_chuck_norris_joke() do
    url = "https://api.chucknorris.io/jokes/random"
    make_request(url, fn(data) -> data["value"] end)
  end

  def get_pokemon(pokemon) when is_binary(pokemon) do
    url = "https://pokeapi.co/api/v2/pokemon/#{pokemon}"
    make_request(url, fn(data) -> """
    Nome: #{data["name"]}
    Altura: #{data["height"]}
    Peso: #{data["weight"]}
    Normal: #{data["sprites"]["front_default"]}
    Shiny: #{data["sprites"]["front_shiny"]}
    """ end)
  end

  def get_advice_slip() do
    url = "https://api.adviceslip.com/advice"
    make_request(url, fn(data) -> """
    Conselho em inglês: #{data["slip"]["advice"]}
    """ end)
  end
end
