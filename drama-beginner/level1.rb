class Player

  def initialize
    @previous_health = 20

  end



  def play_turn(warrior)
    @warrior = warrior
    if warrior.feel.empty?
      warrior.walk!
    else
      warrior.attack!
    end
  end
end
