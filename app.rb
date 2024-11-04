require "rack"

class App
  TIME_FORMATS = {
    "year" => "%Y",
    "month" => "%m",
    "day" => "%d",
    "hour" => "%H",
    "minute" => "%M",
    "second" => "%S",
  }.freeze

  def call(env)
    request = Rack::Request.new(env)

    if request.path_info == "/time"
      process_request(request)
    else
      response(404, "Not found")
    end
  end

  private

  def process_request(request)
    formats = request.params["format"]&.split(",")

    if formats.nil?
      return response(400, "No params")
    end

    unknown_formats = formats - TIME_FORMATS.keys
    if unknown_formats.any?
      return response(400, "Unknown time format [#{unknown_formats.join(", ")}]")
    end

    time = Time.now.strftime(TIME_FORMATS.values_at(*formats).join("-"))

    response(200, time)
  end

  def response(status, body)
    [status, { "Content-Type" => "text/plain" }, [body]]
  end
end
