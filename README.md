# Razzball Underdog helper

## Steps:

1. Download today's hitter projections from Razzball's Hittertron, and today's pitcher projections from Streamonator. Save them in `app/data/` as `hitters.csv` and `pitchers.csv`, respectively.
2. Download the proper slate's rankings CSV from Underdog, save it in `app/data/` as `underdog.csv`
3. From the command line in the app root, run `bin/rails run`. The output will be saved as `app/data/rankings.csv`.
4. Upload `rankings.csv` to Underdog.
5. Profit!
