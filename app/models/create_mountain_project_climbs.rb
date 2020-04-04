class CreateMountainProjectClimbs
  def initialize(person)
    @person = person
  end

  def call!
    raise(ArgumentError, "Mountain Project user ID required") if @person.mountain_project_user_id.blank?
    raise(ArgumentError, "MOUNTAIN_PROJECT_KEY required") if key.blank? && !Rails.env.test?

    uri = URI("https://www.mountainproject.com/data/get-ticks?userId=#{@person.mountain_project_user_id}&key=#{key}")
    response = Net::HTTP.get(uri)

    ticks = new_ticks(JSON.parse(response))
    route_ids = route_ids(ticks)
    uri = URI("https://www.mountainproject.com/data/get-routes?routeIds=#{route_ids}&key=#{key}")
    response = Net::HTTP.get(uri)

    ticks = add_routes(ticks, JSON.parse(response))
    ticks = remove_duplicates(ticks)
    create_climbs ticks
  end

  private

  def add_routes(ticks, json)
    routes = json["routes"]

    ticks.each do |tick|
      route = routes.detect { |r| r["id"] == tick["routeId"] }
      tick["name"] = route["name"]
      tick["rating"] = route["rating"]
      tick["routeId"] = route["id"]
      tick["type"] = route["type"]
    end
  end

  def create_climbs(ticks)
    ticks = ticks.reject { |tick| tick["rating"]["V"] }

    ticks.each do |tick|
      Climb.create!(
        climbed_on: tick["date"],
        discipline: discipline(tick),
        grade: tick["rating"],
        mountain_project_pitches: tick["pitches"],
        mountain_project_user_stars: tick["userStars"],
        mountain_project_lead_style: tick["leadStyle"],
        mountain_project_notes: tick["notes"],
        mountain_project_style: tick["style"],
        mountain_project_type: tick["type"],
        mountain_project_user_rating: tick["userRating"],
        mountain_project_route_id: tick["routeId"],
        mountain_project_tick_id: tick["tickId"],
        name: tick["name"]
      )
    end
  end

  def discipline(tick)
    style = tick["style"]
    type = tick["type"]
    key = "#{style}-#{type}".to_sym
    discipline = discipline_map[key]

    raise("No discipline found for #{key}") unless discipline

    discipline
  end

  def discipline_map
    @discipline_map ||= {
      "Lead-Trad": Discipline.find_by!(name: "Trad"),
      "TR-Trad": Discipline.find_by!(name: "Outdoor Top Rope"),
      "TR-Trad, TR": Discipline.find_by!(name: "Outdoor Top Rope"),
      "TR-Sport": Discipline.find_by!(name: "Outdoor Top Rope"),
      "TR-Sport, TR": Discipline.find_by!(name: "Outdoor Top Rope"),
      "TR-TR": Discipline.find_by!(name: "Outdoor Top Rope"),
      "TR-Trad, Sport": Discipline.find_by!(name: "Outdoor Top Rope"),
      "-TR": Discipline.find_by!(name: "Outdoor Top Rope"),
      "Lead-Sport": Discipline.find_by!(name: "Outdoor Lead"),
      "Lead-Sport, TR": Discipline.find_by!(name: "Outdoor Lead"),
      "Flash-Boulder": Discipline.find_by!(name: "Outdoor Boulder"),
      "Send-Boulder": Discipline.find_by!(name: "Outdoor Boulder")
    }
  end

  def key
    ENV["MOUNTAIN_PROJECT_KEY"]
  end

  def new_ticks(json)
    json["ticks"].reject do |tick|
      tick["leadStyle"][/Fell/] ||
        tick["style"][/Follow/] ||
        Climb.where(mountain_project_tick_id: tick["tickId"]).exists?
    end
  end

  def remove_duplicates(ticks)
    keys = Set.new

    unique_ticks = []
    ticks.sort_by { |tick| tick["date"] }.each do |tick|
      key = [tick["routeId"], tick["leadStyle"], tick["style"]]
      next if keys.include?(key)

      keys << key
      unique_ticks << tick
    end


    unique_ticks
  end

  def route_ids(json)
    json.map { |r| r["routeId"] }.join(",")
  end
end
