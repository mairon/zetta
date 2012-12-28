class Sueldo < ActiveRecord::Base

  has_many :sueldos_detalhes
  has_many :compras

  def before_save
    @persona = Persona.find_by_id(self.persona_id);
    self.persona_nome        = @persona.nome.to_s;
    self.salario             = @persona.salario.to_f;
    self.salario_minimo      = @persona.salario_minimo.to_f;
    self.comissao            = @persona.comissao.to_f;
    self.ci                  = @persona.ci.to_f;         
    self.ips                 = @persona.ips.to_f;

  end

  def after_save
    @persona = Persona.find_by_id(self.persona_id);
    self.persona_nome        = @persona.nome.to_s;
    self.salario             = @persona.salario.to_f;
    self.salario_minimo      = @persona.salario_minimo.to_f;
    self.comissao            = @persona.comissao.to_f;
    self.ci                  = @persona.ci.to_f;         
    self.ips                 = @persona.ips.to_f;

    SueldosDetalhe.destroy_all("sueldo_id = #{self.id} AND cotacao IS NULL" )
    
    SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                           :data             => '#{self.ano}-#{self.mes}-01',
                           :descricao        => "SUELDO REFERENTE AL MES DE "+"#{self.ano}-#{self.mes}-01 ".to_date.strftime("%B"),
                           :persona_id       => self.persona_id,
                           :estado           => 0,
                           :persona_nome     => self.persona_nome,
                           :valor_guarani    => self.salario )
    if self.ips > 0
      SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                             :data             => '#{self.ano}-#{self.mes}-01',
                             :descricao        => "SUELDO REFERENTE AL MES DE "+"#{self.ano}-#{self.mes}-01 ".to_date.strftime("%B"),
                             :persona_id       => self.persona_id,
                             :estado           => 1,
                             :persona_nome     => self.persona_nome,
                             :valor_guarani    => self.ips )
    end                         

                           
    cancel = Cliente.all(:conditions => ["date_part('month', data) = '#{self.mes}' AND date_part('year', data) = '#{self.ano}' AND persona_id =  #{self.persona_id} AND tipo = '1' AND cobro_dolar + cobro_guarani  > 0 "])                       

    cancel.each do |debes|
    SueldosDetalhe.create( :sueldo_id        => self.id.to_i,
                           :data             => debes.data,
                           :descricao        => debes.tabela,
                           :persona_id       => self.persona_id,
                           :estado           => 1,
                           :persona_nome     => self.persona_nome,
                           :valor_guarani    => debes.cobro_guarani )
   end                        
                              
  end

end
