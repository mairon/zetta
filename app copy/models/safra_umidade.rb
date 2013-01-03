class SafraUmidade < ActiveRecord::Base
  validates :informado, :desconto, :presence => true

  belongs_to :safra_produtos
  has_many :produtos

end
