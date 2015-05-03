cd /data/work/routeHeat/routeHeat_NY

rsync -vu /data/pytrainer/activities/2014-11*gpx gpx/
rsync -vu /data/pytrainer/activities/2014-12*gpx gpx/
rsync -vu /data/pytrainer/activities/2015*gpx gpx/

/data/work/routeHeat/routeHeat.sh nycRouteHeat grey darkblue tmp 40.685 40.878 -74.02 -73.909 0.35 0.5 svg 0 gpx/
/data/work/routeHeat/routeHeat.sh nycRouteHeat grey darkblue tmp 40.685 40.878 -74.02 -73.909 0.4 0.25 png 0 gpx/
/data/work/routeHeat/routeHeat.sh nycRouteHeat grey darkblue tmp 40.685 40.878 -74.02 -73.909 0.3 0.3 pdf 0 gpx/
/data/work/routeHeat/routeHeat.sh nycRouteHeat grey darkblue tmp 40.685 40.878 -74.02 -73.909 0.6 0.4 animGIF 0 gpx/
