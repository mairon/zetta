# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130202144950) do

  create_table "adelantos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "diferido"
    t.string   "cheque",             :limit => 50
    t.decimal  "cotacao",                           :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "tipo"
    t.integer  "conta_id"
    t.string   "conta_nome",         :limit => 100
    t.integer  "persona_id"
    t.string   "persona_nome",       :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",     :limit => 150
    t.string   "documento_numero",   :limit => 150
    t.decimal  "valor_dolar",                       :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                     :precision => 15, :scale => 2
    t.string   "concepto",           :limit => 200
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_updated"
    t.integer  "usuario_created"
    t.string   "rubro_cod_contabil", :limit => 150
    t.string   "rubro_descricao",    :limit => 150
    t.integer  "rubro_id"
    t.integer  "status"
    t.integer  "clase_produto"
    t.string   "vendedor_nome",      :limit => 150
    t.integer  "vendedor_id"
    t.integer  "cheque_status"
    t.decimal  "valor_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                      :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "analize_amostras", :force => true do |t|
    t.integer  "analize_id"
    t.decimal  "leitura",                    :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "diluicao",                   :precision => 15, :scale => 4, :default => 0.0
    t.string   "profundidade", :limit => 90
    t.string   "lote",         :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "an_macro",     :limit => 2
    t.integer  "an_micro",     :limit => 2
    t.integer  "an_boro",      :limit => 2
    t.integer  "an_enxofre",   :limit => 2
    t.integer  "an_ph_h20",    :limit => 2
    t.integer  "an_p_rem",     :limit => 2
    t.integer  "an_sodio",     :limit => 2
    t.integer  "an_completa",  :limit => 2
    t.integer  "status",       :limit => 2
    t.integer  "entrega",      :limit => 2
    t.integer  "an_fisico",    :limit => 2
    t.integer  "elemento_id"
    t.string   "sequencia_am", :limit => 15
  end

  create_table "analizes", :force => true do |t|
    t.date     "data"
    t.integer  "empresa_id"
    t.string   "empresa_nome",      :limit => 150
    t.integer  "solicitante_id"
    t.string   "solicitante_nome",  :limit => 150
    t.string   "lote",              :limit => 150
    t.integer  "qtd_coletas"
    t.integer  "descricao_analize"
    t.string   "descricao",         :limit => 350
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "an_micro",          :limit => 2
    t.integer  "an_boro",           :limit => 2
    t.integer  "an_enxofre",        :limit => 2
    t.integer  "an_ph_h20",         :limit => 2
    t.integer  "an_p_rem",          :limit => 2
    t.integer  "an_sodio",          :limit => 2
    t.integer  "an_completa",       :limit => 2
    t.integer  "status",            :limit => 2
    t.integer  "entrega",           :limit => 2
    t.integer  "an_macro",          :limit => 2
    t.integer  "an_fisico",         :limit => 2
    t.string   "local_coleta",      :limit => 120
  end

  create_table "bicos", :force => true do |t|
    t.string   "nome",       :limit => 25
    t.decimal  "vazao"
    t.string   "codigo_tec", :limit => 15
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "bombas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "deposito_id"
    t.string   "deposito_nome",   :limit => 200
    t.string   "nome",            :limit => 200
  end

  create_table "cheque_diferidos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "original"
    t.integer  "tabela_id"
    t.integer  "moeda"
    t.integer  "status"
    t.string   "tabela",          :limit => 150
    t.string   "concepto",        :limit => 150
    t.integer  "persona_id"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 150
    t.string   "persona_nome",    :limit => 150
    t.string   "cheque",          :limit => 50
    t.decimal  "entrada_dolar",                  :precision => 15, :scale => 2
    t.decimal  "entrada_guarani",                :precision => 15, :scale => 2
    t.decimal  "saida_dolar",                    :precision => 15, :scale => 2
    t.decimal  "saida_guarani",                  :precision => 15, :scale => 2
    t.date     "depositado"
    t.string   "banco",           :limit => 180
    t.string   "titular",         :limit => 150
    t.integer  "estado"
  end

  create_table "cidades", :force => true do |t|
    t.string   "nome"
    t.integer  "estado_id"
    t.string   "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "paise_id"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "clases", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao",       :limit => 100
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cod_impl"
  end

  create_table "clientes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 200
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "venda_id"
    t.string   "documento_nome",      :limit => 100
    t.string   "documento_numero",    :limit => 100
    t.integer  "cota",                                                              :default => 0
    t.date     "data"
    t.date     "original"
    t.decimal  "divida_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.date     "recebido"
    t.decimal  "cobro_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 150
    t.date     "diferido"
    t.string   "tipo",                :limit => 20
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "cobro_id"
    t.integer  "estado"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "numero_ordem"
    t.integer  "documento_id"
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "pagare"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "local_pago",          :limit => 1
    t.integer  "cod_proc"
    t.string   "sigla_proc",          :limit => 3
    t.decimal  "divida_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.string   "descricao",           :limit => 150
    t.decimal  "desconto_real",                      :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "saca",                :limit => 2
    t.string   "saca_prod",           :limit => 150
    t.decimal  "saca_preco_us",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_preco_gs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_preco_rs",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saca_qtd",                           :precision => 15, :scale => 2, :default => 0.0
  end

  add_index "clientes", ["persona_id", "liquidacao", "tipo"], :name => "cliente_id"

  create_table "cobrancas", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                         :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",     :limit => 150
    t.string   "persona_ruc",      :limit => 50
    t.string   "persona_telefone", :limit => 50
    t.integer  "moeda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cobro_nc_fts", :force => true do |t|
    t.date     "data"
    t.integer  "cobro_id"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 200
    t.string   "fatura_01",       :limit => 4
    t.string   "fatura_02",       :limit => 4
    t.string   "fatura",          :limit => 10
    t.decimal  "fatura_valor_us",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "fatura_valor_gs",                :precision => 15, :scale => 2, :default => 0.0
    t.string   "nota_01",         :limit => 4
    t.string   "nota_02",         :limit => 4
    t.string   "nota",            :limit => 10
    t.decimal  "nota_valor_us",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "nota_valor_gs",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "nota_moeda"
    t.integer  "fatura_moeda"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cobros", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 100
    t.string   "documento_nome",      :limit => 150
    t.integer  "documento_id"
    t.string   "descricao"
    t.integer  "persona_cod"
    t.integer  "adelanto_id"
    t.integer  "adelanto",                                                          :default => 0
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "documento_numero",    :limit => 100
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 0, :default => 0
  end

  create_table "cobros_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "cobro_id"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 150
    t.integer  "cota"
    t.date     "data"
    t.decimal  "cobro_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cobro_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "estado"
    t.integer  "venda_id"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.integer  "moeda"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "pagare"
    t.integer  "interes",             :limit => 2,                                  :default => 0
    t.decimal  "cobro_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "anterior_real",                      :precision => 15, :scale => 0, :default => 0
    t.decimal  "saldo_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "valor_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                       :precision => 15, :scale => 0, :default => 0
    t.decimal  "desconto_real",                      :precision => 15, :scale => 0, :default => 0
    t.date     "data_lanz"
  end

  create_table "cobros_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "conta_id"
    t.string   "conta_nome",           :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",         :limit => 200
    t.string   "descricao",            :limit => 200
    t.date     "data"
    t.decimal  "valor_dolar",                         :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                       :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",       :limit => 150
    t.string   "documento_numero",     :limit => 50
    t.string   "cheque",               :limit => 50
    t.date     "diferido"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cobro_id"
    t.integer  "moeda"
    t.string   "titular",              :limit => 150
    t.string   "banco",                :limit => 180
    t.string   "numero_recibo",        :limit => 50
    t.decimal  "valor_cheque_dolar",                  :precision => 15, :scale => 2
    t.decimal  "valor_cheque_guarani",                :precision => 15, :scale => 2
    t.decimal  "vuelto_dolar",                        :precision => 15, :scale => 2
    t.decimal  "vuelto_guarani",                      :precision => 15, :scale => 2
    t.string   "conta_vuelto_nome",    :limit => 150
    t.integer  "conta_vuelto_id"
    t.string   "cheque_vuelto",        :limit => 50
    t.date     "diferido_vuelto"
    t.decimal  "retencion_dolar",                     :precision => 15, :scale => 2
    t.decimal  "retencion_guarani",                   :precision => 15, :scale => 2
    t.decimal  "valor_vuelto_guarani",                :precision => 15, :scale => 2
    t.decimal  "valor_vuelto_dolar",                  :precision => 15, :scale => 2
    t.string   "documento_numero_02",  :limit => 50
    t.string   "documento_numero_01",  :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",        :limit => 150
    t.integer  "vuelto_cheque_status"
    t.decimal  "cheque_valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cheque_status"
    t.integer  "vuelto"
    t.integer  "vuelto_conta_id"
    t.string   "vuelto_conta_nome",    :limit => 150
    t.string   "vuelto_cheque",        :limit => 100
    t.date     "vuelto_diferido"
    t.decimal  "vuelto_valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vuelto_valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                          :precision => 15, :scale => 0, :default => 0
    t.decimal  "vuelto_valor_real",                   :precision => 15, :scale => 0, :default => 0
    t.decimal  "cheque_valor_real",                   :precision => 15, :scale => 0, :default => 0
  end

  create_table "compras", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",             :limit => 200
    t.integer  "tipo"
    t.decimal  "cotacao",                                 :precision => 15, :scale => 2
    t.integer  "tipo_compra"
    t.integer  "moeda"
    t.decimal  "frete_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "numero_envoce",            :limit => 50
    t.decimal  "iva_total_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_total_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_imponible",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "despachante_id"
    t.string   "despachante_nome",         :limit => 200
    t.string   "persona_ruc",              :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",           :limit => 200
    t.string   "documento_numero",         :limit => 100
    t.string   "documento_numero_01",      :limit => 5
    t.string   "documento_numero_02",      :limit => 5
    t.string   "documento_timbrado",       :limit => 100
    t.integer  "conta_id"
    t.string   "conta_nome",               :limit => 200
    t.string   "cheque",                   :limit => 100
    t.decimal  "total_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_dolar_01",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_01",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_01"
    t.decimal  "cota_dolar_02",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_02",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_02"
    t.decimal  "cota_dolar_03",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_03",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_dolar_04",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_04",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_04"
    t.decimal  "cota_dolar_05",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_05"
    t.decimal  "cota_dolar_06",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cota_guarani_06",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_cota_06"
    t.date     "data_cota_03"
    t.decimal  "gravadas_10_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "diferido"
    t.integer  "cota_dolar",                                                             :default => 0
    t.integer  "cota_guarani",                                                           :default => 0
    t.integer  "entrega_dolar",                                                          :default => 0
    t.integer  "entrega_guarani",                                                        :default => 0
    t.integer  "plano_de_conta_id"
    t.integer  "plano_de_conta_descricao"
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.string   "rubro_cod_contabil"
    t.string   "descricao"
    t.integer  "sueldo_id"
    t.integer  "adcionais"
    t.integer  "empregado_id"
    t.string   "empregado_nome",           :limit => 150
    t.integer  "tabela_id"
    t.string   "tabela",                   :limit => 150
    t.integer  "clase_produto",                                                          :default => 0
    t.integer  "rodado_id"
    t.string   "rodado_nome",              :limit => 150
    t.integer  "tipo_gasto"
    t.integer  "status"
    t.string   "ob_ref",                   :limit => 10
    t.decimal  "cotacao_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_real",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.date     "data_financa"
  end

  add_index "compras", ["data", "tipo_compra"], :name => "compras_data_tipo_compra_idx"

  create_table "compras_custos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compra_id"
    t.integer  "documento_id"
    t.string   "documento_nome",         :limit => 200
    t.string   "documento_numero",       :limit => 100
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 200
    t.integer  "moeda"
    t.date     "data"
    t.decimal  "cotacao",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.integer  "deposito_id"
    t.decimal  "quantidade",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "porcentagem",                           :precision => 15, :scale => 6
    t.decimal  "custo_contabil_dolar",                  :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "custo_contabil_guarani",                :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "custo_produto_dolar",                   :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "custo_produto_guarani",                 :precision => 15, :scale => 6, :default => 0.0
    t.string   "produto_nome",           :limit => 200
    t.decimal  "total_contabil_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_contabil_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_produto_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_produto_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                    :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "compras_documentos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "compra_id"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "persona_ruc",         :limit => 200
    t.string   "persona_timbrado",    :limit => 200
    t.date     "data"
    t.integer  "moeda_id"
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "contabilidade_id"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "tipo"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "tipo_documento",      :limit => 50
    t.integer  "moeda"
    t.string   "documento_numero_01", :limit => 5,                                  :default => "1"
    t.string   "documento_numero_02", :limit => 5,                                  :default => "1"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => nil
    t.string   "cheque",              :limit => 100
    t.string   "tabela",              :limit => 200
    t.integer  "tabela_id"
    t.integer  "tipo_compra"
    t.integer  "clase_produto"
    t.integer  "rubro_id"
    t.string   "rubro_nome",          :limit => 150
  end

  create_table "compras_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "compra_id"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "persona_ruc",         :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 200
    t.string   "documento_numero",    :limit => 100
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.date     "vencimento"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.integer  "cota"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "tabela",              :limit => 200
    t.integer  "tabela_id"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "entrega_dolar"
    t.integer  "entrega_guarani"
    t.date     "diferido"
    t.string   "descricao"
    t.integer  "clase_produto"
    t.integer  "tipo_compra"
    t.integer  "cod_viatico"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                         :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "compras_gastos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "compra_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "tipo"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "tipo_compra"
    t.integer  "moeda"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.string   "rubro_cod_contabil"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "clase_produto"
  end

  create_table "compras_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "produto_id"
    t.integer  "compra_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "unitario_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_taxa",                                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",             :limit => 200
    t.decimal  "frete_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "cotacao"
    t.string   "fabricante_cod",            :limit => 50
    t.string   "codigo",                    :limit => 50
    t.integer  "moeda"
    t.decimal  "despacho_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcentagem_produto",                      :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "iva_total_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_total_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar_iva",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani_iva",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.decimal  "quantidade",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "seguro_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "seguro_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_despacho_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcentagem",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_compra"
    t.integer  "persona_id"
    t.string   "persona_nome",              :limit => 200
    t.integer  "porcen_minorista",                                                        :default => 0
    t.integer  "porcen_maiorista",                                                        :default => 0
    t.integer  "porcen_balcao",                                                           :default => 0
    t.integer  "clase_produto"
    t.decimal  "preco_maiorista_dolar",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "porc_maiorista",                           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_maiorista_guarani",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "porc_minorista",                           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_minorista_dolar",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "preco_minorista_guarani",                  :precision => 15, :scale => 3, :default => 0.0
    t.integer  "status"
    t.decimal  "custo_dolar",                              :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                            :precision => 15, :scale => 2
    t.decimal  "cotacao_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ultimo_custo_us",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "ultimo_custo_gs",                          :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "ultimo_custo_rs",                          :precision => 15, :scale => 4, :default => 0.0
  end

  create_table "consumicao_interna_produtos", :force => true do |t|
    t.integer  "consumicao_interna_id"
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "taxa",                                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumicao_internas", :force => true do |t|
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.string   "concepto",        :limit => 250
    t.date     "data"
    t.integer  "moeda"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",   :limit => 150
    t.decimal  "total_dolar",                    :precision => 15, :scale => 2
    t.decimal  "total_guarani",                  :precision => 15, :scale => 2
  end

  create_table "conta", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "contas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",            :limit => 200
    t.string   "numero",          :limit => 100
    t.string   "direcao",         :limit => 200
    t.integer  "unidade_id"
    t.integer  "tipo"
    t.string   "encarregado",     :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade",          :limit => 200
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "cod_contabil",    :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome"
  end

  create_table "controle_pulv_maqs", :force => true do |t|
    t.integer  "controle_pulv_id"
    t.date     "data"
    t.string   "modelo",           :limit => 100
    t.integer  "hora_maq",                        :default => 0
    t.string   "bico_01",          :limit => 100
    t.string   "bico_02",          :limit => 100
    t.integer  "vazao_01",                        :default => 0
    t.integer  "vazao_02",                        :default => 0
    t.string   "autonomia_01",     :limit => 100
    t.string   "autonomia_02",     :limit => 100
    t.integer  "velocidade_01",                   :default => 0
    t.integer  "velocidade_02",                   :default => 0
    t.integer  "etiqueta"
    t.integer  "calibracao"
    t.integer  "regular"
    t.integer  "condicao_maq"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "controle_pulvs", :force => true do |t|
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_name", :limit => 150
    t.decimal  "area",                        :precision => 15, :scale => 3, :default => 0.0
    t.string   "direcao",      :limit => 120
    t.datetime "created_at",                                                                  :null => false
    t.datetime "updated_at",                                                                  :null => false
  end

  create_table "depositos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",            :limit => 200
    t.integer  "unidade_id"
    t.string   "bairro",          :limit => 200
    t.string   "complemento",     :limit => 300
    t.integer  "cidade_id"
    t.string   "direcao",         :limit => 200
    t.string   "cidade",          :limit => 200
  end

  create_table "diario_debes", :force => true do |t|
    t.integer  "diario_id"
    t.date     "data"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",    :limit => 250
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",     :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "contabilidade",   :limit => 50
    t.string   "descricao",       :limit => 150
    t.integer  "rubro_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "status"
  end

  add_index "diario_debes", ["diario_id", "contabilidade", "valor_dolar"], :name => "busca_dd"

  create_table "diario_habers", :force => true do |t|
    t.integer  "diario_id"
    t.date     "data"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",    :limit => 250
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",     :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "contabilidade",   :limit => 50
    t.string   "descricao",       :limit => 150
    t.integer  "rubro_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "status"
  end

  add_index "diario_habers", ["diario_id", "contabilidade", "valor_dolar"], :name => "diario_dh"

  create_table "diarios", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "numero"
    t.decimal  "debito_dolar",                       :precision => 15, :scale => 2
    t.decimal  "credito_dolar",                      :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tabela_id"
    t.string   "tabela_nome",         :limit => 150
    t.decimal  "credito_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "descricao",           :limit => 200
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "documento_numero",    :limit => 150
    t.integer  "status"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "sigla",               :limit => 10
    t.integer  "moeda"
  end

  add_index "diarios", ["tabela_id", "tabela_nome", "data"], :name => "busca_id"

  create_table "documentos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",            :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "sigla",           :limit => 10
  end

  create_table "egressos", :force => true do |t|
    t.date     "data"
    t.date     "diferido"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 100
    t.integer  "documento_id"
    t.string   "documento_nome",  :limit => 150
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "rubro_id"
    t.string   "rubro_nome",      :limit => 150
    t.string   "rubro_codigo",    :limit => 50
    t.string   "concepto",        :limit => 200
    t.string   "cheque",          :limit => 50
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_real",                     :precision => 15, :scale => 0, :default => 0
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 0, :default => 0
  end

  create_table "elementos", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla",      :limit => 20
    t.string   "formula",    :limit => 50
    t.decimal  "fator",                     :precision => 15, :scale => 4, :default => 0.0
    t.decimal  "decimal",                   :precision => 15, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empresas", :force => true do |t|
    t.integer  "base_calc_preco_venda"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "taxa_interes",                         :precision => 15, :scale => 2, :default => 0.0
    t.boolean  "modulo_laboratorio"
    t.boolean  "modulo_producao"
    t.boolean  "modulo_granos"
    t.integer  "venda_persona_id"
    t.string   "venda_persona_nome",    :limit => 150
    t.string   "venda_persona_ruc",     :limit => 20
    t.integer  "venda_moeda"
    t.string   "nome",                  :limit => 150
    t.string   "direcao",               :limit => 100
    t.string   "ruc",                   :limit => 20
  end

  create_table "entrada_saida_func_detalhes", :force => true do |t|
    t.integer  "entrada_sainda_func_id"
    t.date     "data"
    t.integer  "ob_ref"
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 100
    t.string   "descricao",              :limit => 150
    t.integer  "status"
    t.string   "servico",                :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome",       :limit => 150
    t.string   "persona_doc",            :limit => 50
  end

  create_table "entrada_saida_funcs", :force => true do |t|
    t.date     "data"
    t.integer  "ob_ref"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 100
    t.string   "descricao",        :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 150
  end

  create_table "estados", :force => true do |t|
    t.string   "nome"
    t.integer  "paise_id"
    t.string   "pais"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "etiquetas", :force => true do |t|
    t.string   "especie",     :limit => 30
    t.string   "variedade",   :limit => 30
    t.string   "lote",        :limit => 10
    t.string   "categoria",   :limit => 30
    t.string   "origem",      :limit => 10
    t.string   "zaranda",     :limit => 10
    t.string   "germ_min",    :limit => 5
    t.string   "pureza_min",  :limit => 5
    t.date     "validez"
    t.string   "peso_neto",   :limit => 15
    t.string   "ing_respons", :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "faturas", :force => true do |t|
    t.date     "data"
    t.integer  "status"
    t.integer  "moeda"
    t.integer  "tipo"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 250
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 20
    t.decimal  "cotacao",                            :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas_dolar",                      :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas_guarani",                    :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_05_dolar",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_05_guarani",                :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "gravadas_10_dolar",                  :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "gravadas_10_guarani",                :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ruc",                 :limit => 50
  end

  create_table "fechamento_caixas", :force => true do |t|
    t.integer  "conta_id"
    t.string   "conta_nome",                   :limit => 150
    t.integer  "usuario_id"
    t.string   "usuario_nome",                 :limit => 150
    t.date     "data"
    t.integer  "status"
    t.decimal  "cotacao",                                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "obs",                          :limit => 250
    t.string   "contato01",                    :limit => 150
    t.string   "contato02",                    :limit => 150
    t.string   "contato03",                    :limit => 150
    t.string   "contato04",                    :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "entrada_efetivo_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_efetivo_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dia_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dia_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "qtd_entrada_cheq_dia_dolar"
    t.integer  "qtd_entrada_cheq_dia_guarani"
    t.integer  "qtd_entrada_cheq_dif_dolar"
    t.integer  "qtd_entrada_cheq_dif_guarani"
    t.decimal  "entrada_cheq_dif_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrada_cheq_dif_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_efetivo_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_efetivo_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dia_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dia_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "qtd_saida_cheq_dia_dolar"
    t.integer  "qtd_saida_cheq_dia_guarani"
    t.integer  "qtd_saida_cheq_dif_dolar"
    t.integer  "qtd_saida_cheq_dif_guarani"
    t.decimal  "saida_cheq_dif_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_cheq_dif_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_viatico_id"
    t.string   "conta_viatico_nome"
  end

  create_table "fechamento_turnos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.decimal  "inicio",                         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "final",                          :precision => 15, :scale => 3, :default => 0.0
    t.string   "turno_nome",      :limit => 150
    t.integer  "bomba_id"
    t.string   "bomba_nome",      :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",   :limit => 150
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "turno_id"
  end

  create_table "financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",              :limit => 150
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.date     "data"
    t.decimal  "entrada_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "compra_id"
    t.date     "vencimento"
    t.string   "cheque",              :limit => 100
    t.decimal  "entrada_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.string   "documento_nome",      :limit => 100
    t.string   "documento_numero",    :limit => 100
    t.integer  "tipo"
    t.date     "diferido"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "documento_id"
    t.integer  "estado"
    t.string   "concepto"
    t.integer  "moeda"
    t.date     "original"
    t.integer  "status"
    t.string   "titular",             :limit => 150
    t.string   "banco",               :limit => 180
    t.integer  "cheque_status",                                                     :default => 0
    t.date     "depositado"
    t.integer  "cod_processo"
    t.string   "ob_ref"
  end

  create_table "forms", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "form_venda_fatura",   :limit => 100
    t.string   "rl_comissao",         :limit => 100
    t.string   "consulta_stock",      :limit => 150
    t.string   "recibo_cobro",        :limit => 50
    t.string   "recibo_adelanto",     :limit => 50
    t.string   "form_venda_cliente",  :limit => 30
    t.string   "form_ingressos",      :limit => 50
    t.string   "form_compras",        :limit => 100
    t.string   "form_gastos",         :limit => 100
    t.string   "form_venda_produtos"
    t.string   "form_venda_financa"
  end

  create_table "grupos", :force => true do |t|
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "porcen_balcao",   :precision => 15, :scale => 2
    t.decimal  "porcen_mayo",     :precision => 15, :scale => 2
    t.decimal  "porcen_mino",     :precision => 15, :scale => 2
    t.integer  "cod_impl"
  end

  create_table "ingressos", :force => true do |t|
    t.date     "data"
    t.integer  "conta_id"
    t.string   "conta_nome",      :limit => 100
    t.integer  "rubro_id"
    t.string   "rubro_nome",      :limit => 150
    t.string   "rubro_codigo",    :limit => 50
    t.string   "concepto",        :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "documento_id"
    t.string   "documento_nome",  :limit => 150
    t.date     "diferido"
    t.string   "cheque",          :limit => 50
    t.integer  "cheque_status"
    t.string   "titular",         :limit => 150
    t.string   "banco",           :limit => 150
    t.decimal  "cotacao_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                     :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "localidades", :force => true do |t|
    t.string   "codigo",     :limit => 50
    t.string   "ocupacao",   :limit => 120
    t.integer  "status"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "localizacaos", :force => true do |t|
    t.string   "ocupacao"
    t.string   "sigla"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "logins", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "unidade_nome"
    t.integer  "usuario_id"
    t.string   "usuario_nome"
    t.string   "usuario_senha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.string   "conta_nome",    :limit => 200
    t.integer  "conta_id"
    t.string   "turno_nome",    :limit => 250
    t.integer  "turno_id"
    t.date     "vencimento"
    t.integer  "status"
    t.string   "senha",         :limit => 100
    t.string   "liberacao",     :limit => 100
  end

  create_table "manifestacao_de_bens", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "persona_id"
    t.string   "persona_nome",     :limit => 200
    t.string   "tipo",             :limit => 50
    t.string   "caracteristicas",  :limit => 100
    t.decimal  "valor_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.string   "escrivania",       :limit => 100
    t.string   "escritura",        :limit => 50
    t.string   "numero",           :limit => 50
    t.integer  "hipotecado"
    t.string   "favorecido",       :limit => 100
    t.integer  "rango"
    t.decimal  "hipoteca_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "hipoteca_guarani",                :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "manutencao_maquina_produtos", :force => true do |t|
    t.integer  "manutencao_maquina_id"
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome",      :limit => 200
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",         :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 150
  end

  create_table "manutencao_maquinas", :force => true do |t|
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.string   "produto_nome",          :limit => 200
    t.decimal  "quantidade",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_balcao",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_mayorista",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_corporativo",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.date     "data"
    t.date     "data_finalizacao"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",         :limit => 150
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",         :limit => 150
    t.decimal  "custo_maquina_dolar",                  :precision => 15, :scale => 2
    t.decimal  "custo_maquina_guarani",                :precision => 15, :scale => 2
  end

  create_table "menus", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meta", :force => true do |t|
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.integer  "moeda"
    t.decimal  "valor_min_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.text     "descricao"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "meta_detalhes", :force => true do |t|
    t.integer  "meta_id"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "setor_id"
    t.string   "setor_nome"
    t.decimal  "valor_min_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_us", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_gs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_rs", :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao_min",  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao_max",  :precision => 15, :scale => 2, :default => 0.0
    t.text     "descricao"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "metas", :force => true do |t|
    t.date     "periodo_inicio"
    t.date     "periodo_final"
    t.integer  "moeda"
    t.decimal  "valor_min_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_min_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_us",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_gs",   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_max_rs",   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.text     "descricao"
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  create_table "moedas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.decimal  "dolar_compra",           :precision => 15, :scale => 2
    t.decimal  "dolar_venda",            :precision => 15, :scale => 2
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.decimal  "cotacao_oficial_compra", :precision => 15, :scale => 2
    t.decimal  "cotacao_oficial_venda",  :precision => 15, :scale => 2
    t.decimal  "real_compra"
    t.decimal  "real_venda"
  end

  create_table "nc_proveedor_faturas", :force => true do |t|
    t.integer  "nota_credito_proveedor_id"
    t.integer  "persona_id"
    t.integer  "compra_id"
    t.string   "persona_nome"
    t.string   "documento_numero_01",       :limit => 5
    t.string   "documento_numero_02",       :limit => 5
    t.string   "documento_numero",          :limit => 20
    t.integer  "operacao"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_dolar",                             :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                           :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.integer  "tipo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "nota_credito_proveedor_aplics", :force => true do |t|
    t.integer  "nota_credito_proveedor_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",              :limit => 150
    t.string   "documento_numero_01",       :limit => 10
    t.string   "documento_numero_02",       :limit => 10
    t.string   "documento_numero",          :limit => 30
    t.string   "cota",                      :limit => 5
    t.decimal  "valor_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_real",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.integer  "tipo"
    t.integer  "liquidacao"
    t.integer  "vencimento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nota_credito_proveedor_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "nota_credito_proveedor_id"
    t.integer  "produto_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "quantidade",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",             :limit => 100
    t.string   "documento_nome",            :limit => 150
    t.string   "documento_numero",          :limit => 100
    t.string   "documento_numero_01",       :limit => 5
    t.string   "documento_numero_02",       :limit => 5
    t.string   "codigo",                    :limit => 150
    t.decimal  "iva_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "taxa",                                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                                  :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.integer  "clase_produto"
    t.integer  "compra_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
  end

  create_table "nota_credito_proveedors", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "ruc",                 :limit => 100
    t.string   "direcao",             :limit => 150
    t.string   "cidade",              :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor",            :limit => 200
    t.integer  "tipo"
    t.integer  "moeda"
    t.string   "concepto",            :limit => 100
    t.integer  "operacao"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "cidade_id"
    t.integer  "clase_produto"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nota_creditos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "ruc",                 :limit => 100
    t.string   "direcao",             :limit => 150
    t.string   "cidade",              :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor",            :limit => 200
    t.integer  "tipo"
    t.integer  "moeda"
    t.string   "concepto",            :limit => 100
    t.integer  "operacao"
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 200
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "cidade_id"
    t.integer  "clase_produto"
    t.integer  "status"
    t.string   "fatura_01",           :limit => 5
    t.string   "fatura_02",           :limit => 5
    t.string   "fatura",              :limit => 50
    t.decimal  "exenta_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exenta_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "cota"
    t.integer  "taxa"
    t.integer  "financa_moeda"
  end

  create_table "nota_creditos_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "nota_credito_id"
    t.integer  "produto_id"
    t.string   "produto_nome",        :limit => 200
    t.decimal  "quantidade",                         :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",       :limit => 100
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "codigo",              :limit => 150
    t.string   "fabricante_cod",      :limit => 150
    t.decimal  "iva_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "taxa",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "venda_id"
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",       :limit => 150
    t.integer  "tipo"
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 150
    t.integer  "documento_id"
    t.string   "cota",                :limit => 5
  end

  create_table "nota_creditos_docs", :force => true do |t|
    t.integer  "nota_credito_id"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.integer  "moeda"
    t.integer  "status"
    t.integer  "cota"
    t.string   "persona_nome",        :limit => 150
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 15
    t.string   "tipo",                :limit => 2
    t.integer  "liquidacao"
    t.integer  "vendedor_id"
    t.decimal  "valor_dolar"
    t.decimal  "valor_guarani"
    t.string   "vendedor_nome",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_produto"
  end

  create_table "nota_remicao_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nota_remicao_id"
    t.date     "data"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",           :limit => 200
    t.integer  "produto_cod"
    t.integer  "deposito_id"
    t.string   "deposito_nome",          :limit => 150
    t.decimal  "custo_dolar",                           :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                         :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                           :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                         :precision => 15, :scale => 2
    t.decimal  "saldo",                                 :precision => 15, :scale => 3
    t.decimal  "quantidade",                            :precision => 15, :scale => 3
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.decimal  "custo_contabil_dolar",                  :precision => 15, :scale => 2
    t.decimal  "custo_contabil_guarani",                :precision => 15, :scale => 2
    t.string   "persona_nome",           :limit => 200
    t.integer  "persona_id"
  end

  create_table "nota_remicaos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.string   "documento_numero_01",  :limit => 10
    t.string   "documento_numero_02",  :limit => 10
    t.string   "documento_numero",     :limit => 50
    t.integer  "origem_unidade_id"
    t.string   "origem_unidade_nome",  :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",        :limit => 150
    t.integer  "motivo"
    t.string   "chapa",                :limit => 50
    t.integer  "chofer_id"
    t.string   "chofer_nome",          :limit => 150
    t.string   "chofer_ruc",           :limit => 50
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",  :limit => 150
    t.integer  "destino_unidade_id"
    t.string   "destino_unidade_nome", :limit => 150
    t.integer  "destino_persona_id"
    t.integer  "destino_persona_cod"
    t.string   "destino_persona_nome", :limit => 150
    t.string   "destino_persona_ruc",  :limit => 150
    t.string   "direcao",              :limit => 150
    t.string   "bairro",               :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",          :limit => 150
    t.string   "veiculo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
  end

  create_table "ordem_producaos", :force => true do |t|
    t.date     "data"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 200
    t.decimal  "quantidade",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.text     "obs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pagares", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "unidade_id"
    t.string   "unidade_nome",    :limit => 150
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                        :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",    :limit => 150
    t.string   "persona_ruc",     :limit => 50
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",   :limit => 150
    t.date     "vencimento"
    t.decimal  "valor_dolar",                    :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                  :precision => 15, :scale => 2
    t.integer  "venda_id"
    t.string   "tabela",          :limit => 150
    t.integer  "tabela_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.integer  "cota"
    t.string   "co_deodor"
    t.string   "co_deodor_ruc"
    t.string   "domicilio",       :limit => 150
    t.string   "m_tipo",          :limit => 150
    t.string   "marca",           :limit => 150
    t.string   "modelo",          :limit => 150
    t.string   "ano",             :limit => 150
    t.string   "chassi",          :limit => 150
    t.string   "motor",           :limit => 150
    t.string   "seria",           :limit => 150
    t.string   "obs",             :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",     :limit => 150
    t.integer  "estado_id"
    t.string   "estado_nome",     :limit => 150
    t.integer  "pais_id"
    t.string   "pais_nome",       :limit => 150
    t.string   "nacionalidade",   :limit => 50
    t.decimal  "entrega_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "entrega_guarani",                :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "pagares_detalhes", :force => true do |t|
    t.integer  "pagare_id"
    t.date     "data"
    t.date     "vencimento"
    t.integer  "cota"
    t.decimal  "valor_guarani", :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_dolar",   :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "pagos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.string   "cheque",              :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 100
    t.integer  "compra_id"
    t.string   "documento_nome",      :limit => 150
    t.integer  "documento_id"
    t.string   "descricao"
    t.integer  "clase_produto"
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "documento_numero",    :limit => 100
    t.integer  "adelanto"
    t.integer  "adelanto_id"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 0, :default => 0
  end

  create_table "pagos_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "pago_id"
    t.date     "vencimento"
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 150
    t.integer  "cota"
    t.date     "data"
    t.decimal  "pago_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.decimal  "anterior_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "anterior_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saldo_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "estado"
    t.integer  "compra_id"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                      :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                    :precision => 15, :scale => 2
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.decimal  "pago_real",                          :precision => 15, :scale => 0, :default => 0
    t.decimal  "anterior_real",                      :precision => 15, :scale => 0, :default => 0
    t.decimal  "saldo_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "valor_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                       :precision => 15, :scale => 0, :default => 0
    t.decimal  "desconto_real",                      :precision => 15, :scale => 0, :default => 0
  end

  create_table "pagos_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pago_id"
    t.integer  "conta_id"
    t.string   "conta_nome",          :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",        :limit => 200
    t.string   "descricao",           :limit => 200
    t.date     "data"
    t.decimal  "valor_dolar",                        :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                      :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 150
    t.string   "documento_numero",    :limit => 50
    t.string   "cheque",              :limit => 50
    t.date     "diferido"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "moeda"
    t.integer  "usuario_updated"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.string   "documento_numero_02", :limit => 50
    t.string   "documento_numero_01", :limit => 50
    t.string   "numero_recibo",       :limit => 50
    t.integer  "cod_viatico"
    t.decimal  "valor_real",                         :precision => 15, :scale => 0, :default => 0
  end

  create_table "paises", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "pedido_compra_produtos", :force => true do |t|
    t.integer  "pedido_compra_id"
    t.date     "data"
    t.integer  "moeda"
    t.decimal  "cotacao",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_produto"
    t.integer  "produto_id"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.string   "produto_nome"
    t.string   "produto_fabricante_cod"
    t.decimal  "quantidade",             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_dolar",         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",          :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome"
    t.integer  "unidade_created"
    t.integer  "usuario_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pedido_compras", :force => true do |t|
    t.date     "data"
    t.date     "data_entrega"
    t.decimal  "cotacao",         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "moeda"
    t.integer  "status"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "requerente_id"
    t.string   "requerente_nome"
    t.integer  "clase_produto"
    t.integer  "documento_id"
    t.string   "documento_nome"
    t.integer  "unidade_id"
    t.string   "unidade_nome"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "descricao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "personas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",                  :limit => 300
    t.string   "direcao",               :limit => 300
    t.string   "bairro",                :limit => 300
    t.string   "cidade",                :limit => 200
    t.string   "telefone",              :limit => 50
    t.date     "data"
    t.string   "direcao_complemento",   :limit => 400
    t.string   "ruc",                   :limit => 20
    t.integer  "tipo_fornecedor",                                                     :default => 0
    t.integer  "tipo_cliente",                                                        :default => 0
    t.integer  "tipo_vendedor",                                                       :default => 0
    t.integer  "tipo_funcionario",                                                    :default => 0
    t.integer  "estado",                                                              :default => 0
    t.integer  "tipo",                                                                :default => 0
    t.integer  "tipo_fabricante",                                                     :default => 0
    t.integer  "cidade_id"
    t.string   "classificacao",         :limit => 10
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "chapa",                 :limit => 20
    t.integer  "tipo_transportadora"
    t.string   "departamento",          :limit => 150
    t.date     "data_entrada"
    t.decimal  "salario",                              :precision => 15, :scale => 2
    t.decimal  "salario_minimo",                       :precision => 15, :scale => 2
    t.decimal  "comissao",                             :precision => 15, :scale => 2
    t.decimal  "ci",                                   :precision => 15, :scale => 2
    t.string   "cod_contabil"
    t.decimal  "ips",                                  :precision => 15, :scale => 2
    t.date     "data_nascimento"
    t.string   "email",                 :limit => 100
    t.string   "estado_civil",          :limit => 100
    t.string   "lugar_trabalho",        :limit => 150
    t.string   "cargo",                 :limit => 100
    t.string   "profisao",              :limit => 100
    t.string   "referencia1",           :limit => 100
    t.string   "referenciatel1",        :limit => 100
    t.string   "referencia2",           :limit => 100
    t.string   "referenciatel2",        :limit => 100
    t.string   "referencia3",           :limit => 100
    t.string   "referenciatel3",        :limit => 100
    t.decimal  "limite_credito",                       :precision => 15, :scale => 2
    t.string   "observacao"
    t.integer  "cod_velho"
    t.integer  "tipo_maiorista"
    t.integer  "tipo_chofer"
    t.integer  "tipo_despachante"
    t.string   "nacionalidade"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "residencia_numero",     :limit => 10
    t.string   "telefone2",             :limit => 20
    t.string   "fax",                   :limit => 20
    t.string   "celular",               :limit => 20
    t.string   "banco",                 :limit => 100
    t.string   "conta_numero",          :limit => 50
    t.string   "oficial_conta",         :limit => 100
    t.string   "conta",                 :limit => 100
    t.integer  "tipo_intermediario"
    t.date     "antiguidade"
    t.string   "referencia4",           :limit => 100
    t.string   "referencia_ci1",        :limit => 100
    t.string   "referencia_ci2",        :limit => 100
    t.string   "referencia_ci3",        :limit => 100
    t.string   "referencia_ci4",        :limit => 100
    t.string   "referencia_cargo1",     :limit => 100
    t.string   "referencia_cargo2",     :limit => 100
    t.string   "referencia_cargo3",     :limit => 100
    t.string   "referencia_cargo4",     :limit => 100
    t.integer  "estado_id"
    t.string   "estado_nome",           :limit => 150
    t.integer  "pais_id"
    t.string   "pais_nome",             :limit => 150
    t.string   "atividade",             :limit => 150
    t.integer  "cliente"
    t.integer  "rubro_id"
    t.string   "rubro_nome",            :limit => 150
    t.integer  "active",                                                              :default => 0, :null => false
    t.string   "setor",                 :limit => 10
    t.integer  "per_inter_exter",       :limit => 2,                                  :default => 0
    t.integer  "tipo_laboratorio"
    t.string   "codeudor_nome",         :limit => 100
    t.string   "codeudor_ruc",          :limit => 15
    t.string   "codeudor_direcion",     :limit => 100
    t.string   "codeudor_lugar_trab",   :limit => 100
    t.string   "codeudor_telefone",     :limit => 20
    t.integer  "vend_responsavel_id"
    t.string   "vend_responsavel_nome", :limit => 150
  end

  add_index "personas", ["nome"], :name => "persona_nome"

  create_table "pesos", :force => true do |t|
    t.decimal  "peso",       :precision => 15, :scale => 3, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pets", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plano_de_contas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "descricao",       :limit => 200
    t.string   "codigo",          :limit => 20
    t.integer  "rubro",           :limit => 2
  end

  create_table "planos", :force => true do |t|
    t.string   "condicao",   :limit => 200
    t.integer  "mes"
    t.integer  "ano"
    t.integer  "status"
    t.integer  "periodo"
    t.decimal  "taxa",                      :precision => 15, :scale => 2
    t.decimal  "decimal",                   :precision => 15, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "presupuesto_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "presupuesto_id"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 200
    t.decimal  "unitario_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.string   "fabricante_cod",   :limit => 100
    t.decimal  "cotacao",                         :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "quantidade",                      :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saldo",                           :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "taxa",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.string   "barra",            :limit => 100
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",     :limit => 200
    t.string   "deposito_nome",    :limit => 150
    t.integer  "deposito_id"
    t.decimal  "desconto",                        :precision => 15, :scale => 2
    t.decimal  "total_desconto",                  :precision => 15, :scale => 2
    t.integer  "produto_cod"
    t.decimal  "interes"
    t.integer  "sub_grupo_id"
    t.integer  "tipo_venda"
    t.integer  "clase_produto"
    t.decimal  "unitario_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_real",                      :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "presupuestos", :id => false, :force => true do |t|
    t.integer "id",                                                                                 :null => false
    t.integer "tipo"
    t.date    "data"
    t.decimal "cotacao",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer "moeda"
    t.string  "ruc",                 :limit => 50
    t.string  "persona_nome",        :limit => 200
    t.string  "telefone",            :limit => 50
    t.integer "persona_id"
    t.integer "usuario_created"
    t.integer "usuario_updated"
    t.string  "direcao",             :limit => 150
    t.string  "bairro",              :limit => 150
    t.integer "cidade_id"
    t.string  "cidade_nome",         :limit => 150
    t.string  "documento_numero",    :limit => 50
    t.string  "documento_numero_01", :limit => 50
    t.string  "documento_numero_02", :limit => 50
    t.integer "documento_id"
    t.integer "fatura"
    t.string  "documento_nome",      :limit => 150
    t.integer "conta_id"
    t.string  "conta_nome",          :limit => 50
    t.decimal "limite_credito",                     :precision => 15, :scale => 2, :default => 0.0
    t.string  "classificacao",       :limit => 50
    t.integer "vendedor_id"
    t.string  "vendedor_nome",       :limit => 50
    t.integer "tipo_maiorista"
    t.integer "persona_cod"
    t.string  "pedido_numero",       :limit => 50
    t.decimal "saldo_disponivel",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer "tipo_venda"
    t.integer "clase_produto"
    t.date    "prazo_entrega"
    t.integer "status"
    t.decimal "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.integer "venda_id"
  end

  create_table "producao_produtos", :force => true do |t|
    t.integer  "producao_id"
    t.decimal  "cotacao",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",     :limit => 200
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 200
    t.decimal  "quantidade",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.date     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_id"
    t.string   "deposito_nome",    :limit => 150
    t.integer  "finalizado"
  end

  create_table "producaos", :force => true do |t|
    t.decimal  "cotacao",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "produto_id"
    t.string   "produto_nome",       :limit => 200
    t.decimal  "quantidade",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_balcao",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_mayorista",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "porcen_corporativo",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "status"
    t.date     "data"
    t.date     "data_finalizacao"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "sub_grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",      :limit => 150
  end

  create_table "produto_barras", :force => true do |t|
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.string   "barra"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "produto_composicaos", :force => true do |t|
    t.integer  "produto_id"
    t.integer  "componente_id"
    t.string   "componente_nome",      :limit => 150
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.decimal  "quantidade",                          :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "ultimo_custo_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ultimo_custo_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",                      :limit => 200
    t.string   "embalagem",                 :limit => 30
    t.string   "referencia",                :limit => 20
    t.string   "barra",                     :limit => 20
    t.string   "fabricante_cod",            :limit => 30
    t.integer  "fabricante_id"
    t.decimal  "taxa",                                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "grupo_id"
    t.integer  "clase_id"
    t.string   "codigo",                    :limit => 20
    t.string   "fabricante",                :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.decimal  "preco_venda_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "cotacao",                                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_dolar_iva",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_produto_guarani_iva",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo",                                                                    :default => 0
    t.decimal  "quantidade",                               :precision => 15, :scale => 2, :default => 0.0
    t.integer  "numero_bomba",                                                            :default => 0
    t.decimal  "porcentagem",                              :precision => 15, :scale => 2, :default => 0.0
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "cod_contabil",              :limit => 50
    t.integer  "stock_minimo"
    t.integer  "stock_maximo"
    t.decimal  "peso",                                     :precision => 15, :scale => 3
    t.integer  "cod_velho"
    t.decimal  "preco_maiorista_dolar",                    :precision => 15, :scale => 2
    t.decimal  "preco_maiorista_guarani",                  :precision => 15, :scale => 2
    t.decimal  "preco_minorista_dolar",                    :precision => 15, :scale => 2
    t.decimal  "preco_minorista_guarani",                  :precision => 15, :scale => 2
    t.integer  "desconto"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "sub_grupo_id"
    t.string   "locacao",                   :limit => 150
    t.decimal  "porcen_balcao",                            :precision => 15, :scale => 2
    t.decimal  "porcen_mayo",                              :precision => 15, :scale => 2
    t.decimal  "porcen_mino",                              :precision => 15, :scale => 2
    t.integer  "tipo_produto"
    t.string   "obs"
    t.decimal  "desconto_maio",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_mino",                            :precision => 15, :scale => 2, :default => 0.0
    t.integer  "montagem"
    t.string   "nome_fatura",               :limit => 100
    t.decimal  "cotacao_real",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_maiorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_minorista_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.integer  "peso_bruto"
  end

  add_index "produtos", ["nome", "fabricante_cod"], :name => "produto_busca"

  create_table "produtos_roteiros", :force => true do |t|
    t.integer  "produto_id"
    t.string   "descricao",        :limit => 50
    t.string   "setor",            :limit => 50
    t.integer  "tempo_estimado"
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proveedores", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "tabela_id"
    t.string   "tabela",               :limit => 200
    t.date     "vencimento"
    t.string   "documento_nome",       :limit => 100
    t.string   "documento_numero",     :limit => 100
    t.integer  "cota",                                                               :default => 0
    t.date     "data"
    t.date     "original"
    t.decimal  "divida_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.date     "pagamento"
    t.decimal  "pago_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.integer  "liquidacao"
    t.string   "persona_nome",         :limit => 200
    t.integer  "persona_id"
    t.integer  "compra_id"
    t.date     "diferido"
    t.integer  "conta_id"
    t.string   "conta_nome",           :limit => 150
    t.string   "cheque",               :limit => 100
    t.integer  "tipo"
    t.integer  "pago_id"
    t.integer  "estado"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.string   "documento_numero_01",  :limit => 5
    t.string   "documento_numero_02",  :limit => 5
    t.decimal  "total_divida_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_divida_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                      :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                    :precision => 15, :scale => 2
    t.decimal  "interes_dolar",                       :precision => 15, :scale => 2
    t.decimal  "interes_guarani",                     :precision => 15, :scale => 2
    t.integer  "moeda"
    t.integer  "clase_produto"
    t.decimal  "cotacao_real",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "divida_real",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "pago_real",                           :precision => 15, :scale => 2, :default => 0.0
    t.string   "descricao",            :limit => 150
    t.decimal  "desconto_real",                       :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                        :precision => 15, :scale => 0, :default => 0
  end

  create_table "proventos", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "descripcion"
    t.string   "cod_contabil"
    t.integer  "estado"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recepcao_nota_remicao_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recepcao_nota_remicao_id"
    t.date     "data"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "produto_id"
    t.string   "produto_nome",             :limit => 200
    t.integer  "produto_cod"
    t.integer  "deposito_id"
    t.string   "deposito_nome",            :limit => 150
    t.decimal  "custo_dolar",                             :precision => 15, :scale => 2
    t.decimal  "custo_guarani",                           :precision => 15, :scale => 2
    t.decimal  "valor_dolar",                             :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                           :precision => 15, :scale => 2
    t.decimal  "saldo",                                   :precision => 15, :scale => 3
    t.decimal  "quantidade",                              :precision => 15, :scale => 3
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "estado"
    t.decimal  "custo_contabil_dolar",                    :precision => 15, :scale => 2
    t.decimal  "custo_contabil_guarani",                  :precision => 15, :scale => 2
    t.string   "persona_nome"
    t.integer  "persona_id"
  end

  create_table "recepcao_nota_remicaos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.string   "documento_numero_01",  :limit => 10
    t.string   "documento_numero_02",  :limit => 10
    t.string   "documento_numero",     :limit => 50
    t.integer  "origem_unidade_id"
    t.string   "origem_unidade_nome",  :limit => 150
    t.integer  "deposito_id"
    t.string   "deposito_nome",        :limit => 150
    t.integer  "motivo"
    t.string   "chapa",                :limit => 50
    t.integer  "chofer_id"
    t.string   "chofer_nome",          :limit => 150
    t.string   "chofer_ruc",           :limit => 50
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",  :limit => 150
    t.integer  "destino_unidade_id"
    t.string   "destino_unidade_nome", :limit => 150
    t.integer  "destino_persona_id"
    t.integer  "destino_persona_cod"
    t.string   "destino_persona_nome", :limit => 150
    t.string   "destino_persona_ruc",  :limit => 150
    t.string   "direcao",              :limit => 150
    t.string   "bairro",               :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",          :limit => 150
    t.integer  "estado"
  end

  create_table "reclassif_stocks", :force => true do |t|
    t.date     "data"
    t.integer  "produto_id"
    t.string   "produto_nome",      :limit => 250
    t.integer  "deposito_id"
    t.string   "deposito_nome",     :limit => 100
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.decimal  "quantidade",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_quantidade",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "ant_custo_real",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                     :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rodados", :force => true do |t|
    t.string   "placa",       :limit => 50
    t.string   "marcao",      :limit => 100
    t.string   "modelo",      :limit => 100
    t.string   "chassi",      :limit => 100
    t.string   "responsavel", :limit => 150
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "capacidade",                 :precision => 15, :scale => 4, :default => 0.0
    t.integer  "mq"
  end

  create_table "romaneios", :force => true do |t|
    t.integer  "unidade_id"
    t.string   "unidade_nome",      :limit => 80
    t.date     "data"
    t.integer  "safra_id"
    t.string   "safra_nome",        :limit => 80
    t.integer  "transportadora_id"
    t.string   "chapa",             :limit => 15
    t.string   "chofer",            :limit => 80
    t.string   "ci",                :limit => 15
    t.integer  "modo"
    t.integer  "operacao"
    t.integer  "depositante_id"
    t.string   "depositante_nome",  :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rubros", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "plano_de_conta_id"
    t.string   "plano_de_conta_descricao", :limit => 200
    t.string   "descricao",                :limit => 200
    t.string   "codigo",                   :limit => 50
  end

  create_table "safra_ardidos", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_averiados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_brotados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_impurezas", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_produtos", :force => true do |t|
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "safra_quebrados", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safra_umidades", :force => true do |t|
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
    t.integer  "safra_produto_id"
  end

  create_table "safra_verdosos", :force => true do |t|
    t.integer  "safra_produto_id"
    t.integer  "safra_id"
    t.integer  "produto_id"
    t.decimal  "informado",        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "decimal",          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto",         :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                       :null => false
    t.datetime "updated_at",                                                       :null => false
  end

  create_table "safras", :force => true do |t|
    t.string   "descricao",  :limit => 50
    t.date     "inicio"
    t.date     "final"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "servicos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "nome",            :limit => 200
    t.integer  "tipo"
    t.decimal  "valor",                          :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "setors", :force => true do |t|
    t.string   "nome",             :limit => 100
    t.string   "sigla",            :limit => 5
    t.integer  "responsavel_id"
    t.string   "responsavel_nome", :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sobrantes_faltantes", :force => true do |t|
    t.date     "data"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "produto_id"
    t.string   "produto_nome"
    t.integer  "deposito_id"
    t.string   "deposito_nome"
    t.integer  "tipo"
    t.decimal  "quantidade",       :precision => 15, :scale => 3
    t.decimal  "unitario_dolar",   :precision => 15, :scale => 2
    t.decimal  "unitario_guarani", :precision => 15, :scale => 2
    t.decimal  "total_dolar",      :precision => 15, :scale => 2
    t.decimal  "total_guarani",    :precision => 15, :scale => 2
    t.string   "concepto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "cotacao",          :precision => 15, :scale => 2
    t.string   "codigo"
  end

  create_table "stocks", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.date     "data"
    t.integer  "status"
    t.decimal  "entrada",                               :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saida",                                 :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "unitario_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.string   "tabela",                 :limit => 200
    t.integer  "tabela_id"
    t.decimal  "custo_contabil_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_contabil_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "deposito_id"
    t.string   "deposito_nome",          :limit => 150
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.string   "produto_nome",           :limit => 200
    t.integer  "compra_id"
    t.string   "fabricante_cod",         :limit => 50
    t.string   "codigo",                 :limit => 50
    t.integer  "venda_id"
    t.decimal  "frete_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "frete_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "desconto_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "outros_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_dolar",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "despacho_guarani",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                             :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_guarani",                           :precision => 15, :scale => 2, :default => 0.0
    t.integer  "ordem_servico_id"
    t.integer  "tipo"
    t.decimal  "quantidade_bomba",                      :precision => 15, :scale => 2, :default => 0.0
    t.integer  "numero_bomba"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "nota_credito_id"
    t.integer  "taxa"
    t.decimal  "cotacao",                               :precision => 15, :scale => 2
    t.integer  "sub_grupo_id"
    t.string   "persona_nome",           :limit => 200
    t.integer  "persona_id"
    t.integer  "cod_processo"
    t.integer  "clase_produto"
    t.decimal  "total_dolar",                           :precision => 15, :scale => 2
    t.decimal  "total_guarani",                         :precision => 15, :scale => 2
    t.decimal  "promedio_dolar",                        :precision => 15, :scale => 2
    t.decimal  "promedio_guarani",                      :precision => 15, :scale => 2
    t.decimal  "saldo",                                 :precision => 15, :scale => 3
  end

  add_index "stocks", ["produto_id", "entrada", "saida"], :name => "stocks_busca"
  add_index "stocks", ["produto_id"], :name => "stock_produto_id"

  create_table "sub_grupos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "descricao"
    t.integer  "cod_impl"
  end

  create_table "sueldos", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "mes"
    t.integer  "ano"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.integer  "rubro_id"
    t.string   "rubro_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "salario",         :precision => 15, :scale => 2
    t.decimal  "salario_minimo",  :precision => 15, :scale => 2
    t.decimal  "comissao",        :precision => 15, :scale => 2
    t.decimal  "ci",              :precision => 15, :scale => 2
    t.decimal  "ips",             :precision => 15, :scale => 2
    t.integer  "compra_id"
    t.date     "data_inicio"
    t.date     "data_final"
    t.integer  "moeda"
  end

  create_table "sueldos_detalhes", :force => true do |t|
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "sueldo_id"
    t.date     "data"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "conta_id"
    t.string   "conta_nome"
    t.integer  "persona_id"
    t.string   "persona_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "estado"
    t.integer  "documento_id"
    t.string   "documento_nome",      :limit => 200
    t.integer  "rubro_id"
    t.string   "rubro_nome",          :limit => 150
    t.integer  "rubro_cod_contabil"
    t.string   "descricao"
    t.integer  "compra_id"
    t.string   "cheque",              :limit => 50
    t.date     "diferido"
    t.integer  "moeda"
    t.integer  "dias"
    t.decimal  "porcentagem",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 2, :default => 0.0
    t.string   "tipo",                :limit => 50
    t.decimal  "credito_us",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "credito_gs",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "credito_rs",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_us",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_gs",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "debito_rs",                          :precision => 15, :scale => 2, :default => 0.0
    t.date     "vencimento"
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.string   "documento_numero",    :limit => 15
    t.string   "cota",                :limit => 5
  end

  create_table "suportes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tabela_preco_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "produto_id"
    t.string   "produto_nome",            :limit => 200
    t.string   "fabricante_cod",          :limit => 30
    t.integer  "fabricante_id"
    t.string   "fabricante",              :limit => 200
    t.decimal  "taxa",                                   :precision => 15, :scale => 2, :default => 0.0
    t.string   "codigo",                  :limit => 200
    t.datetime "data"
    t.decimal  "preco_venda_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_venda_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao",                                :precision => 15, :scale => 2, :default => 0.0
    t.string   "tabela",                  :limit => 100
    t.integer  "tabela_id"
    t.decimal  "preco_maiorista_guarani",                :precision => 15, :scale => 2
    t.decimal  "preco_maiorista_dolar",                  :precision => 15, :scale => 2
    t.integer  "tipo"
  end

  create_table "transferencia_contas", :force => true do |t|
    t.date     "data"
    t.decimal  "cotacao",                             :precision => 15, :scale => 2
    t.integer  "ingreso_id"
    t.string   "ingreso_nome",         :limit => 100
    t.integer  "ingreso_moeda"
    t.integer  "destino_id"
    t.string   "destino_nome",         :limit => 100
    t.integer  "destino_moeda"
    t.decimal  "valor_dolar",                         :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                       :precision => 15, :scale => 2
    t.integer  "documento_id"
    t.string   "documento_nome",       :limit => 150
    t.string   "concepto",             :limit => 200
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.integer  "reg_status",                                                         :default => 0
    t.integer  "deposito"
    t.decimal  "valor_cheque_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_cheque_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",         :limit => 150
    t.decimal  "valor_real",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cotacao_real",                        :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "transferencia_contas_detalhes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
    t.date     "original"
    t.integer  "tabela_id"
    t.integer  "moeda"
    t.integer  "status"
    t.string   "tabela",                 :limit => 150
    t.string   "concepto",               :limit => 150
    t.integer  "persona_id"
    t.string   "persona_nome",           :limit => 150
    t.string   "cheque",                 :limit => 50
    t.decimal  "entrada_dolar",                         :precision => 15, :scale => 2
    t.decimal  "entrada_guarani",                       :precision => 15, :scale => 2
    t.decimal  "saida_dolar",                           :precision => 15, :scale => 2
    t.decimal  "saida_guarani",                         :precision => 15, :scale => 2
    t.integer  "conta_origem_id"
    t.integer  "conta_destino_id"
    t.string   "conta_origem_nome",      :limit => 100
    t.string   "conta_destino_nome",     :limit => 100
    t.integer  "transferencia_conta_id"
    t.date     "diferido"
    t.integer  "deposito"
    t.integer  "ingreso_moeda"
    t.integer  "destino_moeda"
    t.string   "titular",                :limit => 150
    t.string   "banco",                  :limit => 150
    t.integer  "cheque_status",                                                        :default => 0
    t.decimal  "entrada_real",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "saida_real",                            :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "transferencia_deposito_detalhes", :force => true do |t|
    t.integer  "transferencia_deposito_id"
    t.integer  "deposito_origem_id"
    t.string   "deposito_origem_nome",      :limit => 150
    t.integer  "deposito_destino_id"
    t.string   "deposito_destino_nome",     :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",              :limit => 200
    t.decimal  "quantidade",                               :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "custo_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "preco_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "data"
  end

  create_table "transferencia_depositos", :force => true do |t|
    t.date     "data"
    t.integer  "usuario_created"
    t.integer  "unidade_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_updated"
    t.string   "concepto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deposito_origem_id"
    t.string   "deposito_origem_nome",  :limit => 150
    t.integer  "deposito_destino_id"
    t.string   "deposito_destino_nome", :limit => 150
    t.decimal  "unitario_guarani",                     :precision => 15, :scale => 2
    t.decimal  "unitario_dolar",                       :precision => 15, :scale => 2
  end

  create_table "turnos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nome",            :limit => 200
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
  end

  create_table "unidade_metricas", :force => true do |t|
    t.string   "nome",       :limit => 100
    t.string   "sigla",      :limit => 10
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "unidades", :force => true do |t|
    t.string   "unidade_nome"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuaario_updated"
    t.string   "bairro",           :limit => 100
    t.string   "direcao",          :limit => 100
    t.integer  "cidade_id"
    t.string   "cidade_nome",      :limit => 150
    t.string   "cod_contabil",     :limit => 50
    t.integer  "rubro_id"
    t.string   "rubro_nome",       :limit => 100
  end

  create_table "users", :force => true do |t|
    t.string   "pseudo"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "usuario_nome"
    t.string   "usuario_senha"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
  end

  add_index "usuarios", ["usuario_nome", "usuario_senha", "id"], :name => "busca"

  create_table "variavels", :force => true do |t|
    t.string   "nome"
    t.string   "sigla"
    t.decimal  "valor"
    t.integer  "unidade_metrica_id"
    t.string   "unidade_metrica_nome"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "vendas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipo"
    t.date     "data"
    t.integer  "moeda"
    t.string   "ruc",                 :limit => 50
    t.string   "persona_nome",        :limit => 200
    t.string   "telefone",            :limit => 50
    t.integer  "persona_id"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.decimal  "cotacao",                            :precision => 15, :scale => 2
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.string   "direcao",             :limit => 150
    t.string   "bairro",              :limit => 150
    t.integer  "cidade_id"
    t.string   "cidade_nome",         :limit => 200
    t.string   "documento_numero",    :limit => 100
    t.string   "documento_numero_01", :limit => 5
    t.string   "documento_numero_02", :limit => 5
    t.integer  "documento_id"
    t.integer  "fatura"
    t.string   "documento_nome",      :limit => 150
    t.string   "numero_ordem",        :limit => 20
    t.decimal  "quantidade",                         :precision => 15, :scale => 3
    t.decimal  "total_dolar",                        :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "total_guarani",                      :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "exentas",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravada_10",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10",                         :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo_ordem"
    t.integer  "conta_id"
    t.string   "conta_nome"
    t.decimal  "limite_credito",                     :precision => 15, :scale => 2
    t.string   "classificacao",       :limit => 5
    t.integer  "vendedor_id"
    t.string   "vendedor_nome"
    t.integer  "tipo_maiorista"
    t.integer  "persona_cod"
    t.integer  "pedido_numero"
    t.decimal  "saldo_disponivel",                   :precision => 15, :scale => 2
    t.integer  "tipo_venda"
    t.integer  "mecanico_id"
    t.string   "mecanico_nome",       :limit => 150
    t.integer  "clase_produto"
    t.string   "modelo",              :limit => 150
    t.string   "serie",               :limit => 150
    t.string   "chassi",              :limit => 150
    t.string   "cor",                 :limit => 150
    t.string   "solicitacao",         :limit => 300
    t.date     "data_entrega"
    t.string   "marca",               :limit => 150
    t.string   "acessorio",           :limit => 150
    t.decimal  "desconto_dolar",                     :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                   :precision => 15, :scale => 2
    t.integer  "status"
    t.string   "autori_motivo",       :limit => 200
    t.integer  "local_cobro",         :limit => 2
    t.integer  "local_venda",         :limit => 2
    t.integer  "pedido_id"
    t.decimal  "cotacao_real",                       :precision => 15, :scale => 0, :default => 0
    t.integer  "pedido"
  end

  add_index "vendas", ["data"], :name => "busca_data"

  create_table "vendas_colaboradors", :force => true do |t|
    t.integer  "venda_id"
    t.date     "data"
    t.integer  "persona_id"
    t.string   "persona_nome",  :limit => 100
    t.string   "descricao",     :limit => 100
    t.string   "servico",       :limit => 50
    t.decimal  "quantidade",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "comicao",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendas_entrada_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "venda_id"
    t.integer  "persona_id"
    t.string   "persona_nome",                :limit => 150
    t.integer  "produto_id"
    t.string   "produto_nome",                :limit => 150
    t.date     "data"
    t.date     "data_emicao"
    t.integer  "moeda"
    t.string   "documento_numero_01",         :limit => 10
    t.string   "documento_numero_02",         :limit => 10
    t.string   "documento_numero",            :limit => 50
    t.integer  "documento_id"
    t.string   "documento_nome"
    t.decimal  "quantidade"
    t.decimal  "cotacao",                                    :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_dolar",                              :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "exentas_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_10_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_dolar",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "gravadas_05_guarani",                        :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_10_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_dolar",                           :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "imposto_05_guarani",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                              :precision => 15, :scale => 2, :default => 0.0
    t.string   "documento_timbrado",          :limit => 50
    t.string   "descricao",                   :limit => 250
    t.integer  "clase_produto"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.integer  "deposito_id"
    t.string   "deposito_nome",               :limit => 150
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.string   "recibo_01"
    t.string   "recibo_02"
    t.string   "recibo_numero"
    t.string   "fatura_01"
    t.string   "fatura_02"
    t.string   "fatura_numero"
    t.decimal  "diferenca_comercial_dolar",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "diferenca_comercial_guarani",                :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_comercial_dolar",                      :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_comercial_guarani",                    :precision => 15, :scale => 2, :default => 0.0
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",               :limit => 150
    t.integer  "rubro_id"
    t.string   "rubro_descricao"
    t.integer  "tipo"
    t.string   "documento_venda_numero",      :limit => 150
    t.string   "documento_venda_numero_01",   :limit => 50
    t.string   "documento_venda_numero_02",   :limit => 50
    t.decimal  "taxa",                                       :precision => 15, :scale => 2, :default => 0.0
  end

  create_table "vendas_financas", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "venda_id"
    t.integer  "cota"
    t.date     "vencimento"
    t.integer  "conta_id"
    t.string   "conta_nome",            :limit => 200
    t.string   "cheque",                :limit => 100
    t.date     "diferido"
    t.decimal  "valor_dolar_contado",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani_contado",                :precision => 15, :scale => 2, :default => 0.0
    t.integer  "persona_id"
    t.string   "persona_nome",          :limit => 200
    t.decimal  "cotacao",                              :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.decimal  "valor_dolar_credito",                  :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "valor_guarani_credito",                :precision => 15, :scale => 2, :default => 0.0
    t.string   "direcao",               :limit => 200
    t.string   "bairro",                :limit => 200
    t.string   "ruc",                   :limit => 50
    t.integer  "cidade_id"
    t.string   "cidade_nome",           :limit => 150
    t.string   "fatura_numero",         :limit => 50
    t.string   "documento_nome",        :limit => 150
    t.string   "documento_numero",      :limit => 150
    t.integer  "tipo"
    t.string   "documento_numero_01",   :limit => 5
    t.string   "documento_numero_02",   :limit => 5
    t.integer  "moeda"
    t.integer  "documento_id"
    t.integer  "fatura"
    t.string   "numero_ordem",          :limit => 50
    t.integer  "tipo_ordem"
    t.integer  "transportadora_id"
    t.string   "transportadora_nome",   :limit => 200
    t.integer  "entrega_dolar"
    t.integer  "entrega_guarani"
    t.integer  "cota_dolar"
    t.integer  "cota_guarani"
    t.decimal  "cota_dolar_01",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_02",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_03",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_04",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_05",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_07",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_08",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_09",                        :precision => 15, :scale => 2
    t.decimal  "cota_dolar_10",                        :precision => 15, :scale => 2
    t.decimal  "cota_guarani_01",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_02",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_03",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_04",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_05",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_06",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_07",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_08",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_09",                      :precision => 15, :scale => 2
    t.decimal  "cota_guarani_10",                      :precision => 15, :scale => 2
    t.date     "data_cota_01"
    t.date     "data_cota_02"
    t.date     "data_cota_03"
    t.date     "data_cota_04"
    t.date     "data_cota_05"
    t.date     "data_cota_06"
    t.date     "data_cota_07"
    t.date     "data_cota_08"
    t.date     "data_cota_09"
    t.date     "data_cota_10"
    t.decimal  "cota_dolar_06",                        :precision => 15, :scale => 2
    t.integer  "vendedor_id"
    t.string   "vendedor_nome"
    t.string   "persona_ruc"
    t.string   "banco",                 :limit => 100
    t.string   "titular",               :limit => 150
    t.decimal  "valor_dolar",                          :precision => 15, :scale => 2
    t.decimal  "valor_guarani",                        :precision => 15, :scale => 2
    t.integer  "clase_produto"
    t.string   "fatura_legal",          :limit => 150
    t.string   "fatura_legal_ruc",      :limit => 150
    t.integer  "pagare"
    t.decimal  "desconto_dolar",                       :precision => 15, :scale => 2
    t.decimal  "desconto_guarani",                     :precision => 15, :scale => 2
    t.decimal  "porcen_desconto_us",                   :precision => 15, :scale => 2
    t.decimal  "porcen_desconto_gs",                   :precision => 15, :scale => 2
    t.decimal  "recebido_dolar",                       :precision => 15, :scale => 2
    t.decimal  "recebido_guarani",                     :precision => 15, :scale => 2
    t.integer  "plano_id"
    t.string   "plano_condicao",        :limit => 200
    t.integer  "plano_periodo"
    t.date     "plano_data"
    t.decimal  "plano_taxa",                           :precision => 15, :scale => 2
    t.integer  "plano_status"
    t.decimal  "interes_us",                           :precision => 15, :scale => 2
    t.decimal  "interes_gs",                           :precision => 15, :scale => 2
    t.integer  "cheque_status"
    t.integer  "vuelto"
    t.integer  "vuelto_conta_id"
    t.string   "vuelto_conta_nome",     :limit => 150
    t.string   "vuelto_cheque",         :limit => 100
    t.date     "vuelto_diferido"
    t.decimal  "vuelto_valor_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "vuelto_valor_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_dolar",                   :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "cheque_valor_guarani",                 :precision => 15, :scale => 2, :default => 0.0
    t.integer  "vuelto_cheque_status"
    t.string   "local_pago",            :limit => 1
    t.decimal  "valor_real_contado",                   :precision => 15, :scale => 0, :default => 0
    t.decimal  "valor_real_credito",                   :precision => 15, :scale => 0, :default => 0
    t.decimal  "cota_real_01",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "valor_real",                           :precision => 15, :scale => 0, :default => 0
    t.decimal  "desconto_real",                        :precision => 15, :scale => 0, :default => 0
    t.decimal  "porcen_desconto_rs",                   :precision => 15, :scale => 0, :default => 0
    t.decimal  "recebido_real",                        :precision => 15, :scale => 0, :default => 0
    t.decimal  "interes_real",                         :precision => 15, :scale => 0, :default => 0
    t.decimal  "vuelto_valor_real",                    :precision => 15, :scale => 0, :default => 0
    t.decimal  "cheque_valor_real",                    :precision => 15, :scale => 0, :default => 0
  end

  create_table "vendas_produtos", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "usuario_created"
    t.integer  "usuario_updated"
    t.integer  "unidade_created"
    t.integer  "unidade_updated"
    t.integer  "venda_id"
    t.integer  "produto_id"
    t.string   "produto_nome",            :limit => 200
    t.decimal  "unitario_dolar",                         :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "unitario_guarani",                       :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_dolar",                            :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "total_guarani",                          :precision => 15, :scale => 2, :default => 0.0
    t.decimal  "iva_dolar",                              :precision => 15, :scale => 6, :default => 0.0
    t.decimal  "iva_guarani",                            :precision => 15, :scale => 2, :default => 0.0
    t.string   "codigo",                  :limit => 100
    t.string   "fabricante_cod",          :limit => 100
    t.decimal  "cotacao",                                :precision => 15, :scale => 2, :default => 0.0
    t.date     "data"
    t.decimal  "quantidade",                             :precision => 15, :scale => 3, :default => 0.0
    t.decimal  "saldo",                                  :precision => 15, :scale => 3, :default => 0.0
    t.integer  "conta_created"
    t.integer  "conta_updated"
    t.integer  "turno_created"
    t.integer  "turno_updated"
    t.decimal  "taxa",                                   :precision => 15, :scale => 2, :default => 0.0
    t.integer  "tipo"
    t.integer  "clase_id"
    t.integer  "grupo_id"
    t.string   "barra",                   :limit => 100
    t.integer  "moeda"
    t.integer  "persona_id"
    t.string   "persona_nome",            :limit => 200
    t.string   "deposito_nome",           :limit => 150
    t.integer  "deposito_id"
    t.integer  "bomba_id"
    t.string   "bomba_nome",              :limit => 100
    t.string   "numero_ordem",            :limit => 50
    t.integer  "tipo_ordem"
    t.decimal  "desconto",                               :precision => 15, :scale => 2
    t.decimal  "preco_mairista_dolar",                   :precision => 15, :scale => 2
    t.decimal  "preco_maiorista_guarani",                :precision => 15, :scale => 2
    t.decimal  "total_desconto",                         :precision => 15, :scale => 2
    t.integer  "produto_cod"
    t.decimal  "interes"
    t.integer  "sub_grupo_id"
    t.integer  "tipo_venda"
    t.integer  "clase_produto"
    t.integer  "vendedor_id"
    t.string   "vendedor_nome",           :limit => 150
    t.decimal  "preco_dolar",                            :precision => 15, :scale => 2
    t.decimal  "preco_guarani",                          :precision => 15, :scale => 2
    t.decimal  "porcentagem",                            :precision => 15, :scale => 7
    t.decimal  "preco_fixo_dolar",                       :precision => 15, :scale => 2
    t.decimal  "preco_fixo_guarani",                     :precision => 15, :scale => 2
    t.decimal  "nro_amostra"
    t.decimal  "amostra_macro"
    t.decimal  "amostra_completa"
    t.decimal  "amostra_extratificante"
    t.integer  "laboratorio_id"
    t.string   "laboratorio_nome",        :limit => 150
    t.decimal  "unitario_real",                          :precision => 15, :scale => 0, :default => 0
    t.decimal  "total_real",                             :precision => 15, :scale => 0, :default => 0
    t.decimal  "preco_real",                             :precision => 15, :scale => 0, :default => 0
    t.decimal  "preco_fixo_real",                        :precision => 15, :scale => 0, :default => 0
    t.decimal  "iva_real",                               :precision => 15, :scale => 0, :default => 0
    t.string   "lotes",                   :limit => 100
  end

  add_index "vendas_produtos", ["venda_id", "total_guarani", "iva_guarani"], :name => "busca_venda_id"

end
