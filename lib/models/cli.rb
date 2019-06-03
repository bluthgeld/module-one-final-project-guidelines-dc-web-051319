# frozen_string_literal: true

require 'date'
require 'twilio-ruby'

class Cli
  SNACKTIME = <<-STR


       ::::::::  ::::    :::     :::      ::::::::  :::    :::
      :+:    :+: :+:+:   :+:   :+: :+:   :+:    :+: :+:   :+:
      +:+        :+:+:+  +:+  +:+   +:+  +:+        +:+  +:+
      +#++:++#++ +#+ +:+ +#+ +#++:++#++: +#+        +#++:++
             +#+ +#+  +#+#+# +#+     +#+ +#+        +#+  +#+
      #+#    #+# #+#   #+#+# #+#     #+# #+#    #+# #+#   #+#
       ########  ###    #### ###     ###  ########  ###    ###
          ::::::::::: ::::::::::: ::::    ::::  ::::::::::
              :+:         :+:     +:+:+: :+:+:+ :+:
              +:+         +:+     +:+ +:+:+ +:+ +:+
              +#+         +#+     +#+  +:+  +#+ +#++:++#
              +#+         +#+     +#+       +#+ +#+
              #+#         #+#     #+#       #+# #+#
              ###     ########### ###       ### ##########

        *****          Ms. Heidi's Snack List.         *****

  STR

  # Welcome Message
  def self.welcome
    snacktime_header
  end

  # Gets Name for the Child/Parent
  def self.get_lastname
    puts "Please enter your child's last name:"
    gets.chomp.downcase
  end

  # Verifies if the child's last name exists in the list.
  def self.verify_lastname(lastname)
    Child.find_by(last_name: lastname)
  end

  # Main Menu Navigation
  def self.nav_options
    puts
    puts '       ' + '*' * 50
    puts '       *                                                *'
    puts '       *                 MAIN MENU                      *'
    puts '       *                                                *'
    puts '       *             1. Schedule a Snack Date           *'
    puts '       *             2. My Snack Dates                  *'
    puts '       *             3. Modify a Snack Date             *'
    puts '       *             4. Delete a Snack Date             *'
    puts '       *             5. Quit                            *'
    puts '       *                                                *'
    puts '       *        Please Enter 1, 2, 3, 4, or 5.          *'
    puts '       *                and press Return                *'
    puts '       ' + '*' * 50
    puts
    optionchoice = gets.to_i
    if optionchoice.between?(1, 5)
      return optionchoice
    else
      snacktime_header
      puts "You have made a titanic error in judgement.  I'm surprised your child can read."
      puts 'Please make a sane selection.'
    end
  end

  # Lists all of the Snack Dates associated with the logged in child

  def self.read(child)
    snackdate = child.snack_dates.order(:date)
    if !snackdate.empty?
      snacktime_header
      snackdate.each_with_index do |sd, index|
        snack = Snack.find(sd.snack_id)
        puts
        puts "#{index + 1}. The #{child.last_name.capitalize} Family is Schedule to Bring #{sd.quantity} #{snack.name.capitalize}(s) On #{sd.date}"
      end
      return false
    else
      snacktime_header
      puts 'You have not Scheduled a Date to Bring Snacks.  Please Consider Option 1 from the Main Menu.'
      return true
    end
  end

  # quits out of the application
  def self.quit
    puts
    puts 'Do You Want to Leave Snack List?'
    puts
    puts 'Type Y for Yes or N for No'
    quit = gets.chomp.downcase
    if quit == 'y'
      snacktime_header
      puts
      puts 'You are leaving the Snack List.  We Hope You Have a Great Day!'
      puts
      puts
      return true
    else
      snacktime_header
      return false
    end
  end

  # creates a new Snack Time, with the argument of child

  def self.create(child, date, snack, quantity)
    SnackDate.create(date: date, quantity: quantity, child_id: child.id, snack_id: snack.id)
    snacktime_header
    puts
    puts "You are scheduled to bring #{quantity} #{snack.name.capitalize}(s) on #{date}."
  end

  # Update Navigation Screen, with argument of child
  def self.update_nav_options
    snacktime_header
    puts
    puts '       ' + '*' * 50
    puts '       *                                                *'
    puts '       *          To Update Your Snack Time             *'
    puts '       *        Please Select an Option Below           *'
    puts '       *             and press Return                   *'
    puts '       *                                                *'
    puts '       *        1. Change Date                          *'
    puts '       *        2. Change Snack and Quantity            *'
    puts '       *        3. Change Date, Snack, and Quantity     *'
    puts '       *        4. Main Menu                            *'
    puts '       *                                                *'
    puts '       ' + '*' * 50
    update_choice = gets.to_i
    if update_choice.between?(1, 4)
      update_choice
    else
      snacktime_header
      puts 'Invalid choice'
    end
  end

  def self.update(snackdate, attributes)
    SnackDate.update(snackdate.id, attributes)
  end

  def self.grab_snack_date(child)
    puts
    puts 'Enter the Number for the Snack Date You Would Like to Update'
    date = gets.to_i
    if date.between?(1, SnackDate.where(child_id: child.id).length)
      child.snack_dates.order(:date)[date - 1]
    else
      snacktime_header
      puts ''
      puts "You have made an invalid selection.  Please select Snack Date 1 through #{SnackDate.where(child_id: child.id).length} next time."
    end
  end

  def self.grab_user_quantity(snack)
    puts
    puts "How many #{snack.name.capitalize}(s) will you bring?"
    gets.to_i
  end

  def self.grab_user_date
    puts
    puts 'Thank you for scheduling your Snack Day'
    puts ''
    puts 'Enter the Date You Wish to Bring a Snack.'
    puts 'Please use the format YYYY-MM-DD.'
    puts

    date_is_invalid = true
    while date_is_invalid
      date = gets.chomp
      if !SnackDate.find_by(date: date) == false
        puts 'This date is already taken.  Please choose another date.'
      else
        if valid_date(date)
          # snackdate = SnackDate.update(snackdate.id, date: date)
          date_is_invalid = false
        else
          puts ''
          puts 'You have entered an invalid date format, or a date that occurs on a weekend.  Please enter YYYY-MM-DD'
        end
      end
    end
    date
  end

  def self.grab_user_snack
    puts
    puts 'Choose the Snack You Will Bring From the List Below:'
    puts
    Snack.all.each_with_index do |snack, index|
      puts "#{index + 1} - #{snack.name.capitalize}"
    end
    snack_invalid = true
    while snack_invalid
      snack_input = gets.to_i
      if snack_input.between?(1, Snack.all.length)
        snack = Snack.all[snack_input - 1]
        snack_invalid = false
      else
        puts
        puts "Please enter a valid number between 1 and #{Snack.all.length}."
      end
    end
    snack
  end

  def self.delete(snackdate)
    SnackDate.delete(snackdate.id)
  end

  # takes in an argument of a date and
  def self.valid_date(date)
    date = Date.parse(date)
    if date.wday.between?(1, 5)
      true
    else
      false
    end
  rescue ArgumentError
    false
  end

  def self.snacktime_header
    puts `clear`
    puts SNACKTIME
  end
end
