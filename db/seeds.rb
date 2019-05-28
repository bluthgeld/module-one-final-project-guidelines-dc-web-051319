require_relative "../config/environment.rb"

elynor = Child.find_or_create_by(last_name: "Pedersen" , first_name: "Elynor" , email: "parents1@greenschool.com" , phone: "301-555-1111")
jesse = Child.find_or_create_by(last_name: "Cheseboro" , first_name: "Jesse" , email: "parents2@greenschool.com" , phone: "301-555-1112")
fiona = Child.find_or_create_by(last_name: "Smith" , first_name: "Fiona" , email: "parents3@greenschool.com" , phone: "301-555-1113")

apple = Snack.find_or_create_by(name: "Apple")
pretzel = Snack.find_or_create_by(name: "Pretzel")

date1 = SnackDate.find_or_create_by(date: "June 1, 2019" , quantity: 4 , child_id: elynor.id , snack_id: apple.id)
date2 = SnackDate.find_or_create_by(date: "June 12, 2019" , quantity: 3 , child_id: jesse.id , snack_id: apple.id)
