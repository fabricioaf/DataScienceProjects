# Random Forest Regression
rm(list = ls())   #limpa o workspace
cat("\014")       #limpa o console

# importa base de dados
setwd("C:\\Users\\Arthur Silveira\\Documents\\Arthur\\Meus Documentos\\P�s\\M�dulo II\\DM\\(OK) Aulas 11 e 12")
dataset = read.csv('50_Startups.csv')
View(dataset)
dataset = dataset[,-1]

# Divis�o em base de treino e teste
# install.packages('caTools')
#library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fit da Random Forest Regression 
# install.packages('randomForest')
library(randomForest)
set.seed(1234)
regressor = randomForest(x = training_set[-5],
                         y = training_set$Profit,
                         ntree = 1000,
                         mtry = 4)

#R2
y_teste = predict(regressor, test_set)
R2Teste = 1 - (sum((test_set$Profit - y_teste)^2) / 
                  sum((test_set$Profit - mean(test_set$Profit))^2)) ; R2Teste

# J� temos uma base de teste, n�o precisamos de um valor aleat�rio aqui
# Prever o resultado do modelo para um valor qualquer
# y_pred = predict(regressor, data.frame(Level = 6.5))

# Deletar essa parte, pois temos quatro vari�veis
# Visualizar resultado
# install.packages('ggplot2')
# library(ggplot2)
#x_grid = seq(min(dataset[-5]), max(dataset[-5]), 0.01)
#ggplot() +
#  geom_point(aes(x = dataset$Level, y = dataset$Salary),
#             colour = 'red') +
#  geom_line(aes(x = x_grid, y = predict(regressor, newdata = data.frame(Level = x_grid))),
#            colour = 'blue') +
#  ggtitle('Random Forest Regression') +
#  xlab('Level') +
#  ylab('Salary')

#gr�fico de barras do melhor modelo para a base de teste
counts <- rbind(y_teste, test_set$Profit)
barplot(counts, main="Previs�es X Targets (Base de Teste)",
        xlab="�ndice da linha de teste", col=c("darkblue","red"),
        beside=TRUE)
legend("topleft", legend = c("Previs�es", "Targets"),cex=0.5, fill=c("darkblue","red"))

#gr�fico de resultados
library(ggplot2)
targetForecast = data.frame(test_set$Profit, y_teste)
ggplot(targetForecast, aes(y_teste, test_set.Profit)) + geom_point()