#Postwork sesión 2
#Carlos Rodríguez Tenorio
#rrotenorio@gmail.com
#CDMIT -UNAM

#1. Importar los datos de soccer de las temporadas 2017/2018, 
#2018/2019 y 2019/2020 de la primera división de la liga 
#española a R.

suppressMessages(suppressWarnings(library(dplyr)))
library(dplyr)

dataurl1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
dataurl1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
dataurl1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

download.file(dataurl1718, destfile = "dataurl1718.csv", mode = "wb")
download.file(dataurl1819, destfile = "dataurl1819.csv", mode = "wb")
download.file(dataurl1920, destfile = "dataurl1920.csv", mode = "wb")

lista <- lapply(dir(), read.csv)

#2. Obten una mejor idea de las características de los data frames al usar 
#las funciones: str, head, View y summary
str(lista[[1]]); head(lista[[1]]); summary(lista[[1]]); View(lista[[1]])
str(lista[[2]]); head(lista[[2]]); summary(lista[[2]]); View(lista[[2]])
str(lista[[3]]); head(lista[[3]]); summary(lista[[3]]); View(lista[[3]])

#3. Con la función select del paquete dplyr selecciona únicamente las columnas 
#Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; esto para cada uno de los data frames.

lista <- lapply(lista,select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#4. Asegúrate de que los elementos de las columnas correspondientes de 
#los nuevos data frames sean del mismo tipo (Hint 1: usa as.Date 
#y mutate para arreglar las fechas). Con ayuda de la función rbind 
#forma un único data frame que contenga las seis columnas mencionadas 
#en el punto 3.

data <- do.call(rbind, lista)
str(data)
data <- mutate(data, Date = as.Date(Date, "%d/%m/%y"))
