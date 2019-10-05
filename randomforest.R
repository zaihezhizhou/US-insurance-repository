install.packages("randomForest")
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
ori_data$diq010<- factor(ori_data$diq010,levels=c(0,1),labels=c("No","Yes"))
#处理缺失值#
is.na(ori_data$diq010)
#为存在缺失值的数据集进行插补（随机森林法），得到最优的样本拟合值#
new.data<-rfImpute(ori_data,ori_data$diq010, iter=5, ntree=300)
new.data<-new.data[,3:54]
#随机森林#
output.forest<-randomForest(diq010~.,data=new.data)
# View the forest results.
print(output.forest) 

# Importance of each predictor.
print(importance(output.forest,type = 2))
varImpPlot(output.forest, main = 'Top variable importance')
importance.data<-data.frame(importance(output.forest,type=2))
write.csv(importance.data, "C:/usdata/importance.data.csv")

top10.data<-new.data[,c("diq010","diq175t","diq175h","diq175x","diq175i","diq175u","diq175s","diq175m","diq175c","diq175q","diq175k")]

