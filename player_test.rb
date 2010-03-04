require 'test/unit'
require 'player'

class PlayerTest < Test::Unit::TestCase
  
  def test_player_initialization
    p = Player.find(8455710)
    assert_equal p.nhl_id, 8455710
  end

  def test_player_not_found
    assert_raise(PlayerNotFound) { Player.find(123) }
  end

  def test_player_attribute_regex
    p = Player.find(8455710)
    assert_equal p.name, "Martin Brodeur"
    assert_equal p.shoots, "Left"
    assert_equal p.birthdate, Date.parse('May 6, 1972')
    assert_equal p.birthplace, "Montreal, QC, Canada"
    # TODO match formats instead of values for variable data
    assert_equal p.position, "Goalie"
    assert_equal p.number, "30"
    assert_equal p.team, "Devils"
    assert_equal p.height, "6' 2\""
    assert_equal p.weight, "215"
  end

end