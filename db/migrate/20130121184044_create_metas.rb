class CreateMetas < ActiveRecord::Migration
  def change
    create_table :metas do |t|
      t.date :periodo_inicio
      t.date :periodo_final
      t.integer :moeda
      t.decimal :valor_min_us
      t.decimal :valor_min_gs
      t.decimal :valor_min_rs
      t.decimal :valor_max_us
      t.decimal :valor_max_gs
      t.decimal :valor_max_rs
      t.integer :status
      t.text :descricao

      t.timestamps
    end
  end
end
