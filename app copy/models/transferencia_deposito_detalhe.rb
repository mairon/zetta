class TransferenciaDepositoDetalhe < ActiveRecord::Base
  belongs_to :transferencia_deposito	

  validates_presence_of :produto_id, :quantidade

  def validate      
    saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND data <= ? and deposito_id = ?",self.produto_id, transferencia_deposito.data,transferencia_deposito.deposito_origem_id])
    if ( saldo.to_f  <= 0 )
       errors.add_to_base( "No tiene saldo Disponible" )
    end

    #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( self.quantidade > saldo.to_f   )
      errors.add_to_base( "La quantidade es Mayor que su Saldo" )
    end
  end
  
  def before_save
      
	cust = Stock.last(:conditions => ["produto_id = ? and status = 0", self.produto_id])
    prod = Produto.find_by_id(self.produto_id);
    self.produto_nome = prod.nome.to_s;
    self.preco_dolar     = prod.preco_venda_dolar.to_f;
    self.preco_guarani = prod.preco_venda_guarani.to_f;
    self.custo_dolar     = cust.unitario_dolar.to_f;
    self.custo_guarani = cust.unitario_guarani.to_f;
  end
end
