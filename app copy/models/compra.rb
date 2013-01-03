class Compra < ActiveRecord::Base

  has_many :compras_produtos,   :order => 1
  has_many :compras_documentos, :order => 1
  has_many :compras_financas,   :order => 1
  has_many :compras_gastos,     :order => 1

  belongs_to :sueldo
  
  validates :cotacao,
            :cotacao_real,
            :moeda,
            :persona_id,
            :documento_numero_01,
            :documento_numero_02,
            :documento_numero,
            :documento_timbrado,
            :documento_timbrado,
            :presence => true

                        
  validates :documento_numero_01, 
            :documento_numero_02, :length => { :maximum => 3 }

                        
  validates :documento_timbrado, :length => { :is => 8 }

  
 validates_uniqueness_of :documento_numero  , :scope=>[:persona_id, :documento_numero_01, :documento_numero_02, :persona_nome], :message => " ja cadastrado."



  validates :cotacao, :numericality =>  { :greater_than => 0 }

  before_validation :calcs

  def self.filtro_busca_compra(params)
    if params[:seta].to_s == "0"
      cond =  ["AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"] unless params[:inicio].blank?
    else
      if params[:tipo] == "CODIGO"
        tipo = "id"
        cond =  [" AND #{tipo} = #{params[:busca]}"] unless params[:busca].blank?
      elsif params[:tipo] == "PROVEEDOR"
        tipo = "persona_nome"
        cond =  [" AND #{tipo} LIKE '%#{params[:busca]}%'"] unless params[:busca].blank?
      elsif params[:tipo] == "DOCUMENTO"
        tipo = "documento_nome"
        cond =  [" AND #{tipo} LIKE '%#{params[:busca]}%'"] unless params[:busca].blank?
      end
    end

    Compra.paginate(:select => 'id,documento_numero_01,documento_numero_02,documento_numero,tipo_compra,data,persona_nome',
                  :conditions => 'tipo_compra != 1' << cond.to_s,
                  :page       => params[:page],
                  :per_page   => 25,
                  :order      => 'data desc,id desc')
  end

  def self.filtro_busca_gasto(params)

    cond =  [" AND data BETWEEN '#{params[:inicio]}' AND '#{params[:final]}'"] unless params[:inicio].blank?

    if params[:tipo] == "CODIGO"
      tipo = "id"
      cond =  ["AND #{tipo} = #{params[:busca]} AND tipo_compra = 1 "] unless params[:busca].blank?
    else
      tipo = "persona_nome"
      cond =  ["AND #{tipo} LIKE '%#{params[:busca]}%' AND tipo_compra = 1 "] unless params[:busca].blank?
    end

    Compra.paginate(:select => "id,tipo_compra,data,documento_numero_01,documento_numero_02,documento_numero,persona_nome,rubro_descricao,total_guarani,total_dolar",
                    :conditions =>  "tipo_compra = 1 " << cond.to_s,
                    :page       => params[:page],
                    :per_page   => 25,
                    :order      => 'data desc,id desc')


  end

  def validate          #
    #QUANDO FOR DIFERENTE DE UMA IMPORTACAO
    if self.tipo_compra != 2
      #REGRA DOLAR============================================================
      if self.moeda == 0
        #OBRIGATORIO TOTAL DA FATURA
        if self.total_dolar.to_f <= 0
          errors.add_to_base( "Por Favor Agrege o Total de la Factura!" )
        end
      end

      #REGRA GUARANI==========================================================
      if self.moeda == 1

        #OBRIGATORIO TOTAL DA FATURA
        if self.total_guarani.to_f <= 0
          errors.add_to_base( "Por Favor Agrege o Total de la Factura!" )
        end
      end
    return false
    end
  end

  def calcs       #

    #tipo_compra = 0 compra normal
    #tipo_compra = 1 gastos
    #tipo_compra = 2 importacao

    if self.tipo_compra == 1
      @rubro = Rubro.find_by_id(self.rubro_id,:select => 'id,descricao,codigo')
      self.rubro_descricao    = @rubro.descricao.to_s
      self.rubro_cod_contabil = @rubro.codigo.to_s

      @rodados = Rodado.find_by_id(self.rodado_id,:select => 'id,placa')
      self.rodado_nome    = @rodados.placa.to_s unless self.rodado_id.blank?

      @empregado = Persona.find_by_id(self.empregado_id,:select => 'id,nome')
      self.empregado_nome = @empregado.nome.to_s unless self.empregado_id.blank?

      if self.descricao == ''
        self.descricao = "GASTO #{self.rubro_descricao} Prov #{self.persona_nome}"
      end
    elsif self.tipo_compra == 0
      self.descricao = "Compra Mercaderia Prov. #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"
    elsif self.tipo_compra == 2
      self.descricao = "Compra Importacion Prov. #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"
    elsif self.tipo_compra == 3
      self.descricao = "Compra De Bienes #{self.persona_nome} Doc. #{self.documento_numero_01} - #{self.documento_numero_02} - #{self.documento_numero}"

    end

    @persona = Persona.find_by_nome(self.persona_nome,:select => 'id,nome,ruc');
    self.persona_id  = @persona.id.to_i;
    self.persona_ruc = @persona.ruc.to_s;

    cotacao = self.cotacao.to_f

    @documento = Documento.find_by_id(self.documento_id,:select => 'id,nome');
    self.documento_nome = @documento.nome.to_s;

    #CALCULO COTACAO FATURA
    if self.moeda == 0
      #dolar / guarani

      self.exentas_guarani     =  self.exentas_dolar.to_f  * cotacao
      self.gravadas_05_guarani =  self.gravadas_05_dolar.to_f * cotacao
      self.gravadas_10_guarani =  self.gravadas_10_dolar.to_f * cotacao
      self.imposto_05_guarani  =  self.imposto_05_dolar.to_f * cotacao
      self.imposto_10_guarani  =  self.imposto_10_dolar.to_f * cotacao
      self.total_guarani       =  self.total_dolar.to_f * cotacao
      self.desconto_guarani    =  self.desconto_dolar.to_f * cotacao

      #guarani / real
      self.exentas_real     =  self.exentas_guarani.to_f  / cotacao_real
      self.gravadas_05_real =  self.gravadas_05_guarani.to_f / cotacao_real
      self.gravadas_10_real =  self.gravadas_10_guarani.to_f / cotacao_real
      self.imposto_05_real  =  self.imposto_05_guarani.to_f / cotacao_real
      self.imposto_10_real  =  self.imposto_10_guarani.to_f / cotacao_real
      self.total_real       =  self.total_guarani.to_f / cotacao_real
      self.desconto_real    =  self.desconto_guarani.to_f / cotacao_real

    elsif self.moeda == 1

       #guarani / dolar
      self.exentas_dolar     =  self.exentas_guarani.to_f  / cotacao
      self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / cotacao
      self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / cotacao
      self.imposto_05_dolar  =  self.imposto_05_guarani.to_f / cotacao
      self.imposto_10_dolar  =  self.imposto_10_guarani.to_f / cotacao
      self.total_dolar       =  self.total_guarani.to_f / cotacao
      self.desconto_dolar    =  self.desconto_guarani.to_f / cotacao
      #guarani / real
      self.exentas_real     =  self.exentas_guarani.to_f  / cotacao_real
      self.gravadas_05_real =  self.gravadas_05_guarani.to_f / cotacao_real
      self.gravadas_10_real =  self.gravadas_10_guarani.to_f / cotacao_real
      self.imposto_05_real  =  self.imposto_05_guarani.to_f / cotacao_real
      self.imposto_10_real  =  self.imposto_10_guarani.to_f / cotacao_real
      self.total_real       =  self.total_guarani.to_f / cotacao_real
      self.desconto_real    =  self.desconto_guarani.to_f / cotacao_real
    else

       #real / guarani
      self.exentas_guarani     =  self.exentas_real.to_f  * cotacao_real
      self.gravadas_05_guarani =  self.gravadas_05_real.to_f * cotacao_real
      self.gravadas_10_guarani =  self.gravadas_10_real.to_f * cotacao_real
      self.imposto_05_guarani  =  self.imposto_05_real.to_f * cotacao_real
      self.imposto_10_guarani  =  self.imposto_10_real.to_f * cotacao_real
      self.total_guarani       =  self.total_real.to_f * cotacao_real
      self.desconto_guarani    =  self.desconto_real.to_f * cotacao_real
      #real / dolar
      self.exentas_dolar     =  self.exentas_guarani.to_f  / cotacao
      self.gravadas_05_dolar =  self.gravadas_05_guarani.to_f / cotacao
      self.gravadas_10_dolar =  self.gravadas_10_guarani.to_f / cotacao
      self.imposto_05_dolar  =  self.imposto_05_guarani.to_f / cotacao
      self.imposto_10_dolar  =  self.imposto_10_guarani.to_f / cotacao
      self.total_dolar       =  self.total_guarani.to_f / cotacao
      self.desconto_dolar    =  self.desconto_guarani.to_f / cotacao


    end
  end

end
