class Asset
  attr_accessor :title, :file_type, :url, :alt, :description,
                :width, :height, :resolution, :device, :length,
                :is_readable, :created_at, :updated_at, :_id

  alias :id :_id
  alias :id= :_id=

  def self.all
    AssetWrapper.fetchAll.map{|attrs| Asset.new(attrs)}
  end

  def self.create(attrs={})
    AssetWrapper.create(attrs)
  end

  def initialize(attrs={})
    attrs.each do |k,v|
      method = "#{k}=".to_sym
      send(method, v) if respond_to? method
    end
  end
end
