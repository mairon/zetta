class CreateUnidadeMetricas < ActiveRecord::Migration
  def change
    create_table :unidade_metricas do |t|
      t.string :nome, :limit => 100
      t.string :sigla, :limit => 10

      t.timestamps
    end
  end
end
