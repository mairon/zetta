class NotaCreditoProveedor < ActiveRecord::Base
  has_many :nc_proveedor_fatura, :dependent => :destroy
  has_many :nota_credito_proveedor_produto, :dependent => :destroy
  has_many :nota_credito_proveedor_aplics, :dependent => :destroy

  validates_presence_of :persona_id,:persona_nome,:cotacao

end
 