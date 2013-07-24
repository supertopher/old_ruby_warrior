class Player
  def initialize
    @directions = [ :forward, :backward ]
    @previous_health ||= 20
    @low_health = 12 #heal up to this number
    @critical_health = 7 #find a safe location number
    @moved = false #ensures no second move is made... currently repeated... alot
    @melee_targets = []
    @ranged_targets = []
    @priority_list = ["Captive", "Wizard", "Archer"] #ranged only
  end

  def enemies #list of all targets
    @targets = []
    @directions.each do |current_direction|
      look current_direction
    end
  end

  def look direction #feeder action for enemies
    distance = 1
    enemy_list = warrior.look(direction)
    enemy_list.each do |mario|
      mario.to_s
      @targets << [mario, direction, distance]
      distance += 1
    end
  end

  def find_target #scrubs enemy list to remove "nothing" entries leaving a list of enemies
    @targets.each do |type, direction, distance|
      unless type.to_s == "nothing"
        if distance == 1
          @melee_targets << [type.to_s, direction]
        elsif distance > 1
          @ranged_targets  << [type.to_s, direction, distance]
        end
      end
    end
  end

  def melee_action #acttack or save units, avoid walls
    @melee_targets.each do |type, direction|
      if type == "Captive"
        warrior.rescue!(direction) unless @moved == true
        @moved = true
      elsif type == "wall" && warrior.feel.wall?
        warrior.pivot! unless @moved == true && under_attack?
        @moved = true
      elsif type != "wall"
        warrior.attack!(direction) unless @moved
        @moved = true
      end
    end
  end

  def ranged_action #if there is a captive move to it, otherwise kill target
    @priority_list.each do |priority|
      @ranged_targets.each do |type, direction, distance|
        if type == priority
          if type == "Captive"
            warrior.walk!(direction) unless @moved
            @moved = true
          else
            warrior.shoot!(direction) unless @moved == true
            @moved = true
          end
        end
      end
    end
  end

  def health_check #if underattack move, otherwise heal
    if @warrior.health < @critical_health && under_attack? && warrior.feel.wall? == false
      warrior.walk!(:backward) unless @moved == true
      @moved = true
    elsif @warrior.health < @low_health && under_attack? == false
      warrior.rest! unless @moved == true
      @moved = true
    end
  end

  def under_attack?
    @warrior.health < @previous_health
  end

  def warrior
    @warrior
  end

  def play_turn(warrior)
    initialize
    @warrior = warrior
    enemies
    find_target
    health_check
    melee_action
    ranged_action
    warrior.walk! unless @moved == true
    @previous_health = warrior.health
  end#play turn
end
