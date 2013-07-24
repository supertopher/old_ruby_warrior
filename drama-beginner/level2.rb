class Player

  def initialize
    @previous_health = 20
    @low_health = 10
    @critical_health = 3
  end

  def under_attack?
    @warrior.health < @previous_health
  end

  def health_is_critical?
    @warrior.health < @critical_health
  end

  def health_is_low?
    @warrior.health <= @low_health
  end


  def play_turn(warrior)
    @warrior = warrior
    if under_attack? && health_is_critical?
      warrior.walk!(:backward)
    elsif warrior.feel.empty? && health_is_low?
      warrior.rest!
    elsif warrior.feel.empty?
      warrior.walk!
    elsif
      warrior.attack!
    end
  @previous_health = warrior.health
  end#play turn
end#class Player
