require '../Biblio-console/entities/ALibrary'
require '../Biblio-console/entities/Adherent'
require '../Biblio-console/entities/Author'
require '../Biblio-console/entities/Document'
require '../Biblio-console/entities/Material'

gem 'soap4r-ruby1.9'
require 'logger'
require 'logger-application'
require 'soap/rpc/standaloneServer'

require 'csv'


def menu
  '1- create Adherent?' \
  "\n2- create Document?" \
  "\n3- create Material?\n" \
  "\n4- get adherent by id" \
  "\n5- get document by isbn" \
  "\n6- get material by id\n" \
  "\n7- get all adherents" \
  "\n8- get all documents" \
  "\n9- get all materials\n" \
  "\n10- add author to document" \
  "\n11- get author id from document" \
  "\n12- get all authors ids\n" \
  "\n13- get all materials ids\n" \
  "\n14- delete adherent?" \
  "\n15- delete document?" \
  "\n16- delete material?\n" \
  "\n17- Emprunter document" \
  "\n18- Emprunter material\n" \
  "\n19- rendre material" \
  "\n20- rendre document\n" \
  "\n21- save library as CSV" \
  "\n22- open library as CSV\n" \
 end

begin
  QUOTA = 5
  $lib = ALibrary.new

  def fetch(array, id)

    array.each do |item|
      return [true, item] if item.id == id
    end

    [false, nil]
  end

  def init_adherent(id)
    aQuery = fetch($lib.adherent, id)
    $lib.adherent.push(Adherent.new(id)) unless aQuery[0]
    aQuery[0] ? 'oops, adherent already exists' : 'adherent added'
  end
  def init_document(id, author_id, state)
    aQuery = fetch($lib.document, id)
    $lib.document.push(Document.new(id, author_id, state)) unless aQuery[0]
    aQuery[0] ? 'oops, document already exists' : 'document added'
  end
  def init_material(id, state)
    aQuery = fetch($lib.material, id)
    $lib.material.push(Material.new(id,state)) unless aQuery[0]
    aQuery[0] ? 'oops, material already exists' : 'material added'
  end

  def get_adherent_id(id)
    aQuery = fetch($lib.adherent, id)

    aQuery[0] ? "adherent found : #{aQuery[1].to_s}" : 'adherent not found.'
  end
  def get_document_id(id)
    aQuery = fetch($lib.document, id)

    aQuery[0] ? "document found : #{aQuery[1].to_s}" : 'document not found.'
  end
  def get_material_id(id)
    aQuery = fetch($lib.material, id)

    aQuery[0] ? "material found : #{aQuery[1].to_s}" : 'material not found.'
  end

  def get_adherents
    $lib.adherent.to_s
  end
  def get_documents
    $lib.document.to_s
  end
  def get_materials
    $lib.material.to_s
  end

  def set_document_author(isbn, id)
    aQuery = fetch($lib.document, isbn)
    return 'oops, ISBN not found' unless aQuery[0]
    return 'oops, author already exists for this document' if aQuery[1].author_id == id

    $lib.author.push(Author.new(id))
    aQuery[1].author_id = id
    "author added : #{aQuery[1].author_id}"
  end
  def get_author_id(isbn)
    aQuery = fetch($lib.document, isbn)
    return 'oops, ISBN not found' unless aQuery[0]

    "author id : #{aQuery[1].author_id}"
  end
  def get_authors
    $lib.author.to_s
  end

  def get_materials_ids
    $lib.material.to_s.scan(/@id="[0-9]*"/).to_a
  end

  def delete_adherent(id)
    aQuery = fetch($lib.adherent, id)
    $lib.adherent.delete(aQuery[1]) if aQuery[0]
    return aQuery[0] ? 'adherent deleted' : 'oops, adherent does not exist'
  end
  def delete_document(id)
    aQuery = fetch($lib.document, id)
    $lib.document.delete(aQuery[1]) if aQuery[0]
    return aQuery[0] ? 'document deleted' : 'oops, document does not exist'
  end
  def delete_material(id)
    aQuery = fetch($lib.material, id)
    $lib.material.delete(aQuery[1]) if aQuery[0]
    return aQuery[0] ? 'material deleted' : 'oops, material does not exist'
  end

  def borrow_document(adherentID, id)
    aQuery = fetch($lib.document, id)
    bQuery = fetch($lib.adherent, adherentID)
    
    return 'oops, adherent not found' unless bQuery[0]
    return 'oops, document not found' unless aQuery[0]
    return 'oops, document is out' if aQuery[1].state == 0
    return 'oops, you have exceeded your quota' if bQuery[1].has_documents.count >= QUOTA

    aQuery[1].state = 0
    bQuery[1].has_documents.push(aQuery[1])
    'document borrowed'
  end
  def borrow_material(adherentID, id)
    aQuery = fetch($lib.material, id)
    bQuery = fetch($lib.adherent, adherentID)

    return 'oops, adherent not found' unless bQuery[0]
    return 'oops, material not found' unless aQuery[0]
    return 'oops, material is out' if aQuery[1].state == 0
    return 'oops, you have exceeded your quota' if bQuery[1].has_materials.count >= QUOTA

    aQuery[1].state = 0
    bQuery[1].has_materials.push(aQuery[1])
    'material borrowed'
  end

  def lend_document(adherentID, id)
    aQuery = fetch($lib.document, id)
    bQuery = fetch($lib.adherent, adherentID)

    return 'oops, adherent not found' unless bQuery[0]
    return 'oops, document not found' unless aQuery[0]
    return 'oops, document is available' if aQuery[1].state == 1

    aQuery[1].state = 1
    bQuery[1].has_documents.delete(aQuery[1])
    'document lent'
  end
  def lend_material(adherentID, id)
    aQuery = fetch($lib.material, id)
    bQuery = fetch($lib.adherent, adherentID)

    return 'oops, adherent not found' unless bQuery[0]
    return 'oops, material not found' unless aQuery[0]
    return 'oops, material is available' if aQuery[1].state == 1

    aQuery[1].state = 1
    bQuery[1].has_materials.delete(aQuery[1])
    'material lent'
  end

  def save_as_csv
    adherent_csv = []
    $lib.adherent.each { |item|
      adherent_csv.push("\nADHERENTS, ")
      adherent_csv.push(item.id)
      adherent_csv.push("\n")
    }

    document_csv = ["\nDOCUMENTS\n"]
    $lib.document.each { |item|
      document_csv.push(item.id) if !item.id.nil?
      document_csv.push("\n")
      document_csv.push(item.state == 0 ? 'En_rupture' : 'Disponible')
    }

    material_csv = ["\nMATERIALS\n"]
    $lib.material.each { |item| 
      material_csv.push(item.id) if !item.id.nil?
      material_csv.push("\n")
      material_csv.push(item.state == 0 ? 'En_rupture' : 'Disponible')
    }

    [adherent_csv, document_csv, material_csv]
  end
  def open_as_csv
    nil
  end
