require_relative "../config/environment.rb"

Child.delete_all
Snack.delete_all
SnackDate.delete_all

elynor = Child.find_or_create_by(last_name: "pedersen" , first_name: "elynor" , email: "parents1@greenschool.com" , phone: "301-555-1111")
jesse = Child.find_or_create_by(last_name: "cheseboro" , first_name: "jesse" , email: "parents2@greenschool.com" , phone: "301-555-1112")
fiona = Child.find_or_create_by(last_name: "smith" , first_name: "fiona" , email: "parents3@greenschool.com" , phone: "301-555-1113")
luke = Child.find_or_create_by(last_name: "kidd" , first_name: "luke" , email: "parents4@greenschool.com" , phone: "301-555-1114")
otto = Child.find_or_create_by(last_name: "german" , first_name: "otto" , email: "parents5@greenschool.com" , phone: "301-555-1115")



apple = Snack.find_or_create_by(name: "apple")
pretzel = Snack.find_or_create_by(name: "pretzel")

date1 = SnackDate.find_or_create_by(date: "June 1, 2019" , quantity: 4 , child_id: elynor.id , snack_id: apple.id)
date2 = SnackDate.find_or_create_by(date: "June 12, 2019" , quantity: 3 , child_id: jesse.id , snack_id: apple.id)
date3 = SnackDate.find_or_create_by(date: "July 4, 2019" , quantity: 55 , child_id: elynor.id , snack_id: pretzel.id)
