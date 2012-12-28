class TransferenciaDeposito < ActiveRecord::Base
  has_many :transferencia_deposito_detalhes, :dependent => :destroy   

  def before_save
    ingreso = Deposito.find_by_id(self.deposito_origem_id);
    self.deposito_origem_nome = ingreso.nome.to_s;

    destino = Deposito.find_by_id(self.deposito_destino_id);
    self.deposito_destino_nome = destino.nome.to_s;
  end

end
