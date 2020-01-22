defmodule Lyrics.CLI do
    require Logger

    def main(argv) do
        argv 
            |> parse_args
            |> process
            |> write_to_file
    end

    def parse_args(argv) do
        OptionParser.parse(argv, switches: [help: :boolean],
                            aliases: [h: :help])
        |> elem(1)
        |> args_to_internal_representation()
    end
    
    def args_to_internal_representation([artist, song]) do
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
        {artist, song, Lyrics.APIFetcher.fetch(artist, song)}
    end

    def write_to_file({artist, song , lyrics}) do
        IO.inspect File.write("#{song}.txt", lyrics)
        Logger.info("Open file #{song}.txt")
    end
end