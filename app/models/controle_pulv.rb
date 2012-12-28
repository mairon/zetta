class ControlePulv < ActiveRecord::Base

  validates_numericality_of :area

  has_many :controle_pulv_maqs


end
