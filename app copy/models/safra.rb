class Safra < ActiveRecord::Base
	validates :descricao, :presence => true	
  has_many :safra_produtos, :order => 1, :dependent => :destroy
end
