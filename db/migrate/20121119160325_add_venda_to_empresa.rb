class AddVendaToEmpresa < ActiveRecord::Migration
  def change
    remove_column :empresas, :modulo_laboratorio
    add_column :empresas, :modulo_laboratorio, :boolean
    add_column :empresas, :modulo_producao, :boolean
    add_column :empresas, :modulo_granos, :boolean
    add_column :empresas, :venda_persona_id, :integer
		add_column :empresas, :venda_persona_nome, :string, :limit => 150
		add_column :empresas, :venda_persona_ruc, :string, :limit => 20
		add_column :empresas, :venda_moeda, :integer
		add_column :empresas, :nome, :string, :limit => 150
		add_column :empresas, :direcao, :string, :limit => 100
		add_column :empresas, :ruc, :string, :limit => 20

  end
end

