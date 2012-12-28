class SafraProduto < ActiveRecord::Base
  belongs_to :safra
  has_many   :safra_umidades, :order => 'informado', :dependent => :destroy
  has_many   :safra_impurezas, :order => 'informado', :dependent => :destroy
  has_many   :safra_averiados, :order => 'informado', :dependent => :destroy
  has_many   :safra_quebrados, :order => 'informado', :dependent => :destroy  
  has_many   :safra_verdosos, :order => 'informado', :dependent => :destroy  
  has_many   :safra_ardidos, :order => 'informado', :dependent => :destroy  
  has_many   :safra_brotados, :order => 'informado', :dependent => :destroy  


  before_save :finds

  def finds
	  prod = Produto.find_by_id(self.produto_id);
	  self.produto_nome = prod.nome.to_s unless self.produto_id.blank?
	end
end

