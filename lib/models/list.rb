class List
  include Requestable

  def initialize attrs = {}
    @name = attrs['name']
    @src =  attrs['src']
    @id =   attrs['id']
    @items = Collection.new 'type' => 'item', 'parent' => self
  end

  def update
    attrs = { name: @name }

    new attrs if patch list: attrs
  end

  class << self
    def all
      get.map(&:new)
    end

    def find id
      new new('id' => id).get
    end

    def create attrs = {}
      new attrs if post list: attrs
    end
  end
end
