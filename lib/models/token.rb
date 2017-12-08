class ApiToken
  attr_reader :token

  def initialize attrs = {}
    @token = attrs['token']
  end
end
