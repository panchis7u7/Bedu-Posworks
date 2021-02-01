#Postwork sesión 2
#Carlos Rodríguez Tenorio
#rrotenorio@gmail.com
#CDMIT -UNAM

#1. Importar los datos de soccer de las temporadas 2017/2018, 
#2018/2019 y 2019/2020 de la primera división de la liga 
#española a R.

suppressMessages(suppressWarnings(library(dplyr)))
library(dplyr)
setwd("/Users/carlostenorio/Documents/MASTER/BEDU/Fase II/sesion5/datospostwork")

dataurl1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
dataurl1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
dataurl1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

download.file(dataurl1718, destfile = "dataurl1718.csv", mode = "wb")
download.file(dataurl1819, destfile = "dataurl1819.csv", mode = "wb")
download.file(dataurl1920, destfile = "dataurl1920.csv", mode = "wb")

lista <- lapply(list.files(pattern ="*.csv"), read.csv)
tail(lista[3])
#Con la función select del paquete dplyr selecciona únicamente las columnas 
#Date, HomeTeam, AwayTeam, HS (HomeScore), AS (Awayscore); esto para cada uno de los data frames.

lista <- lapply(lista, select, Date, HomeTeam, AwayTeam, HS, AS)
lista[1] <- lapply(lista[1],mutate,Date=as.Date(Date,"%d/%m/%y"))
lista[2] <- lapply(lista[2],mutate,Date=as.Date(Date,"%d/%m/%Y"))
lista[3] <- lapply(lista[3],mutate,Date=as.Date(Date,"%d/%m/%Y"))
str(lista)

#Juntando los elementos en un solo data set llamada SmallData
SmallData <- do.call(rbind, lista)
str(SmallData)
#SmallData <- mutate(SmallData, Date = as.Date(Date, "%d/%m/%y"))
SmallData <- rename(SmallData, home.team= HomeTeam, away.team = AwayTeam,
                    home.score= HS, away.score =AS)

#Guardando el data frame small data en un csv llamado soccer.csv

write.csv(SmallData, "soccer.csv", row.names = FALSE)

#2. Usando la paquetería fbRanks

library(fbRanks)

#Con la función create.fbRanks.data se importa el archivo soccer.csv y se asigna a una variable llamada
#listasoccer

listasoccer <-create.fbRanks.dataframes("soccer.csv")
listasoccer

#Se crea una lista con los elementos scores y teams que son data frames listos para la 
#función rank.teams. #Asigna estos dataframes a variables llamadas anotaciones y equipos.

anotaciones <-listasoccer$scores
equipos <- listasoccer$teams
head(anotaciones)
head(equipos)
#3. Con ayuda de la función unique, crea un vector de fechas (fecha) que no se repitan y que 
#correspondan a las fechas en las que se jugaron partidos.

fecha <- unique(anotaciones$date)
head(fecha)

#Crea una variable n que contenga el número de fechas diferentes.

n <-length(fecha)
n

#Posteriormente, con la función rank.teams y usando como argumentos los data frames anotaciones
#y equipos, crea un ranking de equipos usando únicamente datos desde la fecha inicial y hasta la
#penúltima fecha en la que se jugaron partidos. Estas fechas se deberán especificar en max.date
#y min.date. Guarda los resultados con el nombre ranking.

ranking <-rank.teams(anotaciones, equipos, max.date=fecha[n-1], min.date = fecha[1])
head(ranking)

#4. Finalmente estima las probabilidades de los eventos, el equipo de casa gana, el equipo
#visitante gana o el resultado es un empate para los partidos que se jugaron en la última fecha
#del vector de fechas fecha. Esto lo puedes hacer con ayuda de la función predict y usando como
#argumentos ranking y fecha[n] que deberá especificar en date.

predict(ranking, date = fecha[n])




















