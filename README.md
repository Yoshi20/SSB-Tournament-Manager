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
- git push stage_ch <branch>:master
- heroku logs --tail --remote stage_ch
- heroku run rake db:migrate --remote stage_ch
- heroku run rails c --remote stage_ch
- heroku restart --remote stage_ch

- heroku run rake tournaments_crawler_ch:all --remote stage_ch
- heroku run rake tournaments_crawler_de:all --remote stage_ch
- heroku run rake tournaments_crawler_fr:all --remote stage_ch
- heroku run rake results_crawler_ch:all --remote stage_ch
- heroku run rake results_crawler_de:all --remote stage_ch
- heroku run rake results_crawler_fr:all --remote stage_ch
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote stage_ch

Prod commands:
- git push prod_ch master
- git push prod_de master
- git push prod_fr master
- heroku logs --tail --remote prod_ch
- heroku run rake db:migrate --remote prod_ch
- heroku run rails c --remote prod_ch
- heroku restart --remote prod_ch

- heroku run rake tournaments_crawler_ch:all --remote prod_ch
- heroku run rake tournaments_crawler_de:all --remote prod_ch
- heroku run rake tournaments_crawler_fr:all --remote prod_ch
- heroku run rake results_crawler_ch:all --remote prod_ch
- heroku run rake results_crawler_de:all --remote prod_ch
- heroku run rake results_crawler_fr:all --remote prod_ch
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]" --remote prod_ch

General links:
- https://swisssmash.herokuapp.com
- https://www.ssb-club-bern.ch
- https://www.swisssmash.ch
- https://germanysmash.herokuapp.com
- https://www.germanysmash.de
- https://francesmash.herokuapp.com
- https://www.smashultimate.fr
- https://challonge.com
- https://braacket.com/league/ALLOFTHEM/tournament?rows=200
- https://braacket.com/league/SSBUCHPRs/tournament?rows=200

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
