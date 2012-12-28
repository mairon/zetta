class SafraAveriado < ActiveRecord::Base
  attr_accessible :desconto, :informado, :produto_id, :safra_id, :safra_produto_id

  belongs_to :safra_produtos
  has_many :produtos


end
