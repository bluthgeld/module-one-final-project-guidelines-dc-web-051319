require_relative '../config/environment'


def main
  Cli.welcome
  lastname = Cli.get_lastname
  if Cli.verify_lastname(lastname)
    selection = Cli.nav_options

    case selection
    when 1
      puts "1"
    when 2
      puts "2"
    when 3
      puts "3"
    when 4
      puts "4"
    when 5
      puts "5"
    end

  else
    puts "Your child is not registered for this class.  Please visit the Main Office."
    main
  end
end

main
