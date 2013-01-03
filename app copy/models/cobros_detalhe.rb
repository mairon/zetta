class CobrosDetalhe < ActiveRecord::Base
    belongs_to :cobro

    validates_presence_of :cota,:documento_numero,:cobro_dolar,:cobro_guarani,:persona_id
    before_save :calcs
    def calcs
        if cobro.moeda == 0
           self.cobro_guarani     = self.cobro_dolar.to_f * cobro.cotacao.to_i
           self.desconto_guarani = self.desconto_dolar.to_f * cobro.cotacao.to_i
           self.interes_guarani  = self.interes_dolar.to_f * cobro.cotacao.to_i

           self.cobro_real     = self.cobro_guarani.to_f / cobro.cotacao_real.to_i
           self.desconto_real = self.desconto_guarani.to_f / cobro.cotacao_real.to_i
           self.interes_real  = self.interes_guarani.to_f / cobro.cotacao_real.to_i

        elsif cobro.moeda == 1
           self.cobro_dolar       = self.cobro_guarani.to_f / cobro.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / cobro.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / cobro.cotacao.to_i

           self.cobro_real     = self.cobro_guarani.to_f / cobro.cotacao_real.to_i
           self.desconto_real = self.desconto_guarani.to_f / cobro.cotacao_real.to_i
           self.interes_real  = self.interes_guarani.to_f / cobro.cotacao_real.to_i
        else
           self.cobro_guarani     = self.cobro_real.to_f * cobro.cotacao_real.to_i
           self.desconto_guarani = self.desconto_real.to_f * cobro.cotacao_real.to_i
           self.interes_guarani  = self.interes_real.to_f * cobro.cotacao_real.to_i

           self.cobro_dolar       = self.cobro_guarani.to_f / cobro.cotacao.to_i
           self.desconto_dolar   = self.desconto_guarani.to_f / cobro.cotacao.to_i
           self.interes_dolar    = self.interes_guarani.to_f / cobro.cotacao.to_i
        end
    end
end
