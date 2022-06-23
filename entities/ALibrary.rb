class ALibrary
  attr_accessor :adherent, :document, :author, :material

  def initialize
    @adherent = []
    @document = []
    @material = []
    @author   = []
  end

  def to_s
    "{ Library : \n{ADHERENTS = #{@adherent}} , \n{DOCUMENTS = #{@document}} , \n{AUTHORS = #{@author}}, \n{MATERIALS = #{@material}} }"
  end
end