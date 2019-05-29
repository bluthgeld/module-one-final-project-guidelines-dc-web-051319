require_relative '../config/environment'


def main
  Cli.welcome
  lastname = Cli.get_lastname
  if Cli.verify_lastname(lastname)

    bool = true

    while bool

      selection = Cli.nav_options

      case selection
      when 1
        Cli.create(lastname)
      when 2
        Cli.read(lastname)
      when 3
        Cli.update(lastname)
      when 4
        Cli.delete(lastname)
      when 5
        Cli.quit
        bool = false
      end

    end

  else
    puts "Your child is not registered for this class.  Please visit the Main Office."
    main
  end
end

main
