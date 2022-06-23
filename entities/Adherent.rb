require '../Biblio-console/entities/Person'

class Adherent < Person

  @@incrementor = 0

  attr_accessor :has_materials, :has_documents

  def initialize(id)
    super id

    @has_documents = []
    @has_materials = []
  end

  def to_s
    "{ Adherent #{@@incrementor += 1} : {ID = #{@id}} , {HAS-DOCUMENTS = #{@has_documents}} , {HAS-MATERIALS = #{@has_materials}} }"
  end
end