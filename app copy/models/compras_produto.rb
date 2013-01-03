class ComprasProduto < ActiveRecord::Base
  belongs_to :compra
  belongs_to  :produto

  validates_presence_of :quantidade,:produto_nome
  before_save :calcs

  def calcs

    @deposito = Deposito.find_by_id(self.deposito_id,:select => 'id,nome');
    self.deposito_nome = @deposito.nome.to_s unless self.deposito_id.blank?

    if self.moeda == 0
      self.custo_contabil_dolar   = self.unitario_dolar.to_f - self.iva_dolar.to_i
      #TOTAL_GUARANI
      self.total_guarani          = self.total_dolar.to_f * self.cotacao.to_i
      #iva GUARANI
      self.iva_guarani            = self.iva_dolar.to_f * self.cotacao.to_i
      #TOTAL IVA GUARANI
      self.iva_total_guarani      = self.iva_total_dolar.to_f * self.cotacao.to_i
      #DESCONTO_GUARANI
      self.desconto_guarani       = self.desconto_dolar.to_f * self.cotacao.to_i
      #FRETE_GUARANI
      self.frete_guarani          = self.frete_dolar.to_f * self.cotacao.to_i
      #DESPACHO_GUARANI
      self.despacho_guarani       = self.despacho_dolar.to_f * self.cotacao.to_i

      self.custo_contabil_guarani = self.custo_contabil_dolar.to_f * self.cotacao.to_i

      self.preco_venda_guarani    = self.preco_venda_dolar.to_f * self.cotacao.to_i

      self.preco_maiorista_guarani  = self.preco_maiorista_dolar.to_f * self.cotacao.to_i

      self.preco_minorista_guarani   = self.preco_minorista_dolar.to_f * self.cotacao.to_i

    else
      self.custo_contabil_guarani          = self.unitario_guarani.to_f - self.iva_guarani.to_f
      #TOTAL_DOLAR
      self.total_dolar      = self.total_guarani.to_f / self.cotacao.to_i
      #IVA GUARANI
      self.iva_dolar        = self.iva_guarani.to_f / self.cotacao.to_i
      #TOTAL IVA DOLAR
      self.iva_total_dolar  = self.iva_total_guarani.to_f / self.cotacao.to_i
      #DESCONTO_DOLAR
      self.desconto_dolar   = self.desconto_guarani.to_f / self.cotacao.to_i
      #FRETE_DOLAR
      self.frete_dolar      = self.frete_guarani.to_f / self.cotacao.to_i
      #DESPACHO_DOLAR
      self.despacho_dolar   = self.despacho_guarani.to_f / self.cotacao.to_i
      
      #PRECO VENDA
      self.preco_venda_dolar   = self.preco_venda_guarani.to_f / self.quantidade.to_i

      self.custo_contabil_dolar = self.custo_contabil_guarani.to_f / self.cotacao.to_i

      self.preco_venda_dolar    = self.preco_venda_guarani.to_f / self.cotacao.to_i

      self.preco_maiorista_dolar  = self.preco_maiorista_guarani.to_f / self.cotacao.to_i

      self.preco_minorista_dolar   = self.preco_minorista_guarani.to_f / self.cotacao.to_i

    end
  end

  after_save :calc_cust_preco_venda
  def calc_cust_preco_venda

    if self.tipo_compra != 3
      base_calc = Empresa.first(:select => 'base_calc_preco_venda')

     #BASE DE CALCULO USANDO ULTIMO CUSTO
      if  ( base_calc.base_calc_preco_venda.to_i == 0 )
        if self.porcen_balcao.to_f > 0
          recalculo = Stock.all( :select     => 'id,produto_id,deposito_id,entrada,saida,unitario_guarani,unitario_dolar,tabela,promedio_guarani', 
                                    :conditions => ["produto_id = ?",self.produto_id], 
                                    :order      => 'produto_id,data,status' )

            saldo_stock       = 0 
            valor_stock_gs    = 0 
            valor_stock_us    = 0 
            promedio_stock_gs = 0 
            promedio_stock_us = 0 

            recalculo.each do |prod_rec| 

            saldo_stock    += ( prod_rec.entrada.to_f - prod_rec.saida.to_f )
            prod_rec.update_attribute :saldo, saldo_stock.to_f

            #RECALCULO CUSTO ENTRADA
            if ( prod_rec.entrada.to_f > 0 )
              valor_stock_gs += ( prod_rec.entrada.to_f * prod_rec.unitario_guarani.to_f ) 
              valor_stock_us += ( prod_rec.entrada.to_f * prod_rec.unitario_dolar.to_f )
              promedio_stock_gs = ( valor_stock_gs.to_f / saldo_stock.to_f ) 
              promedio_stock_us = ( valor_stock_us.to_f / saldo_stock.to_f )

              prod_rec.update_attribute :promedio_guarani, promedio_stock_gs.to_f
              prod_rec.update_attribute :promedio_dolar, promedio_stock_us.to_f
            end 
           
            #RECALCULO CUSTO SAIDA
            if ( prod_rec.saida.to_f > 0 )
            
              prod_rec.update_attribute :promedio_guarani, promedio_stock_gs.to_f
              prod_rec.update_attribute :promedio_dolar, promedio_stock_us.to_f
            end

            #ZERA CUSTO
            if saldo_stock.to_f == 0
              promedio_stock_gs = 0
              promedio_stock_us = 0
              valor_stock_gs    = 0 
              valor_stock_us    = 0
              prod_rec.update_attribute :promedio_guarani, promedio_stock_gs.to_f 
              prod_rec.update_attribute :promedio_dolar, promedio_stock_us.to_f

            end

          end

          custo   = Stock.last(:conditions => ["produto_id = ? AND status = 0", self.produto_id], :order => 'data,id')

          promedio_us      = ( custo.promedio_dolar.to_f )
          promedio_gs      = ( custo.promedio_guarani.to_f )

          porcen_balcao   = self.porcen_balcao.to_f / 100.to_f
          adcional_balcao_us = promedio_us.to_f * porcen_balcao.to_f
          adcional_balcao_gs = promedio_gs.to_f * porcen_balcao.to_f

          porcen_maio        = ( self.porcen_maiorista.to_f / 100.to_f )
          adcional_maio_us   = promedio_us.to_f *  porcen_maio.to_f
          adcional_maio_gs   = promedio_gs.to_f *  porcen_maio.to_f

          porcen_mino     = ( self.porcen_minorista.to_f / 100.to_f )
          adcional_mino_us   = promedio_us.to_f *  porcen_mino.to_f
          adcional_mino_gs   = promedio_gs.to_f *  porcen_mino.to_f

          produto =   Produto.find_by_id(self.produto_id);

          produto.update_attribute :cotacao, self.cotacao.to_f
          produto.update_attribute :custo_produto_dolar_iva, ( custo.unitario_dolar.to_f.to_f )
          produto.update_attribute :custo_produto_guarani_iva, ( custo.unitario_dolar.to_f.to_f )
          produto.update_attribute :data, ( custo.data )

          produto.update_attribute :preco_venda_dolar, ( promedio_us.to_f + adcional_balcao_us.to_f)
          produto.update_attribute :preco_venda_guarani, ( promedio_gs.to_f + adcional_balcao_gs.to_f)

          produto.update_attribute :preco_maiorista_dolar, ( promedio_us.to_f + adcional_maio_us.to_f )
          produto.update_attribute :preco_maiorista_guarani,( promedio_gs.to_f + adcional_maio_gs.to_f )

          produto.update_attribute :preco_minorista_dolar,( promedio_us.to_f + adcional_mino_us.to_f )
          produto.update_attribute :preco_minorista_guarani,( promedio_gs.to_f + adcional_mino_gs.to_f)
        end

      #BASE DE CALCULO USANDO PRECO DE VENDA
      else

          custo     = Stock.last(:conditions => ["produto_id = ? AND status = 0", self.produto_id], :order => 'data')

          porcen_balcao   = self.porcen_balcao.to_f / 100.to_f
          adcional_balcao_us = custo.unitario_dolar.to_f * porcen_balcao.to_f
          adcional_balcao_gs = custo.unitario_guarani.to_f * porcen_balcao.to_f

          produto =   Produto.find_by_id(self.produto_id);

          produto.update_attribute :preco_venda_dolar, ( custo.unitario_dolar.to_f.to_f + adcional_balcao_us.to_f)
          produto.update_attribute :preco_venda_guarani, ( custo.unitario_guarani.to_f.to_f + adcional_balcao_gs.to_f)

          promedio_us      = ( produto.preco_venda_dolar.to_f )
          promedio_gs      = ( produto.preco_venda_guarani.to_f )

          porcen_maio        = ( self.porcen_maiorista.to_f / 100.to_f )
          adcional_maio_us   = promedio_us.to_f *  porcen_maio.to_f
          adcional_maio_gs   = promedio_gs.to_f *  porcen_maio.to_f

          porcen_mino     = ( self.porcen_minorista.to_f / 100.to_f )
          adcional_mino_us   = promedio_us.to_f *  porcen_mino.to_f
          adcional_mino_gs   = promedio_gs.to_f *  porcen_mino.to_f

          produto.update_attribute :cotacao, self.cotacao.to_f
          produto.update_attribute :custo_produto_dolar_iva, ( custo.unitario_dolar.to_f.to_f )
          produto.update_attribute :custo_produto_guarani_iva, ( custo.unitario_guarani.to_f.to_f )
          produto.update_attribute :data, ( custo.data )

          produto.update_attribute :preco_maiorista_dolar, ( promedio_us.to_f + adcional_maio_us.to_f )
          produto.update_attribute :preco_maiorista_guarani,( promedio_gs.to_f + adcional_maio_gs.to_f )

          produto.update_attribute :preco_minorista_dolar,( promedio_us.to_f + adcional_mino_us.to_f )
          produto.update_attribute :preco_minorista_guarani,( promedio_gs.to_f + adcional_mino_gs.to_f)
      end  
    end
  end
end

