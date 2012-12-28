class CobrosFinanca < ActiveRecord::Base
  belongs_to :cobro

  before_save :calcs
  def calcs
      conta = Conta.find_by_id(self.conta_id);
      self.conta_nome = conta.nome.to_s unless self.conta_id.blank?
      conta_vuelto = Conta.find_by_id(self.vuelto_conta_id);
      self.vuelto_conta_nome   = conta_vuelto.nome.to_s unless self.vuelto_conta_id.blank?

      documento = Documento.find_by_id(self.documento_id);
      self.documento_nome = documento.nome.to_s unless self.documento_id.blank?

      if self.moeda == 0
          self.valor_guarani = self.valor_dolar.to_f * cobro.cotacao.to_i
          self.retencion_guarani = self.retencion_dolar.to_f * cobro.cotacao.to_i
      else
          self.valor_dolar = self.valor_guarani.to_f / cobro.cotacao.to_i
          self.retencion_dolar = self.retencion_guarani.to_f / cobro.cotacao.to_i
      end
  end


end
