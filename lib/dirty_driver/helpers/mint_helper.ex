defmodule DirtyDriver.MintHelper do

  def connect_to_session do
    try do
      {:ok, conn} = Mint.HTTP.connect(:http, "127.0.0.1", 4444)
      conn
    rescue
      MatchError -> raise("Could not connect to browser\n\tCheck the driver is in the PATH")
    end
  end

  def receive_message(conn, request_ref) do
    receive do
      message ->
        {:ok, conn, responses} = Mint.HTTP.stream(conn, message)

        for response <- responses do
          case response do
            {:status, ^request_ref, status_code} ->
              IO.puts("> Response status code #{status_code}")

            {:headers, ^request_ref, headers} ->
              IO.puts("> Response headers: #{inspect(headers)}")

            {:data, ^request_ref, data} ->
              IO.puts("> Response body")
              IO.puts(data)
              {status, mapper} = JSON.decode(data)
              IO.inspect(mapper)

            {:done, ^request_ref} ->
              IO.puts("> Response fully received")
          end
        end
    end
  end

  def value_from_response(res) do
    {map, _} = List.pop_at(res, 2)
    map
  end

end