end

class Server < SOAP::RPC::StandaloneServer
  def on_init
    add_method(self, 'menu')

    add_method(self, 'init_adherent' , 'id')
    add_method(self, 'init_document' , 'id', 'author_id', 'state')
    add_method(self, 'init_material' , 'id', 'state')

    add_method(self, 'get_adherent_id', 'id')
    add_method(self, 'get_document_id', 'id')
    add_method(self, 'get_material_id', 'id')

    add_method(self, 'get_adherents')
    add_method(self, 'get_documents')
    add_method(self, 'get_materials')

    add_method(self, 'set_document_author', 'isbn', 'id')
    add_method(self, 'get_author_id', 'isbn')
    add_method(self, 'get_authors')

    add_method(self, 'get_materials_ids')

    add_method(self, 'delete_adherent', 'id')
    add_method(self, 'delete_document', 'id')
    add_method(self, 'delete_material', 'id')

    add_method(self, 'borrow_document', 'adherentID', 'id')
    add_method(self, 'borrow_material', 'adherentID', 'id')

    add_method(self, 'lend_document', 'adherentID', 'id')
    add_method(self, 'lend_material', 'adherentID', 'id')

    add_method(self, 'save_as_csv')
    add_method(self, 'open_as_csv')
  end
end

# initialize Server and start :

app   = 'MyApp'
host  = 'localhost'
port  = 8089
ns    = 'urn:ruby:client'

server = Server.new(app, ns, host, port)
server.start