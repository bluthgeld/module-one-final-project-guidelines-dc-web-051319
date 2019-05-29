require_relative '../config/environment'

require 'date'


def main
  Cli.welcome
  lastname = Cli.get_lastname
  child = Cli.verify_lastname(lastname)
  if child

    bool = true

    while bool

      selection = Cli.nav_options

      case selection
      when 1
        Cli.create(child)
      when 2
        Cli.read(child)
      when 3
        Cli.update(child)
      when 4
        Cli.delete(child)
      when 5
        if Cli.quit
          bool = false
        end
      end

    end

  else
    puts "Your child is not registered for this class.  Please visit the Main Office."
    if Cli.quit
    else
      main
    end
  end
end

main
