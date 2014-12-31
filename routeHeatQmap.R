#License - GNU General Public License, Version 3
#--------------
#Copyright (C) 2014 Marc Henrion
#
#This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
#
#This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

#-----input arguments
args<-commandArgs(TRUE)
inFile<-args[1]
outPrefix<-args[2]
bgCol<-args[3]
trkCol<-args[4]
latMin<-as.numeric(args[5])
latMax<-as.numeric(args[6])
longMin<-as.numeric(args[7])
longMax<-as.numeric(args[8])
lwd<-as.numeric(args[9])
alpha<-as.numeric(args[10])
outFormat<-unlist(strsplit(split=",",args[11]))

#-----read the input data
inDat<-read.table(inFile,sep="\t",header=F,colClasses="numeric")

#-----load required libraries NB you need to have these installed!
library(ggplot2)
library(ggmap)

#-----check if latitude and longitude limits are given
if(latMin==latMax | is.na(latMin) | is.na(latMax)){
    ylim<-c(min(inDat[,1]),max(inDat[,1]))
}else{
    ylim<-c(latMin,latMax)
}
if(longMin==longMax | is.na(longMin) | is.na(longMax)){
    xlim<-c(min(inDat[,2]),max(inDat[,2]))
}else{
    xlim<-c(longMin,longMax)
}

aspRatio<-(max(xlim)-min(xlim))/(max(ylim)-min(ylim))

#-----do the plot
for(formatTmp in outFormat){
    
    outFile<-paste(sep="",outPrefix,".",formatTmp)
    
    if(formatTmp=="png"){
        png(outFile,width=5*aspRatio,height=5,units="in",res=150)
    }else if(formatTmp=="pdf"){
        pdf(outFile,width=10*aspRatio,height=10)
    }else if(formatTmp=="svg"){
        svg(outFile,width=10*aspRatio,height=10)
    }

    gpxDat<-data.frame(lat=inDat[,1],lon=inDat[,2],idx=inDat[,3])
    
    map<-qmap(extent='device',location=c(xlim[1],ylim[1],xlim[2],ylim[2]),zoom=12,scale=4,color='bw')
    gpxLines<-geom_path(data=gpxDat,aes(x=lon,y=lat,group=idx),colour=trkCol,alpha=alpha)
    plotTheme<-theme(plot.background=element_rect(fill=bgCol,color=bgCol),panel.background=element_rect(fill=bgCol))
    
    par(mar=c(0,0,0,0))
    print(map + gpxLines + plotTheme)
    dev.off()
}
