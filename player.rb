# Raised when player by given id cannot be found.
class PlayerNotFound < StandardError; end

# Creates NHL player objects from NHL.com data.
class Player

  require 'date'

  attr_reader :nhl_id, :rendered, :name, :team, :number, :height, :weight, :shoots, :position, :birthdate, :birthplace

  # Search nhl.com for matching player by NHL.com player id.
  def self.find(id)
    player = new(id)
    # Attempt player html download. Raise exception if download fails.
    raise PlayerNotFound, "Unable to find player with ID: #{id}" unless player.update
    # Return player.
    player
  end

  # Initialize player with NHL.com player id.
  def initialize(id)
    @nhl_id     = id
    @cache_file = "cache/#{@nhl_id}.html"
    @cahce_life = 24 * 60
  end

  # Update player html cache (if necessary), return html from cache
  def update
    download_page if cache_expired?
    read_cache
  end

private

  # Downloads player html
  def download_page
    true # TODO download and save html
  end

  # Reads cached player html
  def read_cache
    @html = File.read(@cache_file) if cache_exist?
    parse_html unless @html.nil?
  end

  # Checks if the cache is unavailable.
  def cache_expired?
    return true unless cache_exist?
    File.new(@cache_file).mtime < Time::now - (@cache_life.to_i * 60)
    # TODO check html rendered date
  end

  # Checks if cache exists.
  def cache_exist?
    File.exist?(@cache_file)
  end

  # Converts html to player attributes.
  def parse_html
    # regex matching for html as of May 2009
    @rendered       = Date.parse(@html.match(/Rendered:\s(.+)\s\s-->$/)[1]) # required
    @name           = @html.match(/NHL.com\s-\sPlayers:\s(.+),/)[1] # required
    @team           = @html.match(/NHL.com\s-\sPlayers:\s.+,\s(.+)\s-/)[1]
    @position       = @html.match(/^\s+(Defenseman|Left\sWing|Right\sWing|Center|Goalie)$/) ? $~[1] : nil
    @number         = @html.match(/NUMBER:\s<b>(\d+)<\/b>/) ? $~[1] : nil
    @height         = @html.match(/HEIGHT:\s<b>([0-9][0-9]?'\s[0-9][0-9]?")<\/b>/) ? $~[1] : nil
    @weight         = @html.match(/WEIGHT:\s<b>(\d+)<\/b>/) ? $~[1] : nil
    @shoots         = @html.match(/[Shoots|Catches]:\s<b>(Left|Right)<\/b>/) ? $~[1] : nil
    @birthdate      = @html.match(/BIRTHDATE:\s<b>(\w{3}\s\d{1,2},\s\d{4})/) ? Date.parse($~[1]) : nil
    @birthplace     = @html.match(/BIRTHPLACE:\s<b>([a-zA-Z\s]+[,\s]?[a-zA-Z\s]+[,\s]?[a-zA-Z\s\(\)]+)<\/b>/) ? $~[1] : nil
    # TODO draft year
    # TODO draft round
    # TODO NHL regular season stats
    # TODO NHL playoff stats
    # TODO mugshot url (http://cdn.nhl.com/photos/mugs/#{id}.jpg)
    @rendered
  end
  
end