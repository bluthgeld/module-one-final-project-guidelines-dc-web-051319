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
    lastname = gets.chomp
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
    puts "*     Please Type Option 1, 2, 3, 4, or 5.       *"
    puts "*" * 50
    puts ""
    optionchoice = gets.to_i
    if optionchoice.between?(1,5)
      return optionchoice
    else
      puts "You have made a titanic error in judgement.  I'm surprised your child can read."
      puts "Please make a sane selection."
      self.nav_options
    end
  end

  def self.read(lastname)
    child = Child.find_by(last_name: lastname)
    snackdate = SnackDate.where("child_id = #{child.id}")
    if snackdate.length > 0
      snackdate.each do |sd|
        snack = Snack.find(sd.snack_id)
        puts "The #{lastname} Family is Schedule to Bring #{sd.quantity} #{snack.name}(s) On #{sd.date}"
        puts ""
      end
    else
      puts "You have not Scheduled a Date to Bring Snacks.  Please Consider Option 1."
      true
    end
  end

  def self.quit
    puts "You are leaving the Snack List.  We Hope You Have a Great Day!"
  end


  def self.create(lastname)
    child = Child.find_by(last_name: lastname)
    puts "Thank you for scheduling your Snack Day"
    #snack date and quantity, we have the last_name
    #choose date
    puts "Choose an available date to bring a snack"
    date = gets.chomp
    if !(SnackDate.find_by(date: date)) == false
      puts "That day is already taken.  Please choose another day"
      self.create
    end
    puts "Choose the Snack You Will Bring From the List Below:"
    Snack.all.each do |snack|
      puts "#{snack.id} - #{snack.name}"
    end
    snack_input = gets.to_i
    snack = Snack.find(snack_input)
    puts "How many #{snack.name}(s) will you bring?"
    quantity = gets.to_i
    SnackDate.create(date: date , quantity: quantity , child_id: child.id, snack_id: snack.id)
    puts "You are scheduled to bring #{quantity} #{snack.name}(s) on #{date}."
  end

  def self.update(lastname)
    self.read(lastname)
    #first option
    puts "Enter the the Snack Date You would Like to Update"
    date = gets.chomp

    snackdate = SnackDate.find_by(date: date)

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
          self.update(lastname)
        end
    else
      puts "You have entered an invalid date.  Please enter a valid Snack Date."
      self.update(lastname)
    end
  end

  def self.change_date(snackdate)
    puts "You are currently scheduled for #{snackdate.date}.  Please select a new date:"
    new_date = gets.chomp
    if !(SnackDate.find_by(date: new_date)) == false
      puts "This date is already taken.  Please choose another date."
      change_date(snackdate)
    else
      new_snackdate = SnackDate.update(snackdate.id , date: new_date)
    end
    puts "Your new Snack Date is #{new_date}."
    return new_snackdate
  end


  def self.change_snack_and_quantity(snackdate)
    snack = Snack.find(snackdate.snack_id)
    puts "You are currently scheduled to bring #{snackdate.quantity} #{snack.name} on #{snackdate.date} "
    puts "Choose the Snack You Will Bring From the List Below:"
    Snack.all.each do |snack|
      puts "#{snack.id} - #{snack.name}"
    end
    snack_input = gets.to_i
    new_snack = Snack.find(snack_input)
    puts "How many #{new_snack.name}(s) will you bring?"
    quantity = gets.to_i
    SnackDate.update(snackdate.id, quantity: quantity , snack_id: new_snack.id)
    puts "You are scheduled to bring #{quantity} #{new_snack.name}(s) on #{snackdate.date}."
  end

  def self.delete(lastname)
    if self.read(lastname)

    else
      puts "Enter the the Snack Date You would Like to Delete.  Type Quit to Return to the Main Menu."
      date = gets.chomp
      snackdate = SnackDate.find_by(date: date)
      if snackdate
        SnackDate.delete(snackdate.id)
        puts "Your Snack Date has been Deleted.  Returning to the Main Menu."
      elsif date.downcase == "quit"
        puts "Returning to the Main Menu"
      else
        puts "You have entered an invalid Snack Date.  Please enter a Valid Snack Date."
        self.delete(lastname)
      end
    end
  end

end
