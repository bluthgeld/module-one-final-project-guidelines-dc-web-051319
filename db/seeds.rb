require_relative "../config/environment.rb"

elynor = Child.find_or_create_by(last_name: "Pedersen" , first_name: "Elynor" , email: "parents1@greenschool.com" , phone: "301-555-1111")
jesse = Child.find_or_create_by(last_name: "Cheseboro" , first_name: "Jesse" , email: "parents2@greenschool.com" , phone: "301-555-1112")

apple = Snack.find_or_create_by(name: "Apple")
pretzel = Snack.find_or_create_by(name: "Pretzel")
