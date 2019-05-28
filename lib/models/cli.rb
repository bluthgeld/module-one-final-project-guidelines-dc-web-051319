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

  end

end
