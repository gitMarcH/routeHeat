routeHeat - README
==============

License - GNU General Public License, Version3
--------------
Copyright (C) 2014 Marc Henrion

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

Summary
--------------

routeHeat allows you to use all your GPS activity files (currently only GPX and Garmin FIT formats are supported) and plot them in transparent colours onto a background. The transparency means that routes run/walked more often will be coloured more vividly. If you run often in a town or city, you should start recognising the roads from that city - as if it were a map.

These two scripts run as part of a web app at [routeHeat](http://marc-henrion.dyndns.org/routeHeat.html).

Dependencies (need to be installed and added to the $PATH variable)
--------------

bash - www.gnu.org/s/bash/

R - www.r-project.org; does not depend on any specific version, but requires the graphics library with most standard graphic devices (pdf, png, svg) supported

gpsbabel - www.gpsbabel.org; for converting FIT files to GPX

R library 'animation' [only if outputting animated gifs]

ImageMagick [only if outputting animated gifs; specifically 'convert' needs to be in your path]

Usage
--------------
routeHeat.sh \
    name_of_output_file \
    background_colour \
    line_colour \
    path_and_filename_for_temporary_files \
    latitude_minimum \
    latitude_maximum \
    longitude_minimum \
    longitude_maximum \
    line_width \
    line_transparency \
    output_format \
    use_map_or_not \
    path_and_filename_prefix_of_input_files

where:
	name_of_output_file = (character string) name of output file
	background_colour = (character; colour name or hex code) colour for background
	line_colour = (character; colour name or hex code) colour for drawing run paths
	path_and_filename_for_temporary_files = (character; filename with [optionally] path) gets used to build up a concatenated version of the GPS coordinates; NB file will be deleted at the end
	latitude_minimum & latitude_maximum = (numeric) lower (south) and upper (north) bounds in latitude for the plotted region
	longitude_minimum & longitude_maximum = (numeric) lower (east) and upper (west) bounds in longitude for the plotted region
	line_width = (numeric) thickness of the lines; NB the more paths you plot the lower you want this value to be
	line_transparency = (numeric between 0 [invisible] and 1 [fully opaque]) sets the transperency of the run paths; the more runs you plot, the lower your value should be
	out_put format = (comma-separated list of character strings); one of svg, png, pdf, animGIF or any combination thereof (e.g. svg,png,animGIF)
	use_map_or_not = (binary); should a map be plotted underneath, 0 = FALSE, 1 = TRUE; NB experimental feature; does not work well with svg output; your plotted region might change slightly
	path_and_filename_prefix_of_input_files = (character string; path + filename prefix); all files within that directory and with that fileprefix will be used (e.g. /Users/user/myruns/2014*)
	

NB if latitude and longitude limits should be computed from the input files then set min and max values to the same numeric value
NBB transparency is a number between 0 [invisible or fully transparent] and 1 [not transparent at all]
NBBB animGIF will provide 3 different GIF animations; the parameters of these (e.g. speed of animation etc) are hard-coded in the R script for now
