#!/usr/local/bin/python3

"""
converts an svg file produced by routeHeat into an animated SVG object inside an HTML document
parses the original routeHeat produced svg file [will not work for some outside produced svg files that contain multiple <rect> or <path> elements] and hacks together an animated svg/html document
animation is done via CSS and basically just fakes the route running animation with stroke length and offset values
"""

import xml.etree.ElementTree as etree
import sys
import math

##############################
## getting input parameters ##
##############################

fileIn=sys.argv[1]
fileOut=sys.argv[2]
animLength=sys.argv[3] # governs the time (in seconds) that the animation should run; in practice this will be affected by argument dashLength below
dashLength=sys.argv[4] # governs the length of each path segment that gets drawn; will affect the overall animation length; 5000 usually works fine
animStyle=sys.argv[5] # one of 'sequence' or 'simultaneous' [NB if anything other than 'sequence' is specified, 'simultaneous' is assumed]

#############################
## open output for writing ##
#############################

namespace='{http://www.w3.org/2000/svg}'

if animStyle == "sequence":
    tree=etree.parse(fileIn)
    root=tree.getroot()
    countPath=0
    for svgPath in root.iter(namespace + 'path'):
        countPath+=1

fOut=open(fileOut, 'w')

fOut.write("<!DOCTYPE html>\n")
fOut.write("<html>\n\n")
fOut.write("\t<head>\n")
fOut.write("\t\t<style type=\"text/css\">\n")
fOut.write("\t\t\tpath {\n")
fOut.write("\t\t\t\tstroke-dasharray: "+dashLength+";\n")
fOut.write("\t\t\t\tstroke-dashoffset: "+dashLength+";\n")
fOut.write("\t\t\t\tanimation: dash " + animLength + "s linear forwards;\n")
fOut.write("\t\t\t\t-webkit-animation: dash " + animLength + "s linear forwards;\n")
fOut.write("\t\t\t}\n\n")
if animStyle == "sequence":
    for i in range(1,countPath):
        tmpDelay=float(i)*float(animLength)/float(countPath)
        fOut.write("\t\t\tpath:nth-child("+str(i)+"){animation-delay:"+str(tmpDelay)+"s;}\n")
    fOut.write("\n")
fOut.write("\t\t\t@keyframes dash {\n")
fOut.write("\t\t\t\tfrom {\n")
fOut.write("\t\t\t\t\tstroke-dashoffset: "+dashLength+";\n")
fOut.write("\t\t\t\t}\n")
fOut.write("\t\t\t\tto {\n")
fOut.write("\t\t\t\t\tstroke-dashoffset: 0;\n")
fOut.write("\t\t\t\t}\n")
fOut.write("\t\t\t}\n\n")
fOut.write("\t\t\t@-webkit-keyframes dash {\n")
fOut.write("\t\t\t\tfrom {\n")
fOut.write("\t\t\t\t\tstroke-dashoffset: "+dashLength+";\n")
fOut.write("\t\t\t\t}\n")
fOut.write("\t\t\t\tto {\n")
fOut.write("\t\t\t\t\tstroke-dashoffset: 0;\n")
fOut.write("\t\t\t\t}\n")
fOut.write("\t\t\t}\n")
fOut.write("\t\t</style>\n")
fOut.write("\t</head>\n\n")
fOut.write("\t<body>\n")


##################################
## open and parse the svg image ##
##################################

tree=etree.parse(fileIn)
root=tree.getroot()

svgWidth=root.get('width')
svgHeight=root.get('height')
svgViewBox=root.get('viewBox')
svgVersion=root.get('version')
fOut.write("\t\t<svg width=\""+svgWidth+"\" height=\""+svgHeight+"\" viewBox=\""+svgViewBox+"\" version=\""+svgVersion+"\">\n")
fOut.write("\t\t\t<g>\n")

for svgRect in root.iter(namespace + 'rect'):
    rectX=svgRect.get('x')
    rectY=svgRect.get('y')
    rectWidth=svgRect.get('width')
    rectHeight=svgRect.get('height')
    rectStyle=svgRect.get('style')

    fOut.write("\t\t\t\t<rect x=\""+rectX+"\" y=\""+rectY+"\" width=\""+rectWidth+"\" height=\""+rectHeight+"\" style=\""+rectStyle+"\" />\n")

for svgPath in root.iter(namespace + 'path'):
    pathD=svgPath.get('d')
    pathStyle=svgPath.get('style')

    fOut.write("\t\t\t\t<path style =\""+pathStyle+"\" d=\""+pathD+"\" />\n")

fOut.write("\t\t\t</g>\n")
fOut.write("\t\t</svg>\n")


#########################
## closing output file ##
#########################

fOut.write("\t</body>\n\n")
fOut.write("</html>\n")
fOut.close()
