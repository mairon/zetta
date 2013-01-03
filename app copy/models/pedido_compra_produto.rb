class PedidoCompraProduto < ActiveRecord::Base
  belongs_to :pedido_compra
  
  validates_presence_of :produto_id,:produto_nome,:quantidade
  
  def before_save

    dep = Deposito.find_by_id(self.deposito_id,:select => 'id,nome')
    self.deposito_nome = dep.nome

  end   
  
  
end
