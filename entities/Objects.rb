require '../Biblio-console/entities/Person'

class Objects < Person
  attr_accessor :state

  def initialize(id, state)
    super id
    @state = state
  end
end