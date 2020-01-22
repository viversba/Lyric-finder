defmodule Lyrics.APIFetcher do
    require Logger

    @api_url Application.get_env(:lyrics, :api_url)

    def fetch(artist, song) do
        Logger.info("Fetching lyrics of #{song} by #{artist}...")
        artist = String.replace(artist, " ", "%20")
        song = String.replace(song, " ", "%20")
        url(artist, song)
            |> HTTPoison.get()
            |> handle_response
    end

    def url(artist, song) do
        "#{@api_url}/#{artist}/#{song}"
    end
    
    def handle_response({_, %{status_code: 200, body: body}}) do
        Logger.info("Done")
        parsed = body  
                |> Poison.Parser.parse!()
        lyrics = ~s(#{parsed["lyrics"]} \n)
        lyrics
    end
    def handle_response({_, %{status_code: _, body: body}}) do
        Logger.info("Couldn't find song")
        System.halt
    end
end