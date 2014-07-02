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

#-----convert track colour to RGB
trkCol<-as.vector(col2rgb(trkCol))

#-----do the plot
for(formatTmp in outFormat){

outFile<-paste(sep="",outPrefix,".",formatTmp)

if(formatTmp=="pdf"){
    pdf(outFile,width=10*aspRatio,height=10)
}else if(formatTmp=="png"){
    png(outFile,width=5*aspRatio,height=5,units="in",res=150)
}else if(formatTmp=="svg"){
    svg(outFile,width=10*aspRatio,height=10)
}

par(bg=bgCol,mar=c(0,0,0,0))

plot(type="n",asp=1,x=0,y=0,axes=F,xlim=xlim,ylim=ylim,xlab="",ylab="",main="",)
for(i in unique(inDat[,3])){
    idx<-which(inDat[,3]==i & inDat[,4]==0)
    lines(inDat[idx,2],inDat[idx,1],col=rgb(red=trkCol[1],green=trkCol[2],blue=trkCol[3],alpha=round(alpha*255),maxColorValue=255),lwd=lwd)
    #idx<-which(inDat[,3]==i & inDat[,4]==1)
    #points(inDat[idx,2],inDat[idx,1],col="black",pch=1)
    #idx<-which(inDat[,3]==i & inDat[,4]==2)
    #points(inDat[idx,2],inDat[idx,1],col="black",pch=2)
}
dev.off()
}


