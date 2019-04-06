# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Commands:
- bundle update
- git push heroku master
- rails s
- rails c
- heroku logs --tail
- heroku run rake db:migrate
- heroku run rake sniffer:braacket
- heroku run rake sniffer:smash_gg
- heroku run rake sniffer:toornament

Links:
- https://ssb-tournament-manager.herokuapp.com
- https://swisssmash.ch
- https://challonge.com
- https://smash.gg
- https://braacket.com/
- https://www.toornament.com/
- http://sac-bern.ch

Queries:
- Players that haven't joined a tournament yet: ```Player.includes(:tournaments).where(tournaments: {id: nil})```
