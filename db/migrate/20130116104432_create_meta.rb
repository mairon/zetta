class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.date :data
      t.date :periodo_inicio
      t.date :periodo_final
      t.integer :persona_id
      t.string :persona_nome
      t.integer :moeda

      t.timestamps
    end
  end
end
