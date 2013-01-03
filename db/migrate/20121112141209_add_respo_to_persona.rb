class AddRespoToPersona < ActiveRecord::Migration
  def change
    add_column :personas, :vend_responsavel_id, :integer
    add_column :personas, :vend_responsavel_nome, :string, :limit => 150
  end
end
