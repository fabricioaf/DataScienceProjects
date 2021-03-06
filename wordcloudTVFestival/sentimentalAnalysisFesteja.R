#Instala Pacotes
#Depois de instalados, deix�-los como coment�rios para evitar dupla instala��o
#ao executar o c�digo
install.packages("twitteR")
install.packages("httpuv")
install.packages("plyr")
install.packages("stringr")
install.packages("ggplot2")
install.packages("xlsx")
install.packages("tm")
install.packages("wordcloud")
install.packages("RTextTools")

#Declara o uso dos pacotes
library(twitteR)
library(httpuv)
library(plyr)
library(stringr)
library(ggplot2)
library(xlsx)
library(tm)
library(wordcloud)
library(RTextTools)

rm(list = ls())   #limpa o workspace
cat("\014")       #limpa o console

#Conecta Twitter API ####
#https://apps.twitter.com/
#Settings/callback: http://127.0.0.1:8888/oauth/callback.exe?gwt.codesvr=127.0.0.1:9997
# ou http://127.0.0.1:1410
api_key<- "Drx12FOUJMAS7DgzdCJtcRFYy"
api_secret <- "XT9AyGRpxpfDNZXTjuFH8KUKyGjCPQWJjM7PQ9Bfo8oU7kfRXu"
setup_twitter_oauth(api_key,api_secret)

#Buscar 10.000 tweets sobre Festeja e analizar. ####
tweets = searchTwitter('festeja',n=10000, lang = "pt")
Tweets.text = laply(tweets,function(t)t$getText()) #pega somente os textos dos Tweets

#Limpa os tweets retirando pontua��o, colocando tudo em caixa baixa, ####
#retirando espa�os desnecess�rios, n�meros, links, @pessoa, #hashtags, emoticons, etc...
setwd("C:\\Users\\Arthur Silveira\\Dropbox\\Meus Documentos\\P�s\\M�dulo I\\Workshop I\\Mini Curso R")
source("cleanTweets.R")
Tweets.text = cleanTweets(Tweets.text)

#Exportar para Excel ####
write.xlsx(analysis, "myResults.xlsx")

#Instalar pacotes para in�cio da an�lise com wordcloud ####
Needed <- c("tm", "SnowballC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")
install.packages(Needed, dependencies = TRUE)
install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")

#Criar pasta no C: com nome "Texts", deixando o arquivo em Excel como �nico
#elemento da pasta ####
#Salvar arquivo em Excel como .txt
cname <- file.path("C:", "texts")

#Chamar biblioteca de text mining ####
library(tm)

#Adquirir lista de arquivos da pasta contendo o txt base para constru��o
#do WordCloud ####
docs <- Corpus(DirSource(cname))

#Remover pontua��es, n�meros e espa�os em branco remanescentes. 
#Colocar todas as palavras em caixa baixa. Remover palavras que, 
#atrav�s de an�lise emp�rica, n�o iriam agregar valor � nuvem ####
docs <- tm_map(docs, removePunctuation)
docs <- tm_map(docs, removeNumbers)
docs <- tm_map(docs, tolower)
docs <- tm_map(docs, removeWords, c("agora", "ainda", "anos", "aqui", "ate", "bem", "boa", "cada", "coisa", "desse", "dia", "dois", "esperamos", "estamos", "estao", "estaremos", "fazer", "fim", "foi", "grande", "mais", "melhor", "muita", "muito", "nao", "nesse", "nos", "parte", "pode", "pouco", "pra", "pro", "que", "quem", "ser", "sobre", "tambem", "tempo", "ter", "todo", "todos", "tudo", "vai", "vamos", "vao", "ver", "vez", "voce", "voces", "alem", "algumas", "antes", "belo", "bom", "curtir", "desde", "dessa", "estar", "faz", "felizes", "fez", "ficou", "final", "fiquem", "fizemos", "httpgooglltzgtj", "httpgooglzyb", "httpsgooglbastnh", "httpsgoogljux", "legal", "liguem", "momento", "nessa", "nova", "novos", "novo", "outras", "outros", "participar", "pessoas", "porque", "proxima", "proximo", "quiser", "resultado", "rolando", "rolar", "sempre", "sessao", "tamo", "tao", "tarde", "the", "todas", "vale", "varias", "varios", "vem", "viemos"))
docs <- tm_map(docs, stripWhitespace)

#Transformar documento em matriz ####
dtm <- DocumentTermMatrix(docs)

#An�lises de frequencia de palavras sobre o documento
freq <- colSums(as.matrix(dtm))
length(freq)

#Ordenar palavras das menos para as mais frequentes ####
ord <- order(freq)

#Consultar primeiras e �ltimas posi��es da matriz ####
freq[head(ord)]
freq[tail(ord)]

#Analisar n�mero de palavras vs. quantidade de ocorr�ncias para as 20 primeiras
# e �ltimas posi��es da matriz #### 
head(table(freq), 20)
tail(table(freq), 20)

#Ordenar ocorr�ncias de palavras na matriz da mais frequente para a menos
# frequente e analisar primeiras posi��es
freq <- sort(colSums(as.matrix(dtm)), decreasing = TRUE)
head(freq, 14)

#Listar termos mais frequentes (a partir de, no m�nimo, 15 ocorr�ncias)
findFreqTerms(dtm, lowfreq = 15)

#Plotar wordcloud
wordcloud(names(freq), freq, min.freq = 10, scale=c(3, .3), colors=brewer.pal(3, "Dark2"))