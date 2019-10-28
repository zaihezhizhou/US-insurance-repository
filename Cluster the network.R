library(deepnet)
library(igraph)
library(randomForest)
###导入数据###
library(foreign)
library(Hmisc)
ori_data<-sasxport.get("c:/usdata/DIQ_I.XPT")
###观察数据###
head(ori_data)
str(ori_data)
dim(ori_data)
###将DIQ010转化为二型值结果###
ori_data$diq010[ori_data$diq010 ==1] <-1
ori_data$diq010[ori_data$diq010 !=1] <-0

#处理缺失值#
is.na(ori_data$diq010)
#为存在缺失值的数据集进行插补（随机森林法），得到最优的样本拟合值#
new.data<-rfImpute(ori_data,ori_data$diq010, iter=5, ntree=300)
new.data<-new.data[,3:54]
##Compress to 10 feature in middle level in autoencoder##
x<-as.matrix(new.data[,2:52])
y<-as.vector(new.data[,1])
dnn <- sae.dnn.train(x, y, hidden = c(10))
nn.test(dnn,x,y)
