class Player

  # require 'sense.rb'

  attr_accessor :warrior

  def initialize
    @direction = :forward
    @previous_health = 20 #refreshed at the end of every turn
    @low_health = 10
  end

  def under_attack
    if @previous_health > @warrior.health
      true
    else
      false
    end
  end

  def health_low
    if @warrior.health < @low_health
      true
    end
  end

  def rescue_peon
    if @warrior.feel(@direction).captive?
      @warrior.rescue(@direction)
      return true
    end
  end

  def feel_around
    unless @warrior.feel || rescue_peon
      @warrior.attack!(@direction)
    else
      false
    end
  end

  def retreat
    unless rescue_peon || @warrior.feel.backward.wall?
      @warrior.walk!(:backward)
    else
      @warrior.rest!
    end
    @played = true
  end

  def captive_present
    if @warrior.feel@direction
      @warrior.rescue@direction
    end
  end

  def play_turn(warrior)
    @played = false
    @warrior = warrior
    feel_around
    if health_low && under_attack
      retreat
    else
      warrior.walk! unless @played == false
    end #em && !rescue_peonpty walk check
    @previous_health = warrior.health
  end#player turn
end
