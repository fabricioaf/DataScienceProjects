# Regress�o Linear M�litpla
rm(list = ls())   #limpa o workspace
cat("\014")       #limpa o console

# importa base de dados
setwd("C:\\Users\\Arthur Silveira\\Dropbox\\Meus Documentos\\P�s\\M�dulo II\\DM\\Aulas 11 e 12")
dataset = read.csv('50_Startups.csv')
View(dataset)

# Saber a quantidade de estados que existe no vetor
str(dataset$State)
# Encoding vari�vel categ�rica
dataset$State = factor(dataset$State)
is.factor(dataset$State)
# Se quisermos fazer com dummy
# install.packages("psych")
# library(psych)
# a = dummy.code(dataset$State)
# dataset$State = NULL
# dataset = data.frame(dataset, a)

# Divis�o em base de treino e teste
# install.packages('caTools')
library(caTools)
set.seed(123)
split = sample.split(dataset$Profit, SplitRatio = 0.8)
training_set = subset(dataset, split == TRUE)
test_set = subset(dataset, split == FALSE)

# Fitting
# Ponto: usar todas as colunas (atributos)
regressor = lm(formula = Profit ~ ., data = training_set)

# modelo
# Os asteriscos ao lado do p-value indicam valores muito pr�ximos de zero
# (ou seja, atributos �teis ao modelo)
summary(regressor)

# previs�o da base de teste
y_pred = predict(regressor, newdata = test_set)

#R2
R2Test = 1 - (sum((test_set$Profit - y_pred )^2) / 
                sum((test_set$Profit - mean(test_set$Profit))^2)) ; R2Test
#R2 ajustado
numDados = nrow(test_set)
numDados
numRegressores = length(test_set) - 1
numRegressores
R2TestAdjusted = 1 - (1-R2Test)*(numDados-1)/
  (numDados-numRegressores-1) ; R2TestAdjusted

# Como R2 est� muito maior que R2 ajustado, pode ter um regressor que n�o ajude
# no modelo. O p-value pode dar uma indica��o do pior e melhor regressor.
# Gastos com P&D e Marketing aumentam o R2 e o R2 ajustado. A adi��o dos outros
# diminui o valor do R2 ajustado. POr isso, o melhor modelo de regress�o 
#considera apenas o P&D e o Marketing

#gr�fico de barras do melhor modelo para a base de teste
counts <- rbind(y_pred, test_set$Profit)
barplot(counts, main="Previs�es X Targets (Base de Teste)",
        xlab="�ndice da linha de teste", col=c("darkblue","red"),
        beside=TRUE)
legend("topleft", legend = c("Previs�es", "Targets"),cex=0.5, fill=c("darkblue","red"))

#gr�fico de resultados
library(ggplot2)
targetForecast = data.frame(test_set$Profit, y_pred)
ggplot(targetForecast, aes(y_pred, test_set.Profit)) + geom_point() +
  geom_abline(intercept = 0)