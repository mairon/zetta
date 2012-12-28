class Unidade < ActiveRecord::Base
      def before_save
          @cidade                   = Cidade.find_by_id( self.cidade_id );
          self.cidade_nome          = @cidade.nome.to_s unless self.cidade_id.blank? ;
      end

end
