# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Local commands:
- bundle update
- rake db:migrate
- rake db:rollback
- rails s
- rails c

- dropdb ssb-tournament-manager_development
- heroku pg:pull \<postgresql-name\> ssb-tournament-manager_development --app ssb-tournament-manager

- heroku pg:reset --app ssb-tournament-manager-stage --confirm ssb-tournament-manager-stage
- heroku pg:push ssb-tournament-manager_development \<postgresql-name\> --app ssb-tournament-manager-stage

Stage commands:
- git push stage master
- git push stage <branch>:main
- heroku logs --tail --remote stage
- heroku run rake db:migrate --remote stage
- heroku run rails c --remote stage
- heroku restart --remote stage

- heroku run rake tournaments_crawler:all --remote stage
- heroku run rake results_crawler:all --remote stage
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote stage

Prod commands:
- git push prod master
- heroku logs --tail --remote prod
- heroku run rake db:migrate --remote prod
- heroku run rails c --remote prod
- heroku restart --remote prod

- heroku run rake tournaments_crawler:all --remote prod
- heroku run rake results_crawler:all --remote prod
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote prod

General links:
- https://ssb-tournament-manager.herokuapp.com
- https://www.ssb-club-bern.ch
- https://www.swisssmash.ch
- https://challonge.com
- http://sac-bern.ch
- https://braacket.com/league/ALLOFTHEM/tournament?rows=200
- https://braacket.com/league/SSBUCHS20-21/tournament?rows=200

Tournaments crawler links:
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22CH%22}
- https://braacket.com/tournament/search?rows=100&country=ch&game=ssbu&status=1
- https://www.toornament.com/tournaments/?q[discipline]=supersmashbros_ultimate&q[platform]=nintendo_switch&q[type]=upcoming

Icons:
- https://www.ssbwiki.com/Category:Head_icons_(SSBU)

Banner:
- https://www.ssbwiki.com/Super_Smash_Bros._Ultimate

Google Analytics:
- https://analytics.google.com/analytics/web/#/report-home/a145089919w206718824p199562205
