require '../Biblio-console/entities/ALibrary'
require '../Biblio-console/entities/Adherent'
require '../Biblio-console/entities/Author'
require '../Biblio-console/entities/Document'
require '../Biblio-console/entities/Material'

gem 'soap4r-ruby1.9'
require 'soap/rpc/driver'

require 'csv'

url = "http://localhost:8089"
urn = 'urn:ruby:client'
app = 'MyApp'

client = SOAP::RPC::Driver.new(url, urn, app)
client.add_method('menu')

client.add_method('init_adherent' , 'id')
client.add_method('init_document' , 'id', 'author_id', 'state')
client.add_method('init_material' , 'id', 'state')

client.add_method('get_adherent_id', 'id')
client.add_method('get_document_id', 'id')
client.add_method('get_material_id', 'id')

client.add_method('get_adherents')
client.add_method('get_documents')
client.add_method('get_materials')

client.add_method('set_document_author', 'isbn', 'id')
client.add_method('get_author_id', 'isbn')
client.add_method('get_authors')

client.add_method('get_materials_ids')

client.add_method('delete_adherent', 'id')
client.add_method('delete_document', 'id')
client.add_method('delete_material', 'id')

client.add_method('borrow_document', 'adherentID', 'id')
client.add_method('borrow_material', 'adherentID', 'id')

client.add_method('lend_document', 'adherentID', 'id')
client.add_method('lend_material', 'adherentID', 'id')

client.add_method('save_as_csv')
client.add_method('open_as_csv')

begin

  while 0
    puts "\n#{client.menu}\nyour choice ?"
    case Integer(readline.chomp)
    when 1
      puts 'Adherent id ?'
      puts client.init_adherent(readline.chomp)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 2
      puts 'Document : isbn - state ?'
      infos = readline.chomp.split /\s-\s/
      puts client.init_document(infos[0], 'x', infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 3
      puts 'Material : id - state ?'
      infos = readline.chomp.split /\s-\s/
      puts client.init_material(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 4
      puts 'adherent id ? ID'
      infos = readline.chomp
      puts client.get_adherent_id(infos)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 5
      puts 'document isbn ? ISBN'
      infos = readline.chomp
      puts client.get_document_id(infos)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 6
      puts 'material id ? ID'
      infos = readline.chomp
      puts client.get_material_id(infos)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 7
      puts client.get_adherents

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 8
      puts client.get_documents

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 9
      puts client.get_materials

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 10
      puts 'For document (ISBN)? . Add author (ID)? . Format : ISBN - ID'
      infos = readline.chomp.split /\s-\s/
      puts client.set_document_author(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 11
      puts 'From document (ISBN)? . Get author (ID)? . Format : ISBN'
      puts client.get_author_id(readline.chomp)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 12
      puts client.get_authors

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 13
      puts client.get_materials_ids

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 14
      puts 'Adherent id ? ID'
      puts client.delete_adherent(readline.chomp)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 15
      puts 'Document isbn ? ISBN'
      puts client.delete_document(readline.chomp)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 16
      puts 'Material id ? ID'
      puts client.delete_material(readline.chomp)

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 17
      puts 'For Adherent (ID)? . Borrow Document (ISBN)? . Format ID - ISBN'
      infos = readline.chomp.split /\s-\s/
      puts client.borrow_document(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 18
      puts 'For Adherent (ID)? . Borrow Material (ISBN)? . Format ID - ISBN'
      infos = readline.chomp.split /\s-\s/
      puts client.borrow_material(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 19
      puts 'For Adherent (ID)? . Lend Material (ISBN)? . Format ID - ISBN'
      infos = readline.chomp.split /\s-\s/
      puts client.lend_material(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 20
      puts 'For Adherent (ID)? . Lend Document (ISBN)? . Format ID - ISBN'
      infos = readline.chomp.split /\s-\s/
      puts client.lend_document(infos[0], infos[1])

      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 21
      CSV.open('./csv/library.csv', 'wb') do |csv|
        client.save_as_csv.each do |row|
         csv << Array(row) 
        end
      end


      puts "\nPress Enter to continue...\n"
      readline.chomp
    when 22
      CSV.open('./csv/library.csv', 'r').each do |line|
        puts line
      end
    when -1
      puts 'are you sure you want to exit ? Enter OR n'

      break if readline.chomp != 'n'
    end
  end
end