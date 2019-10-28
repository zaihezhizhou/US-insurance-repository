library(deepnet)
library(igraph)
library(randomForest)
###��������###
library(foreign)
library(Hmisc)
ori_data<-sasxport.get("c:/usdata/DIQ_I.XPT")
###�۲�����###
head(ori_data)
str(ori_data)
dim(ori_data)
###��DIQ010ת��Ϊ����ֵ���###
ori_data$diq010[ori_data$diq010 ==1] <-1
ori_data$diq010[ori_data$diq010 !=1] <-0

#����ȱʧֵ#
is.na(ori_data$diq010)
#Ϊ����ȱʧֵ�����ݼ����в岹�����ɭ�ַ������õ����ŵ��������ֵ#
new.data<-rfImpute(ori_data,ori_data$diq010, iter=5, ntree=300)
new.data<-new.data[,3:54]
##Compress to 10 feature in middle level in autoencoder##
x<-as.matrix(new.data[,2:52])
y<-as.vector(new.data[,1])
dnn <- sae.dnn.train(x, y, hidden = c(10))
nn.test(dnn,x,y)