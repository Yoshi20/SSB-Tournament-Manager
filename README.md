# SSB-Tournament-Manager
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Links:
- https://ssb-tournament-manager.herokuapp.com
- https://swisssmash.ch
- https://challonge.com
- https://smash.gg
- https://braacket.com/
- http://sac-bern.ch

Queries:
- Players that haven't joined a tournament yet: ```Player.includes(:tournaments).where(tournaments: {id: nil})```
