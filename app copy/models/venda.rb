class Venda < ActiveRecord::Base
  has_many :clientes,          :order => 1
  has_many :vendas_produtos,   :order => 1
  has_many :vendas_financas,   :order => 1
  has_many :vendas_colaboradors,   :order => 1  
  has_many :vendas_entrada_produtos,   :order => 1
  belongs_to :persona

  validates_presence_of :cotacao,
                        :persona_id,
                        :persona_nome

  validates_presence_of :pedido_id, :if => :pedido?
  validates_uniqueness_of :pedido_id, :if => :pedido_dif?

  def pedido?
    self.pedido.to_i == 1
  end

  def pedido_dif?
    self.pedido_id.to_i != 0
  end

  def validate                         
    busca_pedido_cancel = Presupuesto.count(:id,:select => 'id', :conditions => ["status = 2 and id = ?", self.pedido_id])
    if busca_pedido_cancel.to_i > 0
      errors.add_to_base( "Este Pedido esta Cancelado, Por Favor Verifique." ) 
    end

  #VERIFICA SE SALDO E MAIOR QUE A QUANTIDADE DA VENDA
    if ( persona.estado.to_i == 1  )
      errors.add_to_base( "Cliente Bloqueado Consulte a Parte Administrativa" )      
    end
    #divida > que 90 dias
    dividas = Cliente.count(:id, :conditions => ["PERSONA_ID = ? AND LIQUIDACAO = 0 AND ( CURRENT_DATE - (VENCIMENTO+ 90) ) >= 90",self.persona_id])

    if (dividas.to_i >  0  )
      errors.add_to_base( "Cliente Bloqueado Por Pendencias con Mas 90 Dias, Consulte la Parte Administrativa" )      
    end
  end 

  def self.gerador_cotas(params)
    cota = 1
    venc = 0
    valor_gs = params[:valor_gs].to_f / params[:cotas].to_i
    valor_us = params[:valor_us].to_f / params[:cotas].to_i
    params[:cotas].to_i.times do
      VendasFinanca.create( :venda_id        => params[:id],
                            :tipo            => 1,
                            :data            => params[:data],
                            :local_pago      => params[:local_pago],
                            :cotacao         => params[:cotacao],
                            :fatura          => params[:fatura],
                            :vendedor_id     => params[:vendedor_id],
                            :vendedor_nome   => params[:vendedor_nome],
                            :clase_produto   => params[:clase_produto],
                            :fatura_legal    => params[:fatura_legal],
                            :fatura_legal_ruc=> params[:fatura_legal_ruc],
                            :documento_numero_01 => params[:documento_numero_01],
                            :documento_numero_02 => params[:documento_numero_02],
                            :documento_numero    => params[:documento_numero],
                            :persona_id      => params[:persona_id],
                            :persona_nome    => params[:persona_nome],
                            :moeda           => params[:moeda],
                            :cota            => cota,
                            :cota_guarani_01 => valor_gs.to_f,   
                            :cota_dolar_01   => valor_us.to_f,   
                            :data_cota_01    => params[:venci].to_date.months_since(venc.to_i) )
      cota += 1 
      venc += 1                      
      
    end                       

  end 


  def self.filtro_vendas(params)                                         #
    
    cond =  ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?
    
    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    elsif params[:tipo] == "DOCUMENTO"
      tipo = "documento_numero "
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    elsif params[:tipo] == "CLIENTE"
      tipo = "persona_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?

    end



    Venda.paginate( :select => 'id,data,status,local_venda,vendedor_nome,persona_nome,tipo,documento_numero_01,documento_numero_02,documento_numero,quantidade,total_dolar,total_guarani',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')
  end

  def before_save                                                        #
    @vendedor = Persona.find_by_nome(self.vendedor_nome);
    self.vendedor_id = @vendedor.id.to_i unless  self.vendedor_nome.blank?

    @mecanico = Persona.find_by_id(self.mecanico_id);
    self.mecanico_nome = @mecanico.nome.to_i unless  self.mecanico_id.blank?
  end

  def after_save

    if self.pedido.to_i == 1

      VendasProduto.destroy_all("venda_id = #{self.id}" )
      pedido_produto = PresupuestoProduto.all(:conditions => ["presupuesto_id = ?", self.pedido_id])

      pedido_produto.each do |pp|
        VendasProduto.create( :venda_id         => self.id,
                              :data             => self.data,
                              :moeda            => self.moeda,
                              :cotacao          => self.cotacao,
                              :persona_id       => self.persona_id,
                              :persona_nome     => self.persona_nome,
                              :clase_id         => pp.clase_id,
                              :grupo_id         => pp.grupo_id,
                              :deposito_id      => pp.deposito_id,
                              :deposito_nome    => pp.deposito_nome,
                              :taxa             => pp.taxa,
                              :produto_id       => pp.produto_id,
                              :produto_nome     => pp.produto_nome,
                              :fabricante_cod   => pp.fabricante_cod,
                              :quantidade       => pp.quantidade,
                              :unitario_dolar   => pp.unitario_dolar,
                              :unitario_guarani => pp.unitario_guarani,
                              :unitario_real    => pp.unitario_real,
                              :total_dolar      => pp.total_dolar,
                              :total_guarani    => pp.total_guarani,
                              :total_real       => pp.total_real,
                              :total_desconto   => 0,
                              :desconto         => 0,
                              :interes          => 0,
                              :clase_produto    => 0,
                              :vendedor_id      => self.vendedor_id,
                              :vendedor_nome    => self.vendedor_nome,
                              :preco_dolar      => pp.unitario_dolar,
                              :preco_guarani    => pp.unitario_guarani,
                              :preco_fixo_dolar => pp.unitario_dolar, 
                              :preco_fixo_guarani => pp.unitario_guarani, 
                              :preco_fixo_real => pp.unitario_real )
      end
      Presupuesto.find(self.pedido_id).update_attributes(:status => 1,:venda_id => self.id)
    end
    
  end


end
