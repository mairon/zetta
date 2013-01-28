class AddCalcsToMetodos < ActiveRecord::Migration
  def change
    add_column :metodos, :valor, :decimal, :scale => 5, :precision => 15,:default => 0
    add_column :metodos, :valor_ensaio, :string, :limit => 100
    add_column :metodos, :tipo_id, :integer
    add_column :metodos, :tipo_nome, :string, :limit => 100
    add_column :metodos, :var_01_id, :integer
    add_column :metodos, :var_01_nome, :string, :limit => 100
    add_column :metodos, :var_01_fator, :decimal, :scale => 5, :precision => 15,:default => 0
    add_column :metodos, :var_02_id, :integer
    add_column :metodos, :var_02_nome, :string, :limit => 100
    add_column :metodos, :var_02_fator, :decimal, :scale => 5, :precision => 15,:default => 0
    add_column :metodos, :var_03_id, :integer
    add_column :metodos, :var_03_nome, :string
    add_column :metodos, :var_03_fator, :decimal, :scale => 5, :precision => 15,:default => 0
    add_column :metodos, :calc_01, :string, :limit => 100
    add_column :metodos, :calc_02, :string, :limit => 100
    add_column :metodos, :calc_03, :string, :limit => 100
    add_column :metodos, :preco_us, :decimal, :scale => 2, :precision => 15,:default => 0
    add_column :metodos, :preco_gs, :decimal, :scale => 2, :precision => 15,:default => 0
    add_column :metodos, :preco_rs, :decimal, :scale => 2, :precision => 15,:default => 0
  end
end
