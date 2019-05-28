class Cli

  def self.welcome
    puts "Welcome to Ms. Heidi's Snack List."
  end

  def self.get_lastname
    puts "Please enter your child's last name"
    lastname = gets.chomp
  end

  def self.verify_lastname(lastname)
    Child.find_by(last_name: lastname)
  end

  def self.nav_options
    puts "1. Create"
    puts "2. Read"
    puts "3. Update"
    puts "4. Delete"
    puts "5. Quit"
    puts "Please Type Option 1, 2, 3, 4, or 5."
    optionchoice = gets.to_i
    if optionchoice.between?(1,5)
      return optionchoice
    else
      puts "You have made a titanic error in judgement.  I'm surprised your child can read."
      puts "Please make a sane selection."
      self.nav_options
    end
  end




end
