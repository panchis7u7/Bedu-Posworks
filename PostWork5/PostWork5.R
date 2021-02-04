# author: Morales Corona Diego Armando.

##########################################################
###################### POSTWORK 6 ########################
##########################################################

setwd('C:/Users/MORALES/Desktop/BEDU postwoks/P2')
library(dplyr)
library(fbRanks)

data <- read.csv('C:/Users/MORALES/Desktop/BEDU postwoks/soccer.csv')

#Con la función create.fbRanks.dataframes del paquete fbRanks importa el 
#archivo soccer.csv a R y al mismo tiempo asignarlo a una variable llamada 
#listasoccer. Se creará una lista con los elementos scores y teams que son 
#data frames listos para la función rank.teams. Asigna estos data frames a 
#variables llamadas anotaciones y equipos.

listasoccer <- create.fbRanks.dataframes(scores.file = 'C:/Users/MORALES/Desktop/BEDU postwoks/soccer.csv', date.format = '%d/%m/%Y')
anotaciones <- listasoccer$scores
equipos <- listasoccer$teams

#a) Con ayuda de la función unique crea un vector de fechas (fecha) que no se 
#repitan y que correspondan a las fechas en las que se jugaron partidos. 
#b) Crea una variable llamada n que contenga el número de fechas diferentes. 
#c) Posteriormente, con la función rank.teams y usando como argumentos los data 
#frames anotaciones y equipos, crea un ranking de equipos usando únicamente 
#datos desde la fecha inicial y hasta la penúltima fecha en la que se jugaron 
#partidos, estas fechas las deberá especificar en max.date y min.date. 
#Guarda los resultados con el nombre ranking.

fecha <- unique(data$date)
fecha <- as.Date(fecha, '%d/%m/%Y')
fecha <- sort(fecha)
n <- length(fecha)
ranking <- rank.teams(anotaciones, teams = equipos, 
                      max.date = fecha[n-1], min.date = fecha[1], date.format = '%d/%m/%Y')

#Finalmente estima las probabilidades de los eventos, el equipo de casa 
#gana, el equipo visitante gana o el resultado es un empate para los partidos 
#que se jugaron en la última fecha del vector de fechas fecha. Esto lo puedes 
#hacer con ayuda de la función predict y usando como argumentos ranking y 
#fecha[n] que deberá especificar en date.

predict(ranking, date = fecha[n])
