# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Local commands:
- bundle update
- rake db:migrate
- rake db:rollback
- rails s
- rails c

- dropdb ssb-tournament-manager_development
- heroku pg:pull <postgresql-name> ssb-tournament-manager_development --app ssb-tournament-manager

- heroku pg:reset --app ssb-tournament-manager-stage --confirm ssb-tournament-manager-stage
- heroku pg:push ssb-tournament-manager_development <postgresql-name> --app ssb-tournament-manager-stage

Stage commands:
- git push stage master
- heroku logs --tail --remote stage
- heroku run rake db:migrate --remote stage
- heroku run rails c --remote stage
- heroku restart --remote stage

Prod commands:
- git push prod master
- heroku logs --tail --remote prod
- heroku run rake db:migrate --remote prod
- heroku run rails c --remote prod
- heroku restart --remote prod

- heroku run rake sniffer:all
- (heroku run rake sniffer:braacket)
- (heroku run rake sniffer:smash_gg)
- (heroku run rake sniffer:toornament)

Links:
- https://ssb-tournament-manager.herokuapp.com
- https://ssb-club-bern.ch
- https://swisssmash.ch
- https://challonge.com
- http://sac-bern.ch

Sniffer Links:
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22CH%22}
- https://braacket.com/tournament/search?rows=100&country=ch&game=ssbu&status=1
- https://www.toornament.com/tournaments/?q[discipline]=supersmashbros_ultimate&q[platform]=nintendo_switch&q[type]=upcoming

Icons:
- https://www.ssbwiki.com/Category:Head_icons_(SSBU)

Queries:
- Players that haven't joined a tournament yet: ```Player.includes(:tournaments).where(tournaments: {id: nil})```
