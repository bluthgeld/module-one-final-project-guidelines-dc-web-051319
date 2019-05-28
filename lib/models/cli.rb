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

  def nav_options
    puts "1. Create"
    puts "2. Read"
    puts "3. Update"
    puts "4. Delete"
    puts "Please Type Option 1, 2, 3, or 4."
    optionchoice = gets.chomp
  end

end
