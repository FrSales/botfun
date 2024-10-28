defmodule DiscordBot do
  use Nostrum.Consumer
  use HTTPoison.Base
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case String.split(msg.content, " ", [parts: 2, trim: true]) do
      ["!ping"] -> Api.create_message(msg.channel_id, "pong!")
      ["!catfact"] -> get_cat_fact(msg.channel_id)
      ["!catimage"] -> get_cat_image(msg.channel_id)
      ["!chuckjoke"] -> get_chuck_norris_joke(msg.channel_id)
      ["!pokemon", pokemon] -> get_pokemon(pokemon, msg.channel_id)
      ["!advice"] -> get_advice_slip(msg.channel_id)
      _ -> :ignore
    end
  end

  defp send_message(message, channel_id) do
    IO.inspect(channel_id)
    Api.create_message(channel_id, message)
  end

  def get_cat_fact(channel_id) do
    case Apis.get_cat_fact() do
      {:ok, data} -> send_message(data, channel_id)
      {:error, reason} -> send_message("Error: #{reason}", channel_id)
    end
  end

  def get_cat_image(channel_id) do
    case Apis.get_cat_image() do
      {:ok, data} -> send_message(data, channel_id)
      {:error, reason} -> send_message("Error: #{reason}", channel_id)
    end
  end

  def get_chuck_norris_joke(channel_id) do
    case Apis.get_chuck_norris_joke() do
      {:ok, data} -> send_message(data, channel_id)
      {:error, reason} -> send_message("Error: #{reason}", channel_id)
    end
  end

  def get_pokemon(pokemon, channel_id) do
    case Apis.get_pokemon(pokemon) do
      {:ok, data} -> send_message(data, channel_id)
      {:error, 404} -> send_message("Pokemon não encontrado!", channel_id)
    end
  end

  def get_advice_slip(channel_id) do
    case Apis.get_advice_slip do
      {:ok, data} -> send_message(data, channel_id)
      {:error, reason} -> send_message("Error: #{reason}", channel_id)
    end
  end
end
