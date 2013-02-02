class AddNewVendaToForms < ActiveRecord::Migration
  def change
    add_column :forms, :venda_index_new, :string
  end
end
