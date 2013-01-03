class PagosDetalhe < ActiveRecord::Base
 belongs_to :pago

    validates_presence_of :cota,:documento_numero,:pago_dolar,:pago_guarani,:persona_id
    before_save :calcs
    def calcs
        if pago.moeda == 0
           self.pago_guarani     = self.pago_dolar.to_f * pago.cotacao.to_i
           self.desconto_guarani = self.desconto_dolar.to_f * pago.cotacao.to_i
           self.interes_guarani  = self.interes_dolar.to_f * pago.cotacao.to_i

           self.pago_real     = self.pago_guarani.to_f / pago.cotacao_real.to_i
           self.desconto_real = self.desconto_guarani.to_f / pago.cotacao_real.to_i
           self.interes_real  = self.interes_guarani.to_f / pago.cotacao_real.to_i

        elsif pago.moeda == 1
           self.pago_dolar       = self.pago_guarani.to_f / pago.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / pago.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / pago.cotacao.to_i

           self.pago_real     = self.pago_guarani.to_f / pago.cotacao_real.to_i
           self.desconto_real = self.desconto_guarani.to_f / pago.cotacao_real.to_i
           self.interes_real  = self.interes_guarani.to_f / pago.cotacao_real.to_i
        else
           self.pago_guarani     = self.pago_real.to_f * pago.cotacao_real.to_i
           self.desconto_guarani = self.desconto_real.to_f * pago.cotacao_real.to_i
           self.interes_guarani  = self.interes_real.to_f * pago.cotacao_real.to_i

           self.pago_dolar       = self.pago_guarani.to_f / pago.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / pago.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / pago.cotacao.to_i
        end
    end
end
