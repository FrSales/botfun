defmodule DiscordBot do
  use Nostrum.Consumer
  use HTTPoison.Base
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content |> String.downcase() |> String.split(" ", [parts: 2, trim: true]) do
      ["!ping"] -> Api.create_message(msg.channel_id, "pong!")
      ["!catfact"] -> get_cat_fact(msg.channel_id)
      ["!catimage"] -> get_cat_image(msg.channel_id)
      ["!chuckjoke"] -> get_chuck_norris_joke(msg.channel_id)
      ["!pokemon", pokemon] -> get_pokemon(pokemon, msg.channel_id)
      ["!disney", char] -> get_disney(char, msg.channel_id)
      ["!advice"] -> get_advice_slip(msg.channel_id)
      _ -> :ignore
    end
  end

  def get_cat_fact(channel_id) do
    case Apis.get_cat_fact() do
      {:ok, data} -> Api.create_message(channel_id, data)
      {:error, reason} -> Api.create_message(channel_id, "Error: #{reason}")
    end
  end

  def get_cat_image(channel_id) do
    case Apis.get_cat_image() do
      {:ok, data} -> Api.create_message(channel_id, data)
      {:error, reason} -> Api.create_message(channel_id, "Error: #{reason}")
    end
  end

  def get_chuck_norris_joke(channel_id) do
    case Apis.get_chuck_norris_joke() do
      {:ok, data} -> Api.create_message(channel_id, data)
      {:error, reason} -> Api.create_message(channel_id, "Error: #{reason}")
    end
  end

  def get_pokemon(pokemon, channel_id) do
    formpoke = pokemon |> String.trim() |> String.downcase()
    case Apis.get_pokemon(formpoke) do
      {:ok, data} -> Api.create_message(channel_id, data)
      {:error, 404} -> Api.create_message(channel_id, "Pokemon não encontrado!")
    end
  end

  def get_disney(char, channel_id) do
    formchar = char |> String.trim() |> String.replace(" ", "%20")
    case Apis.get_disney(formchar) do
      {:ok, data} -> Api.create_message(channel_id, data)
      #{:error, 404} -> Api.create_message(channel_id, "Personagem não encontrado!")
    end
  end

  def get_advice_slip(channel_id) do
    case Apis.get_advice_slip do
      {:ok, data} -> Api.create_message(channel_id, data)
      {:error, reason} -> Api.create_message(channel_id, "Error: #{reason}")
    end
  end
end
