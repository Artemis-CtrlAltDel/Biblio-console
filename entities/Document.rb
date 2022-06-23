require '../Biblio-console/entities/Objects'

class Document < Objects
  attr_accessor :author_id

  @@incrementor = 0

  def initialize(id, author_id, state)
    super id, state
    @author_id = author_id
  end

  def modify(id)
    self.author_id = id
  end

  def to_s
    "{ Document #{@@incrementor += 1} : {AUTHOR_ID = #{@author_id}} , {ISBN = #{@id}} , {STATE = #{@state}} }"
  end
end