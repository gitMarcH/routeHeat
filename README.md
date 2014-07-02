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

Dependencies
--------------

bash - www.gnu.org/s/bash/
R - www.r-project.org; does not depend on any specific version, but requires the graphics library with most standard graphic devices (pdf, png, svg) supported
gpsbabel - www.gpsbabel.org; for converting FIT files to GPX

Usage
--------------
routeHeat name_of_output_file background_colour line_colour path_and_filename_for_temporary_files latitude_minimum latitude_maximum longitude_minimum longitude_maximum line_wdith line_transparency output_format path_and_filename_prefix_of_input_files

NB if latitude and longitude limits should be computed from the input files then set min and max values to the same numeric value
NBB transparency is a number between 0 [invisible or fully transparent] and 1 [not transparent at all]