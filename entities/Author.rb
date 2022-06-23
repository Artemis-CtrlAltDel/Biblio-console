require '../Biblio-console/entities/Person'

class Author < Person

  @@incrementor = 0

  def initialize(id)
    super id
  end

  def to_s
    "{ Author #{@@incrementor += 1} : {ID = #{@id}} }"
  end
end