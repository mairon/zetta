class VendasProduto < ActiveRecord::Base
  belongs_to :venda
  belongs_to :produto
  validates_presence_of :produto_nome,:quantidade
  before_save :calcs  
  attr_accessor :current_user
  
  
#BUSCA PRODUTO NOTA DE CREDITO

  def self.nota_credito_produto(params)

    cod = "persona_id = #{params[:persona_id]} AND moeda = #{params[:moeda]} AND tipo = #{params[:tipo]}"
    VendasProduto.all( :select => 'id,data,quantidade,produto_id,produto_nome,codigo,taxa,fabricante_cod,unitario_dolar,total_dolar,iva_dolar,unitario_guarani,total_guarani,iva_guarani,deposito_id,deposito_nome,venda_id',
                    :conditions => [cod],
                    :order      => 'data desc,id desc')

  end

  def valid_stock
    if produto.tipo_produto == 0
    
      #VERIFICA SALDO EM STOCK DISPONIVEL
       saldo = Stock.sum('entrada - saida',:conditions => ["produto_id = ? AND data <= ?",self.produto_id, venda.data])
      if ( saldo.to_f  <= 0 )
        errors[:base] << ( "No tiene saldo Disponible" )
      end

      #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
      if ( self.quantidade > saldo.to_f   )
        errors[:base] << ("La quantidade es Mayor que su Saldo" )
      end

      #VERIFICA MAXIMO DE DESCONTO
      if self.current_user.to_i != 0
        if ( self.total_desconto.to_i > self.desconto.to_i   )
          errors[:base] << ("Descuento no Autorizando!" )
        end  
      end

    end

    if self.moeda == 0
      if ( self.unitario_dolar <= 0   )
        errors[:base] << ("Agrege lo Unitario" )
      end
      if ( self.total_dolar <= 0   )
        errors[:base] << ("Agrege lo Total" )
      end
    else
      if ( self.unitario_guarani <= 0   )
        errors[:base] << ("Agrege lo Unitario" )
      end
      if ( self.total_guarani <= 0   )
        errors[:base] << ("Agrege lo Total" )
      end
    end
  end

  def calcs                     #
	self.data = venda.data
    produto = Produto.find_by_id(self.produto_id);
    self.codigo = produto.codigo.to_s;
    self.fabricante_cod = produto.fabricante_cod.to_s;
  end
end
