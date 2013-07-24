class Player

  Directions = [ :forward, :backward]

  def initialize
    @previous_health ||= 20
    @low_health = 19
    @critical_health = 10
  end



  def health_is_critical?
    @warrior.health < @critical_health
  end

  def health_is_low?
    @warrior.health < @low_health
  end

  def safe?
    range_check(:forward) && range_check(:backward) && health_is_low? && !under_attack?
  end

  def danger?
    under_attack? && health_is_critical? #&& !warrior.feel.empty?
  end

  def is_wall?
    @warrior.feel.wall?
  end
# warrior.look(direction).select{|a| a.enemy?}.size
  def range_check direction
    warrior.look(direction).select{|a| a.enemy?}
  end

  def clear direction
    enemies = warrior.look(direction).select{|a| a.enemy?}.size
    true if enemies < 1
  end

  def first_law_check? direction
      puts @warrior.look(direction)
      first_target = @warrior.look(direction).select{|a| !a.empty?}.first
      if first_target == "Captive"
        return false
      else
        return true
      end
  end

  def feel_for_captive direction
    if @warrior.feel(direction).captive?
      @warrior.rescue!(direction)
    elsif
      @warrior.walk!(direction)
    end
  end

  def murder
    if first_law_check?(:forward) == false
      feel_for_captive(:forward)
    elsif first_law_check?(:backward) == false
      feel_for_captive(:backward)
    elsif warrior.feel && range_check(:backward)
      warrior.shoot!(:backward)
    elsif warrior.feel && @warrior.look(direction).select{|a| !a.empty?}.first != "Thick Sludge"
      warrior.shoot!(:forward)
    elsif
      warrior.attack!
    end
  end

  def warrior
    @warrior
  end


  def play_turn(warrior)
    @warrior = warrior
    if is_wall?
      warrior.pivot!
    elsif danger?
      warrior.walk!(:backward)
    elsif safe?
      warrior.rest!
    elsif range_check(:forward) && !clear(:forward)
      murder
    elsif range_check(:backward) && !clear(:backward)
      # warrior.pivot!
    elsif
      warrior.walk!
    end
  @previous_health = warrior.health
  end#play turn
end#class Player
