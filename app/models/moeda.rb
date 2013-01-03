class Moeda < ActiveRecord::Base
   validates_uniqueness_of :data, :message => " ja cadastrado."
   validates_presence_of :dolar_compra,:dolar_venda 
   
end
