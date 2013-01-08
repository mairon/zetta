class CreateVariavels < ActiveRecord::Migration
  def change
    create_table :variavels do |t|
      t.string :nome
      t.string :sigla
      t.decimal :valor, :decimal, :scale => 3, :precision => 15,:default => 0
      t.integer :unidade_metrica_id
      t.string :unidade_metrica_nome

      t.timestamps
    end
  end
end
