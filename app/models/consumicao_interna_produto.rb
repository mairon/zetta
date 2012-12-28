class ConsumicaoInternaProduto < ActiveRecord::Base
  belongs_to :consumicao_interna

  validates_presence_of :produto_id,:quantidade
  
  def validate                         #
    saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ?",self.produto_id])
    if ( saldo.to_f <= 0   )
      errors.add_to_base( "No tiene saldo Disponible" )
    end

    if ( self.quantidade > saldo.to_f   )
      errors.add_to_base( "La quantidade es Mayor que su Saldo" )
    end
    if self.moeda == 0
      if ( self.unitario_dolar <= 0   )
        errors.add_to_base( "Agrege lo Unitario" )
      end
      if ( self.total_dolar <= 0   )
        errors.add_to_base( "Agrege lo Total" )
      end
    else
      if ( self.unitario_guarani <= 0   )
        errors.add_to_base( "Agrege lo Unitario" )
      end
      if ( self.total_guarani <= 0   )
        errors.add_to_base( "Agrege lo Total" )
      end
    end
  end
  def before_save
     @deposito = Deposito.find_by_id(self.deposito_id);
     self.deposito_nome    = @deposito.nome.to_s;
     if self.moeda == 0
       self.total_guarani = self.total_dolar.to_f * self.cotacao.to_f
     else
       self.total_dolar = self.total_guarani.to_f / self.cotacao.to_f         
     end
  end

end
