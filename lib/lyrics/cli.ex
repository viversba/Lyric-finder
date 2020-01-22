defmodule Lyrics.CLI do
    
    def main(argv) do
        argv 
            |> parse_args
            |> process
    end

    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean],
                            aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end
    
    def args_to_internal_representation([artist, song]) do
        artist = String.replace artist, " ", "%20"
        song = String.replace song, " ", "%20"
        {artist, song}
    end
    def args_to_internal_representation(_) do
        :help
    end

    def process(:help) do
        IO.puts """
            usage: lyrics "artist" "song name" 
        """
        System.halt
    end
    def process({artist, song}) do
        Lyrics.APIFetcher.fetch(artist, song)
    end
end