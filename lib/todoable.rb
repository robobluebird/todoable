require 'net/http'
require 'json'
require './lib/models/item'
require './lib/models/list'
require './lib/models/token'
require './lib/traits/requestable'
require './lib/traits/verbable'

class Todoable
  include Authenticateable

  def initialize attrs = {}
    @username = attrs['username']
    @password = attrs['password']

    authenticate!
  end

  def authenticate!
    token = authenticate @username, @password
    @token = ApiToken.new token: token
  end
end
