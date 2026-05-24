require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params = {})
  # Parse the URL string into a URI object
  uri = URI.parse(url)

  # Create the Net::HTTP object
  http = Net::HTTP.new(uri.host, uri.port)

  # Enable SSL if the URL uses https
  http.use_ssl = (uri.scheme == 'https')

  # Initialize the POST request
  request = Net::HTTP::Post.new(uri.path.empty? ? '/' : uri.path)
  
  # Set the content type to JSON and pass the body parameters
  request['Content-Type'] = 'application/json'
  request.body = body_params.to_json

  # Send the request and capture the response
  response = http.request(request)

  # Print the HTTP Status
  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  
  begin
    # Parse and pretty-print the JSON response to match expected output
    parsed_body = JSON.parse(response.body)
    puts JSON.pretty_generate(parsed_body)
  rescue JSON::ParserError
    # Fallback to standard body if it's not valid JSON
    puts response.body
  end
end
