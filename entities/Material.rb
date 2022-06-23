require '../Biblio-console/entities/Objects'

class Material < Objects

  @@incrementor = 0

  def initialize(id, state)
    super id, state
  end

  def to_s
    "{ Material #{@@incrementor += 1} : {ID = #{@id}} , {STATE = #{@state}} }"
  end
end