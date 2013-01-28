class CreateMetas < ActiveRecord::Migration
  def change
    create_table :metas do |t|
      t.date :periodo_inicio
      t.date :periodo_final
      t.integer :moeda
      t.decimal :valor_min_us, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_min_gs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_min_rs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_us, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_gs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_rs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.integer :status
      t.text :descricao

      t.timestamps
    end
  end
end
