class Collection
  def initialize attrs = {}
    @type = attrs['type'].to_sym
    @items = attrs['items'] || []
    @parent = attrs['parent']
  end

  def item_class
    Kernel.const_get @type.to_s.capitalize
  end

  def create attrs = {}
    new_item = item_class.new post attrs
    new_item.parent = @parent
    items << new_item
    new_item
  end
end
