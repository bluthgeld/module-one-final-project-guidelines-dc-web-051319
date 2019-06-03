# frozen_string_literal: true

require_relative '../config/environment'

require 'date'

def main
  Cli.welcome
  lastname = Cli.get_lastname
  child = Cli.verify_lastname(lastname)
  if child
    main_menu_loop = true

    while main_menu_loop
      selection = Cli.nav_options

      case selection
      when 1 # create
        Cli.snacktime_header
        date = Cli.grab_user_date
        snack = Cli.grab_user_snack
        quantity = Cli.grab_user_quantity(snack)
        Cli.create(child, date, snack, quantity)
      when 2 # read
        Cli.read(child)
      when 3 # update
        Cli.read(child)
        snackdate = Cli.grab_snack_date(child)

        if snackdate
          update_menu_loop = true

          while update_menu_loop
            update_selection = Cli.update_nav_options
            case update_selection
            when 1 # update date
              date = Cli.grab_user_date
              new_snackdate = Cli.update(snackdate, date: date)
              Cli.snacktime_header
              puts "Your new Snack Date #{new_snackdate.date}"
              update_menu_loop = false
            when 2 # update snack and quantity
              snack = Cli.grab_user_snack
              quantity = Cli.grab_user_quantity(snack)
              new_snackdate = Cli.update(snackdate, snack_id: snack.id, quantity: quantity)
              Cli.snacktime_header
              puts "You are scheduled to bring #{quantity} #{new_snackdate.snack.name.capitalize}(s) on #{snackdate.date}."
              update_menu_loop = false
            when 3 # update date, snack, and quantity
              date = Cli.grab_user_date
              snack = Cli.grab_user_snack
              quantity = Cli.grab_user_quantity(snack)
              new_snackdate = Cli.update(snackdate, date: date, snack_id: snack.id, quantity: quantity)
              Cli.snacktime_header
              puts "You are scheduled to bring #{quantity} #{new_snackdate.snack.name.capitalize}(s) on #{snackdate.date}."
              update_menu_loop = false
            when 4 # return to main menu
              Cli.snacktime_header
              puts 'Returning to the Main Menu'
              update_menu_loop = false
            else
              puts 'You have entered an invalid selection.'
            end
          end
        end
      when 4 # delete
        unless Cli.read(child)
          snackdate = Cli.grab_snack_date(child)
          if snackdate
            Cli.delete(snackdate)
            Cli.snacktime_header
            puts 'Your Snack Date has been Deleted.  Returning to the Main Menu.'
          end
        end
      when 5 # quit
        main_menu_loop = false if Cli.quit
      end
    end

  else
    Cli.snacktime_header
    puts 'Your child is not registered for this class.  Please visit the Main Office.'
    puts
    if Cli.quit
    else
      main
    end
  end
end

main
