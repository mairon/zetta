class VendasFinanca < ActiveRecord::Base
    belongs_to :venda
    belongs_to :persona
    before_save :calcs    
    def calcs

        conta = Conta.find_by_id(self.conta_id);
        self.conta_nome   = conta.nome.to_s unless self.conta_id.blank?

        conta_vuelto = Conta.find_by_id(self.vuelto_conta_id);
        self.vuelto_conta_nome   = conta_vuelto.nome.to_s unless self.vuelto_conta_id.blank?


        if self.tipo.to_i == 0
            self.vencimento = self.data
        else
            self.diferido = self.data
        end

        if self.moeda == 0
            self.desconto_guarani      = self.desconto_dolar.to_f  * self.cotacao.to_f  
            self.valor_guarani_contado = self.valor_dolar_contado.to_f  * self.cotacao.to_f 
            self.cota_guarani_01       = self.cota_dolar_01.to_f  * self.cotacao.to_f 
        else
            self.desconto_dolar      = self.desconto_guarani.to_f / self.cotacao.to_f 
            self.valor_dolar_contado = self.valor_guarani_contado.to_f / self.cotacao.to_f
            self.cota_dolar_01       = self.cota_guarani_01.to_f / self.cotacao.to_f
        end

        if self.fatura == 0
           self.documento_nome   = 'COMPROBANTE VENTA'
           self.documento_id     = 10
           self.documento_numero = self.venda_id
        else
           self.documento_nome   = 'FACTURA VENTA'
           self.documento_id     =  9      
        end
        
       
        #DESCONTO PRORATEIO PRODUTO
        if self.tipo == 0
          if ( self.desconto_dolar.to_f + self.desconto_guarani.to_f) > 0 
             sum  = VendasProduto.sum(('preco_dolar * quantidade'), :conditions => ['venda_id = ?', self.venda_id]) 
             prod = VendasProduto.all(:conditions => ["venda_id = ?", self.venda_id])

             prod.each do |pd|

                #PORCENTAGEM
                tot_us = ( pd.preco_dolar.to_f * pd.quantidade.to_f )
                tot_gs = ( pd.preco_guarani.to_f * pd.quantidade.to_f )
                                
                porcentagem    = ( ( tot_us.to_f * 100 ) / sum.to_f )
                pd.update_attribute :porcentagem, porcentagem.to_f
            
                #TAXA 
                 taxa = ( ( ( pd.taxa.to_f / 100 ) + 1.00 ) * 10 )

                #DESC. 
                 desc_us =  ( tot_us.to_f - ( ( self.desconto_dolar.to_f * porcentagem.to_f ) / 100 ) )
                 desc_gs =  ( tot_gs.to_f - ( ( self.desconto_guarani.to_f * porcentagem.to_f ) / 100 ) )

                 pd.update_attribute :unitario_dolar, ( desc_us.to_f / pd.quantidade.to_f )
                 pd.update_attribute :total_dolar, desc_us.to_f 

                 pd.update_attribute :unitario_guarani, ( desc_gs.to_f / pd.quantidade.to_f )
                 pd.update_attribute :total_guarani, desc_gs.to_f 

                 pd.update_attribute :iva_dolar,   ( ( desc_us.to_f / pd.quantidade.to_f ) / taxa.to_f ) 
                 pd.update_attribute :iva_guarani, ( ( desc_gs.to_f / pd.quantidade.to_f ) / taxa.to_f ) 

             end
          end
          
        else
          
          if ( self.interes_us.to_f + self.interes_gs.to_f) > 0 
             sum  = VendasProduto.sum('preco_dolar * quantidade', :conditions => ['venda_id = ?', self.venda_id]) 
             prod = VendasProduto.all(:conditions => ["venda_id = ?", self.venda_id])

             prod.each do |pd|

                #PORCENTAGEM
                tot_us = ( pd.preco_dolar.to_f * pd.quantidade.to_f )
                tot_gs = ( pd.preco_guarani.to_f * pd.quantidade.to_f )
                
                porcentagem  = ( ( tot_us.to_f * 100 ) / sum.to_f )
                pd.update_attribute :porcentagem, porcentagem.to_f
                #TAXA 
                 taxa = ( ( ( pd.taxa.to_f / 100 ) + 1.00 ) * 10 )

                #DESC. 
                 int_us =  ( tot_us.to_f + ( ( self.interes_us.to_f * porcentagem.to_f ) / 100 ) )
                 int_gs =  ( tot_gs.to_f + ( ( self.interes_gs.to_f * porcentagem.to_f ) / 100 ) )

                 pd.update_attribute :unitario_dolar, ( int_us.to_f / pd.quantidade.to_f )
                 pd.update_attribute :total_dolar, int_us.to_f 

                 pd.update_attribute :unitario_guarani, ( int_gs.to_f / pd.quantidade.to_f )
                 pd.update_attribute :total_guarani, int_gs.to_f 

                 pd.update_attribute :iva_dolar,   ( ( int_us.to_f / pd.quantidade.to_f ) / taxa.to_f ) 
                 pd.update_attribute :iva_guarani, ( ( int_gs.to_f / pd.quantidade.to_f ) / taxa.to_f ) 

             end
          end
      
        end  
        
    end
end
