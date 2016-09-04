require "net/http"

def base_url
  "http://localhost:5000/docs"
end

def request_url(id, type)
  if type == :pdf
    base_url + "/#{id}.pdf"
  else
    base_url + "/#{id}"
  end
end

i = 0
loop do
  first_request_type = i % 2 == 0 ? :html : :pdf
  second_request_type = i % 2 != 0 ? :html : :pdf

  url1 = request_url(1, first_request_type)
  url2 = request_url(2, second_request_type)

  result1, result2, matched_request_two, matched_request_one = nil

  t1 = Thread.new do
    result1 = Net::HTTP.get_response(URI(url1))

    matched_request_one = case result1["content-type"]
                          when "application/pdf"
                            first_request_type == :pdf
                          when "text/html;charset=utf-8"
                            first_request_type == :html
                          end
  end

  t2 = Thread.new do
    result2 = Net::HTTP.get_response(URI(url2))

    matched_request_two = case result2["content-type"]
                          when "application/pdf"
                            second_request_type == :pdf
                          when "text/html;charset=utf-8"
                            second_request_type == :html
                          end
  end

  [t1, t2].map(&:join)

  unless matched_request_one
    puts "request one asked for: #{first_request_type} but the returned content type was: #{result1["content-type"]}\r"
  else
    puts "request one went smoothly! have a cookie!"
  end

  unless matched_request_two
    puts "request two asked for: #{second_request_type} but the returned content type was: #{result2["content-type"]}\r"
  else
    puts "request two went smoothly! have a cookie!"
  end
  i+= 1
end
