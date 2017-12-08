module Requestable
  def headers
    {
      'Authorization' => "Token token=#{@token.token}",
      'Content-Type' => 'application/json'
    }
  end

  def host
    'http://todoable.teachable.tech/api'
  end

  def path
    klazz = respond_to? :item_class ? item_class : self.class

    base = "#{klazz.to_s.downcase}s"

    base = "#{@parent.path}/#{base}" if @parent

    "#{base}/#{@id}"
  end

  def url
    "#{host}/#{path}"
  end

  def uri
    URI url
  end

  def http
    Net::HTTP.new uri.host, uri.port
  end

  def get
    reponse = http.get url, headers

    JSON.parse(response.body)[self.class.to_s.downcase] if response.is_a? HTTPSuccess
  end

  def post attrs
    response = http.post url, attrs.to_json, headers

    JSON.parse response.body if response.is_a? Net::HTTPSuccess
  end

  def put attrs = {}
    # put is a special case. normally we'd PUT to an object to replace it with new attrs
    # BUT the api uses PUT to "finish" an item
    # SO if attrs has 'finish' => true key/value, then simply append to the base url and off we go

    the_url = attrs['finish'] ? "#{url}/finish" : url
    the_uri = URI the_url

    request = Net::HTTP::Put.new the_url, headers
    request.body attrs.to_json unless the_url.include? 'finish'

    Net::HTTP.start(the_uri.host, the_uri.port) { |http| http.request request }.is_a? Net::HTTPSuccess
  end

  def patch attrs
    response = http.patch url, attrs.to_json, headers

    JSON.parse response.body if response.is_a? HTTPSuccess
  end

  def delete
    http.delete(url).is_a? HTTPSuccess
  end

  # class methods

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def headers
      {
        'Authorization' => "Token token=#{@token.token}",
        'Content-Type' => 'application/json'
      }
    end

    def host
      'http://todoable.teachable.tech/api'
    end

    def path
      "#{self.class.to_s.downcase}s"
    end

    def url
      "#{host}/#{path}"
    end

    def uri
      URI url
    end

    def http
      Net::HTTP.new uri.host, uri.port
    end

    def get
      response = http.get url, headers

      JSON.parse response.body if response.is_a? Net::HTTPSuccess
    end

    def post attrs
      http.post(url, attrs.to_json, headers).is_a? Net::HTTPSuccess
    end
  end
end
