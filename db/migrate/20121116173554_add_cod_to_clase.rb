class AddCodToClase < ActiveRecord::Migration
  def change
    add_column :clases, :cod_impl, :integer
    add_column :grupos, :cod_impl, :integer
    add_column :sub_grupos, :cod_impl, :integer
  end
end
