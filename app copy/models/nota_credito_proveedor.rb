class NotaCreditoProveedor < ActiveRecord::Base
  has_many :nc_proveedor_fatura, :dependent => :delete_all
  has_many :nota_credito_proveedor_produto, :dependent => :delete_all
  has_many :nota_credito_proveedor_aplics, :dependent => :delete_all

  validates_presence_of :persona_id,:persona_nome,:cotacao

end
 