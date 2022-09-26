# SwissSmash
Simple tournament manager for Super Smash Bros. matches (Ruby on Rails project)

Local commands:
- bundle update
- rake db:migrate
- rake db:rollback
- rails s
- rails c

- dropdb swisssmash_development
- heroku pg:pull \<postgresql-name\> swisssmash_development --app swisssmash

- heroku pg:reset --app swisssmash-stage --confirm swisssmash-stage
- heroku pg:push swisssmash_development \<postgresql-name\> --app swisssmash-stage

Stage commands:
- git push stage_ch master
- git push stage_de master
- git push stage_fr master
- git push stage_lu master
- git push stage_it master
- git push stage_uk master
- git push stage_ch <branch>:master
- heroku logs --tail --remote stage_ch
- heroku run rake db:migrate --remote stage_ch
- heroku run rails c --remote stage_ch
- heroku restart --remote stage_ch

- heroku run rake tournaments_crawler_ch:all --remote stage_ch
- heroku run rake tournaments_crawler_de:all --remote stage_de
- heroku run rake tournaments_crawler_fr:all --remote stage_fr
- heroku run rake tournaments_crawler_lu:all --remote stage_lu
- heroku run rake tournaments_crawler_it:all --remote stage_it
- heroku run rake tournaments_crawler_uk:all --remote stage_uk
- heroku run rake tournaments_crawler_ie:all --remote stage_uk
- heroku run rake tournaments_crawler_im:all --remote stage_uk
- heroku run rake tournaments_crawler_pt:all --remote stage_pt
- heroku run rake results_crawler_ch:all --remote stage_ch
- heroku run rake results_crawler_de:all --remote stage_de
- heroku run rake results_crawler_fr:all --remote stage_fr
- heroku run rake results_crawler_lu:all --remote stage_lu
- heroku run rake results_crawler_it:all --remote stage_it
- heroku run rake results_crawler_uk:all --remote stage_uk
- heroku run rake results_crawler_pt:all --remote stage_pt
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote stage_ch

Prod commands:
- git push prod master
- heroku logs --tail --remote prod
- heroku run rake db:migrate --remote prod
- heroku run rails c --remote prod
- heroku restart --remote prod

- heroku run rake tournaments_crawler_ch:all --remote prod
- heroku run rake tournaments_crawler_de:all --remote prod
- heroku run rake tournaments_crawler_fr:all --remote prod
- heroku run rake tournaments_crawler_lu:all --remote prod
- heroku run rake tournaments_crawler_it:all --remote prod
- heroku run rake tournaments_crawler_uk:all --remote prod
- heroku run rake tournaments_crawler_ie:all --remote prod
- heroku run rake tournaments_crawler_im:all --remote prod
- heroku run rake tournaments_crawler_pt:all --remote prod
- heroku run rake results_crawler_ch:all --remote prod
- heroku run rake results_crawler_de:all --remote prod
- heroku run rake results_crawler_fr:all --remote prod
- heroku run rake results_crawler_lu:all --remote prod
- heroku run rake results_crawler_it:all --remote prod
- heroku run rake results_crawler_uk:all --remote prod
- heroku run rake results_crawler_pt:all --remote prod
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote prod

Note:  
UK also includes Ireland (IE) & Isle of Men (IM) in this application.

General links:
- https://swisssmash.herokuapp.com
- https://www.swisssmash.ch
- https://germanysmash.herokuapp.com
- https://www.germanysmash.de
- https://francesmash.herokuapp.com
- https://www.smashultimate.fr
- https://luxsmash.herokuapp.com
- https://www.luxsmash.lu
- https://italysmash.herokuapp.com
- https://www.italysmash.it
- https://uksmash.herokuapp.com
- https://www.smashultimate.uk
- https://www.smashultimate.co.uk
- https://www.smashbrosportugal.com
- https://challonge.com
- https://braacket.com/league/ALLOFTHEM/tournament?rows=200
- https://braacket.com/league/SSBUCHPRs/tournament?rows=200
- https://braacket.com/league/SSBUDEPRs/tournament?rows=200
- https://braacket.com/league/SSBUFRPRs/tournament?rows=200
- https://braacket.com/league/SSBUITPRs/tournament?rows=200
- https://braacket.com/league/SSBUUKPRs/tournament?rows=200
- https://braacket.com/league/Portugal/tournament?rows=200

Tournaments crawler links:
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22CH%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22DE%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22FR%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22LU%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22IT%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22GB%22}
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22PT%22}
- https://braacket.com/tournament/search?rows=100&country=ch&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=de&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=fr&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=it&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=lu&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=gb&game=ssbu&status=1
- https://braacket.com/tournament/search?rows=100&country=pt&game=ssbu&status=1
- https://www.toornament.com/tournaments/?q[discipline]=supersmashbros_ultimate&q[platform]=nintendo_switch&q[type]=upcoming

Twitch API:
- https://dev.twitch.tv/docs/api/reference#get-stream-key

Icons:
- https://www.ssbwiki.com/Category:Head_icons_(SSBU)

Banner:
- https://www.ssbwiki.com/Super_Smash_Bros._Ultimate

Google Analytics:
- https://analytics.google.com/analytics/web/#/report-home/a145089919w206718824p199562205

Roles overview:

|                       | news | communities | tournaments | teams | players | users | feedback | inactive tournaments | alts |
|-----------------------|------|-------------|-------------|-------|---------|-------|----------|----------------------|------|
| super_admin           | x    | x           | x           | x     | x       | x     | x        | x                    | x    |
| admin                 | x    | x           | x           | x     | x       |       |          |                      |      |
| news_editor           | x    |             |             |       |         |       |          |                      |      |
| community_editor      |      | x           |             |       |         |       |          |                      |      |
| tournament_organizer  |      |             | x           |       |         |       |          |                      |      |
| team_captain          |      |             |             | x     |         |       |          |                      |      |
