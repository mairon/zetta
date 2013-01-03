class PresupuestoProduto < ActiveRecord::Base
    belongs_to :presupuesto

    validates_presence_of :produto_id,:produto_nome,:quantidade

    def before_save
        @deposito = Deposito.find_by_id(self.deposito_id);
        self.deposito_nome    = @deposito.nome.to_s;
        if self.moeda == 0
         self.unitario_guarani =  self.unitario_dolar.to_f * self.cotacao.to_f
         self.total_guarani    =  self.total_dolar.to_f * self.cotacao.to_f
         self.unitario_real    =  self.unitario_guarani.to_f / presupuesto.cotacao_real.to_f
         self.total_real       =  self.total_guarani.to_f / presupuesto.cotacao_real.to_f
        elsif self.moeda == 1
         self.unitario_dolar   =  self.unitario_guarani.to_f / self.cotacao.to_f
         self.total_dolar      =  self.total_guarani.to_f / self.cotacao.to_f
         self.unitario_real    =  self.unitario_guarani.to_f / presupuesto.cotacao_real.to_f
         self.total_real       =  self.total_guarani.to_f / presupuesto.cotacao_real.to_f
        else
         self.unitario_guarani  =  self.unitario_real.to_f * presupuesto.cotacao_real.to_f
         self.total_guarani     =  self.total_real.to_f * presupuesto.cotacao_real.to_f
         self.unitario_dolar    =  self.unitario_guarani.to_f / presupuesto.cotacao.to_f
         self.total_dolar       =  self.total_guarani.to_f / presupuesto.cotacao.to_f
        end
    end
end
