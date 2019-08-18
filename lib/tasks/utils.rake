namespace :utils do

  desc "Removes registration, matches and result from given tournament and player"
  task :remove_player_from_finished_tournament, [:t_id, :p_id] => :environment do |t, args|
    args.with_defaults(t_id: nil, p_id: nil)
    if args.t_id.nil? or args.p_id.nil?
      puts "  invalid params! Call => rake utils:remove_player_from_finished_tournament[<t_id>,<p_id>]\n\n"
      return
    end
    t_id = args.t_id
    p_id = args.p_id
    puts 'find & delete registration...'
    Registration.where(tournament_id: t_id).find_by(player_id: p_id).delete
    puts 'find & delete matches...'
    Match.where(tournament_id: t_id).where(player1_id: p_id).destroy_all
    Match.where(tournament_id: t_id).where(player2_id: p_id).destroy_all
    puts 'find result...'
    r = Result.where(tournament_id: t_id).find_by(player_id: p_id)
    puts 'update player...'
    p = Player.find(p_id)
    p.points -= r.points
    p.participations -= 1
    p.wins -= r.wins
    p.losses -= r.losses
    p.save!
    puts 'delete result...'
    r.delete
    puts 'find tournament...'
    t = Tournament.find(t_id)
    puts 'update ranking_string...'
    if t.ranking_string.include?(p.gamer_tag)
    	arr = t.ranking_string.split(';')
    	arr.each_with_index do |a, i|
    		arr.delete_at(i) if a.include?(p.gamer_tag)
    	end
    	t.ranking_string = ""
    	arr.each {|a| t.ranking_string += "#{a};"}
    	t.save!
    end
    puts 'done'
  end

end
