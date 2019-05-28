require_relative '../config/environment'


def main
  Cli.welcome
  lastname = Cli.get_lastname
  if Cli.verify_lastname(lastname)
  else
    puts "Your child is not registered for this class.  Please visit the Main Office."
    main
  end

end

main
