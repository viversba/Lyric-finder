defmodule Lyrics.APIFetcher do
    require Logger

    @api_url Application.get_env(:lyrics, :api_url)

    def fetch(artist, song) do
        Logger.info("Fetching lyrics of #{song} by #{artist}...")
        url(artist, song)
            |> HTTPoison.get()
            |> handle_response
            # |> IO.inspect
    end

    def url(artist, song) do
        "#{@api_url}/#{artist}/#{song}"
    end
    
    def handle_response({_, %{status_code: status_code, body: body}}) do
        Logger.info("Done")
        parsed = body  
                |> Poison.Parser.parse!()
        lyrics = ~s(#{parsed["lyrics"]} \n)
        IO.write lyrics
    end
end