class Cobro < ActiveRecord::Base
  has_many :cobros_detalhes,   :order => 'documento_numero'
  has_many :cobros_financas,   :order => 'diferido'
  has_many :cobro_nc_fts
  belongs_to :persona

  validates_presence_of :cotacao,
                        :persona_nome,
                        :persona_id 
  def self.filtro(params)

    cond = ["data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}' "] unless params[:inicio].blank?

    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["#{tipo} = ? ","#{params[:busca]}"] unless params[:busca].blank?
    else
      tipo = "persona_nome"
      cond =  ["#{tipo} LIKE ? ","%#{params[:busca]}%"] unless params[:busca].blank?
    end

    Cobro.paginate( :select => 'id,data,moeda,adelanto,persona_nome',
                    :conditions => cond,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')
  end

  def after_save       #
    @persona          = Persona.find_by_id(self.vendedor_id);
    self.vendedor_nome = @persona.nome.to_s unless self.vendedor_id.blank? 

    if self.adelanto == 1 and self.adelanto_id != 0 
        Cliente.destroy_all("tabela = 'COBROS' AND tabela_id = #{self.id}" )
        ad = Adelanto.first(:conditions => ["id = ?", self.adelanto_id])
        if ad.status == 0

          Cliente.create( :tabela_id           => self.id.to_i,
                          :tabela              => 'COBROS',
                          :vencimento          => ad.data,
                          :persona_id          => ad.persona_id,
                          :persona_nome        => ad.persona_nome,
                          :documento_nome      => ad.documento_nome,
                          :clase_produto       => ad.clase_produto,
                          :moeda               => ad.moeda,
                          :documento_numero    => ad.id,
                          :cota                => 0,
                          :data                => ad.data,
                          :divida_dolar        => ad.valor_dolar.to_f,
                          :divida_guarani      => ad.valor_guarani.to_f,
                          :liquidacao          => 1,
                          :tipo                => '1',
                          :documento_numero_01 => '000',
                          :documento_numero_02 => '000',
                          :vendedor_id         => ad.vendedor_id,
                          :vendedor_nome       => ad.vendedor_nome )
        else
          Cliente.create( :tabela_id           => self.id.to_i,
                          :tabela              => 'COBROS',
                          :vencimento          => ad.data,
                          :persona_id          => ad.persona_id,
                          :persona_nome        => ad.persona_nome,
                          :documento_nome      => ad.documento_nome,
                          :clase_produto       => ad.clase_produto,
                          :moeda               => ad.moeda,
                          :documento_numero    => ad.id,
                          :cota                => 0,
                          :data                => ad.data,
                          :cobro_dolar        => ad.valor_dolar.to_f,
                          :cobro_guarani      => ad.valor_guarani.to_f,
                          :liquidacao          => 1,
                          :tipo                => '1',
                          :documento_numero_01 => '000',
                          :documento_numero_02 => '000',
                          :vendedor_id         => ad.vendedor_id,
                          :vendedor_nome       => ad.vendedor_nome )
        end
        cl_liqui = Cliente.all(:conditions => ["tabela = 'ADELANTOS' AND tabela_id = ?",self.adelanto_id])
        
        cl_liqui.each do |lq|
          lq.update_attribute :liquidacao, 1
        end
    end
  end
end
