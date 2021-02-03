setwd('C:/Users/MORALES/Desktop/BEDU postwoks/P2')
library(dplyr)
library(lubridate)
library(tidyr)
library(ggplot2)

#Agrega una nueva columna sumagoles que contenga la suma de goles por partido. 
data <- read.csv('soccer.csv')
data[,'sumagoles'] <- data[, 3] + data[,5]

#Obtén el promedio por mes de la suma de goles. 

data <- mutate(data, date = as.Date(date, '%d/%m/%Y'))
data[, 'year'] <- year(data[,1])
data[,'month'] <- month(data[,1])
data[,'unos'] <- rep(1, length(data[,1]))
datos <- data %>% group_by(year, month, unos) %>% summarize(goles_prom_mes = mean(sumagoles))
datos <- as.data.frame(datos)
datos <- unite(datos, month_year, c(1,2,3), sep ="/")
datos <- mutate(datos, month_year = as.Date(month_year, '%Y/%m/%d'))

#Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre 
#de 2019. Grafica la serie de tiempo.

serie <- ts(datos$goles_prom_mes, start = c(2017, 8, 1), end = c(2019, 12, 1), frequency = 12)

ggplot(data = datos[1:25, ], aes(x = month_year, y = goles_prom_mes)) +
  geom_line(color = "red", size = 1.5) +
  geom_point() +
  xlab('Fechas') +
  ylab('Goles promedio por mes') +
  ggtitle('Gráfica de la serie de tiempo de goles promedio por partido.', 
          subtitle = 'Desde agosto/2017 hasta diciembre/2019')

