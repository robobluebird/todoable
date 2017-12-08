class Item
  include Requestable

  def initialize attrs = {}
    @name =        attrs['name']
    @src =         attrs['src']
    @id =          attrs['id']
    @finished_at = attrs['finished_at']
    @parent      = attrs['parent']
  end

  def finish
    @finished_at = Time.now.utc if put 'finish' => true
  end
end
