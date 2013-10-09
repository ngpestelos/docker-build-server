# vim:fileencoding=utf-8
require 'json'
require 'rack/request'

class DockerBuildServer
  VERSION = '0.1.0'

  def call(env)
    request = Rack::Request.new(env)
    accept = (request.env['HTTP_ACCEPT'] || 'text/html')
             .downcase.gsub(/\s*;.*/, '')
    case request.path
    when %r{^/?$}
      redirect_to_index(request)
    when %r{^/?index.html$}
      send(:"index_#{request.request_method.downcase}", request, accept)
    when %r{^/?docker-build$}
      docker_build(request, accept)
    else
      zomg404(request)
    end
  rescue NoMethodError
    zomg405(request)
  end

  private

  def redirect_to_index(request)
    [
      301,
      {'Location' => '/index.html'},
      ['']
    ]
  end

  def index_get(request, accept)
    case negotiate_content_type(
      accept, ['text/html', 'application/json']
    )
    when 'text/html'
      [
        200,
        {'Content-Type' => 'text/html; charset=utf-8'},
        [INDEX_HTML.result(binding)]
      ]
    when 'application/json'
      [
        200,
        {'Content-Type' => 'application/json; charset=utf-8'},
        [JSON.pretty_generate({nobody: :home})]
      ]
    end
  end

  def docker_build(request, accept)
    build_response = {}
    case negotiate_content_type(
      accept, ['text/html', 'application/json']
    )
    when 'text/html'
      [
        301,
        {'Location' => '/index.html'},
        ['']
      ]
    when 'application/json'
      [
        201,
        {'Content-Type' => 'application/json; charset=utf-8'},
        [JSON.pretty_generate(build_response) + "\n"]
      ]
    end
  end

  def zomg404(request)
    [
      404,
      {'Content-Type' => 'text/plain; charset=utf-8'},
      ["#{request.request_method} #{request.path} DOES NOT EXIST, HUMAN!\n"]
    ]
  end

  def zomg405(request)
    [
      405,
      {'Content-Type' => 'text/plain; charset=utf-8'},
      ["YOU CAN'T #{request.request_method} A #{request.path}, HUMAN!\n"]
    ]
  end

  def negotiate_content_type(accept, available)
    accept.split(/,/).map { |type| type.gsub(/;.*/, '') }.each do |acceptable|
      if available.include?(acceptable)
        return acceptable
      end
    end
    'text/html'
  end

  INDEX_HTML = ERB.new(<<-EOTMPL.gsub(/^ {2}/, ''))
  <!DOCTYPE html>
  <html>
    <head>
      <title>Docker Build Server</title>
      <style type="text/css">
        body { font-family: monospace; }
      </style>
    </head>
    <body>
      <h1>Docker Build Server</h1>
      <form name="docker_build" action="/docker-build" method="post">
        <label for="repo">Repo</label>
        <input type="text" name="repo" />
        <label for="ref">Ref</label>
        <input type="text" name="ref" />
        <input type="submit" value="Build!" />
      </form>
    </body>
  </html>
  EOTMPL
end
