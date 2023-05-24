# Razzball -> Underdog Helper

## Steps:

0. Run `bundle` to install the necessary gems.
1. Download today's hitter projections from Razzball's Hittertron, and today's pitcher projections from Streamonator. Save them as `data/hitters.csv` and `data/pitchers.csv`, respectively.
2. Download the proper slate's rankings CSV from Underdog, save it as `data/underdog.csv`
3. From the command line in the app root, run `bin/rails run`. The output will be saved as `data/rankings.csv`.
4. Upload `rankings.csv` to Underdog.
5. Profit!
