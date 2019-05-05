# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Commands:
- bundle update
- git push heroku master
- rails s
- rails c
- heroku logs --tail
- heroku run rake db:migrate
- heroku run rake sniffer:all
- (heroku run rake sniffer:braacket)
- (heroku run rake sniffer:smash_gg)
- (heroku run rake sniffer:toornament)
- heroku restart

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
