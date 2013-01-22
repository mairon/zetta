class CreateMetaDetalhes < ActiveRecord::Migration
  def change
    create_table :meta_detalhes do |t|
      t.integer :meta_id
      t.integer :persona_id
      t.string :persona_nome
      t.integer :setor_id
      t.string :setor_nome
      t.decimal :valor_min_us, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_min_gs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_min_rs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_us, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_gs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :valor_max_rs, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :comicao_min, :decimal, :scale => 2, :precision => 15,:default => 0
      t.decimal :comicao_max, :decimal, :scale => 2, :precision => 15,:default => 0
      t.text :descricao

      t.timestamps
    end
  end
end
