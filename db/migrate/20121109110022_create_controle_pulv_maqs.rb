class CreateControlePulvMaqs < ActiveRecord::Migration
  def change
    create_table :controle_pulv_maqs do |t|
      t.integer :controle_pulv_id
      t.date :data
      t.string :modelo, :limit => 100
      t.integer :hora_maq, :default => 0
      t.string :bico_01, :limit => 100
      t.string :bico_02, :limit => 100
      t.integer :vazao_01, :default => 0
      t.integer :vazao_02, :default => 0
      t.string :autonomia_01, :limit => 100
      t.string :autonomia_02, :limit => 100
      t.integer :velocidade_01, :default => 0
      t.integer :velocidade_02, :default => 0
      t.integer :etiqueta
      t.integer :calibracao
      t.integer :regular
      t.integer :condicao_maq

      t.timestamps
    end
  end
end
