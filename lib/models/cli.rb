require 'date'

class Cli

  def self.welcome
    puts ""
    puts "    ::::::::  ::::    :::     :::      ::::::::  :::    ::: "
    puts "   :+:    :+: :+:+:   :+:   :+: :+:   :+:    :+: :+:   :+:  "
    puts "   +:+        :+:+:+  +:+  +:+   +:+  +:+        +:+  +:+   "
    puts "   +#++:++#++ +#+ +:+ +#+ +#++:++#++: +#+        +#++:++    "
    puts "          +#+ +#+  +#+#+# +#+     +#+ +#+        +#+  +#+   "
    puts "   #+#    #+# #+#   #+#+# #+#     #+# #+#    #+# #+#   #+#  "
    puts "    ########  ###    #### ###     ###  ########  ###    ### "
    puts "   ::::::::::: ::::::::::: ::::    ::::  :::::::::: "
    puts "       :+:         :+:     +:+:+: :+:+:+ :+:        "
    puts "       +:+         +:+     +:+ +:+:+ +:+ +:+        "
    puts "       +#+         +#+     +#+  +:+  +#+ +#++:++#   "
    puts "       +#+         +#+     +#+       +#+ +#+        "
    puts "       #+#         #+#     #+#       #+# #+#        "
    puts "       ###     ########### ###       ### ########## "
    puts ""
    puts "Welcome to Ms. Heidi's Snack List."
    puts ""
  end

  def self.get_lastname
    puts "Please enter your child's last name"
    gets.chomp.downcase
  end

  def self.verify_lastname(lastname)
    Child.find_by(last_name: lastname)
  end

  def self.nav_options
    puts ""
    puts "*" * 50
    puts "*                                                *"
    puts "*                 MAIN MENU                      *"
    puts "*                                                *"
    puts "*                 1. Create                      *"
    puts "*                 2. Read                        *"
    puts "*                 3. Update                      *"
    puts "*                 4. Delete                      *"
    puts "*                 5. Quit                        *"
    puts "*                                                *"
    puts "*          Please Enter 1, 2, 3, 4, or 5.        *"
    puts "*               and press Return                 *"
    puts "*" * 50
    puts ""
    optionchoice = gets.to_i
    if optionchoice.between?(1,5)
      return optionchoice
    else
      puts ""
      puts "You have made a titanic error in judgement.  I'm surprised your child can read."
      puts "Please make a sane selection."
    end
  end

  def self.read(child)
    snackdate = SnackDate.where("child_id = #{child.id}")
    if snackdate.length > 0
      snackdate.each_with_index do |sd , index|
        snack = Snack.find(sd.snack_id)
        puts "#{index + 1}. The #{child.last_name.capitalize} Family is Schedule to Bring #{sd.quantity} #{snack.name.capitalize}(s) On #{sd.date}"
        puts ""
      end
      return false
    else
      puts "You have not Scheduled a Date to Bring Snacks.  Please Consider Option 1 from the Main Menu."
      return true
    end
  end

  def self.quit
    puts "Are you sure you want to leave?"
    puts "Type Y for Yes or N for No"
    quit = gets.chomp.downcase
    if quit == "y"
      puts "You are leaving the Snack List.  We Hope You Have a Great Day!"
      return true
    else
      return false
    end
  end


  def self.create(child)
    puts "Thank you for scheduling your Snack Day"
    #snack date and quantity, we have the last_name
    #choose date
    puts "Choose an available date to bring a snack"
    date = gets.chomp
    if !(valid_date(date))
      puts "Invalid Date Format.  Please format YYYY-MM-DD."
      return false
    end
    if !(SnackDate.find_by(date: date)) == false
      puts "That day is already taken.  Please choose another day"
      date = ""
      return false
    end
    puts "Choose the Snack You Will Bring From the List Below:"
    Snack.all.each_with_index do |snack , index|
      puts "#{index + 1} - #{snack.name.capitalize}"
    end
    snack_input = gets.to_i
    snack = Snack.all[snack_input - 1]
    puts "How many #{snack.name.capitalize}(s) will you bring?"
    quantity = gets.to_i
    SnackDate.create(date: date , quantity: quantity , child_id: child.id, snack_id: snack.id)
    puts "You are scheduled to bring #{quantity} #{snack.name.capitalize}(s) on #{date}."
  end

  def self.update(child)
    self.read(child)
    #first option
    puts "Enter the the Number for the Snack Date You would Like to Update"
    date = gets.to_i

    snackdate = SnackDate.where(child_id: child.id)[date - 1]

    if snackdate
      puts ""
      puts "*" * 50
      puts "*                                                *"
      puts "*          To Update Your Snack Time             *"
      puts "*        Please Select an Option Below           *"
      puts "*             and press Return                   *"
      puts "*                                                *"
      puts "*        1. Change Date                          *"
      puts "*        2. Change Snack and Quantity            *"
      puts "*        3. Change Date, Snack, and Quantity     *"
      puts "*        4. Main Menu                            *"
      puts "*                                                *"
      puts "*" * 50
      update_option = gets.to_i

        case update_option
        when 1
          self.change_date(snackdate)
        when 2
          self.change_snack_and_quantity(snackdate)
        when 3
          new_snackdate = self.change_date(snackdate)
          self.change_snack_and_quantity(new_snackdate)
        when 4
          puts "Returning to the Main Menu"
        else
          puts "You have entered an invalid selection."
          self.update(child)
        end
    else
      puts "You have entered an invalid date.  Please enter a valid Snack Date."
      self.update(child)
    end
  end

  def self.change_date(snackdate)
     puts "You are currently scheduled for #{snackdate.date}.  Please select a new date:"
     date_is_invalid = true
     while date_is_invalid
       new_date = gets.chomp
       if !SnackDate.find_by(date: new_date) == false
         puts "This date is already taken.  Please choose another date."
       else
         new_snackdate = SnackDate.update(snackdate.id, date: new_date)
         date_is_invalid = false
       end
     end
     puts "Your new Snack Date #{new_date}"
     new_snackdate
   end

  def self.change_snack_and_quantity(snackdate)
    snack = Snack.find(snackdate.snack_id)
    puts "You are currently scheduled to bring #{snackdate.quantity} #{snack.name.capitalize} on #{snackdate.date} "
    puts "Choose the Snack You Will Bring From the List Below:"
    Snack.all.each do |snack|
      puts "#{snack.id} - #{snack.name.capitalize}"
    end
    snack_input = gets.to_i
    new_snack = Snack.find(snack_input)
    puts "How many #{new_snack.name.capitalize}(s) will you bring?"
    quantity = gets.to_i
    SnackDate.update(snackdate.id, quantity: quantity , snack_id: new_snack.id)
    puts "You are scheduled to bring #{quantity} #{new_snack.name.capitalize  }(s) on #{snackdate.date}."
  end

  def self.delete(child)
    if self.read(child)

    else
      puts "Enter the the Snack Date You would Like to Delete.  Type Quit to Return to the Main Menu."
      date = gets.to_i
      snackdate = SnackDate.where(child_id: child.id)[date - 1]
      if snackdate
        SnackDate.delete(snackdate.id)
        puts "Your Snack Date has been Deleted.  Returning to the Main Menu."
      elsif date.downcase == "quit"
        puts "Returning to the Main Menu"
      else
        puts "You have entered an invalid Snack Date.  Please enter a Valid Snack Date."
        self.delete(child)
      end
    end
  end

  def self.valid_date(date)
    begin
      Date.parse(date)
      true
    rescue ArgumentError
    false
    end
  end

end
