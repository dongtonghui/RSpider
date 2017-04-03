R语言（代码）爬虫项目
转载 2016-07-10 19:09:09
标签：itr语言人工智能数据分析数据挖掘
本文以爬取热门手机型号为例


##1.首先加载爬虫包

library(RCurl)

library(XML)

library(reshape)​

##2.伪装表头，目的在于对方的服务器识别不到你真正的信息

myheader=c(

  "User-Agent"="Mozilla/5.0(Windows;U;Windows NT 5.1;zh-CN;rv:1.9.1.6",

  "Accept"="text/htmal,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",

  "Accept-Language"="en-us",

  "Connection"="keep-alive",

  "Accept-Charset"="GB2312,utf-8;q=0.7,*;q=0.7"

)

##3.写地址​

a00url<-"http://detail.zol.com.cn/cell_phone_index/subcate57_list_0-1000_1.html"

temp<-getURL(a00url,httpheader=myheader,.encoding="gb2312")

##4.进行转码

temp1<-iconv(temp,"gb2312","UTF-8") #转码

Encoding(temp1) #UTF-8

k<-htmlParse(temp1,asText=T,encoding="UTF-8") #选择UTF-8进行网页的解析

​##5.写出想抓取的地方

tables<-readHTMLTable(k,header=F)

###此处​//h3/a/text()是爬取源代码此处的唯一text
model<-getNodeSet(k,'//h3/a/text()')

a00<-sapply(model,xmlValue) #从XMLNodeSet转化为character格式

a00<-as.data.frame(a00)

a00<-rename(a00,c(a00="model")) #重命名列名

data1<-a00

##6做一个目标网页的字典表，字典表为不同价格的前1-5页，效果如下

series<-c("1000","1500","2000","2500","3000","4000")

page_num <- 1:5

urllist<-0

k<-1

url<-"http://detail.zol.com.cn/cell_phone_index/subcate57_list_"

output <- list()

for(i in 1:length(series))

{

  for (j in 1:length(page_num))

{

  urllist[j]<-paste0(url,series[i],"_",page_num[j],".html",sep="")

}

output[[k]] <- urllist

k <- k + 1

}

output <-unlist(output)

​##7循环爬取网页目标

​for (i in 1:length(output))

{

    url<-output[i]

  temp<-getURL(url,httpheader=myheader,.encoding="gb2312")

  temp1<-iconv(temp,"gb2312","UTF-8") #转码

  k<-htmlParse(temp1,asText=T,encoding="UTF-8") #选择UTF-8进行网页的解析

  model<-getNodeSet(k,'//h3/a/text()')

  table<-sapply(model,xmlValue) #从XMLNodeSet转化为character格式

  table<-as.data.frame(table)

  table<-rename(table,c(table="model")) #重命名列名

  data2<-table

  data1<-rbind(data1,data2)

}