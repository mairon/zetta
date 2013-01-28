class Sueldo < ActiveRecord::Base

  has_many :sueldos_detalhes
  has_many :compras

  before_save :finds
  after_save :inserts
  def finds
    per = Persona.find_by_id(self.persona_id);
    self.persona_nome        = per.nome.to_s;
    self.salario             = per.salario.to_f;
    self.salario_minimo      = per.salario_minimo.to_f;
    self.comissao            = per.comissao.to_f;
    self.ci                  = per.ci.to_f;         
    self.ips                 = per.ips.to_f;

  end

  def inserts
    salario = SueldosDetalhe.count(:id, :conditions => ["tipo = 'SUELDO'"])
    if salario.to_i == 0
      if self.moeda == 0 
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :tipo             => 'SUELDO',
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,
                               :moeda            => self.moeda,
                               :descricao        => "SUELDO REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%B"),
                               :persona_id       => self.persona_id,
                               :estado           => 0,
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,                             
                               :credito_us       =>  self.salario.to_f,
                               :credito_gs       =>  0,
                               :credito_rs       =>  0,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)          
      elsif self.moeda == 1
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :tipo             => 'SUELDO',
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,
                               :moeda            => self.moeda,
                               :descricao        => "SUELDO REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%B"),
                               :persona_id       => self.persona_id,
                               :estado           => 0,
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,                             
                               :credito_us       =>  0,
                               :credito_gs       =>  self.salario.to_f,
                               :credito_rs       =>  0,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)          
      else
        SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                               :data             => self.data_inicio,
                               :vencimento       => self.data_inicio,
                               :tipo             => 'SUELDO',
                               :documento_numero_01 =>'000',
                               :documento_numero_02 =>'000',
                               :documento_numero    =>'700' + self.id.to_s,
                               :cota             => 0,
                               :estado           => 1,                               
                               :moeda            => self.moeda,
                               :descricao        => "SUELDO REFERENTE AL MES DE "+"#{self.data_inicio}".to_date.strftime("%B"),
                               :persona_id       => self.persona_id,
                               :estado           => 0,
                               :persona_id       => self.persona_id,
                               :persona_nome     => self.persona_nome,                             
                               :credito_us       =>  0,
                               :credito_gs       =>  0,
                               :credito_rs       =>  self.salario.to_f,
                               :debito_us        =>  0,
                               :debito_gs        =>  0,
                               :debito_rs        =>  0)          
      end
    end
  end
end
