# author: Morales Corona Diego Armando.

########### RETOMAMOS EL POSTWORK 2 ###########

setwd('C:/Users/MORALES/Desktop/BEDU postwoks/P2')
suppressMessages(suppressWarnings(library(dplyr)))
library(dplyr)
library(ggplot2)

dataurl1819 <- "https://www.football-data.co.uk/mmz4281/1819/SP1.csv"
dataurl1920 <- "https://www.football-data.co.uk/mmz4281/1920/SP1.csv"
dataurl1718 <- "https://www.football-data.co.uk/mmz4281/1718/SP1.csv"

download.file(dataurl1718, destfile = "dataurl1718.csv", mode = "wb")
download.file(dataurl1819, destfile = "dataurl1819.csv", mode = "wb")
download.file(dataurl1920, destfile = "dataurl1920.csv", mode = "wb")

lista <- lapply(dir(), read.csv)

lista <- lapply(lista,select, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

data <- do.call(rbind, lista)
str(data)
data <- mutate(data, Date = as.Date(Date, "%d/%m/%y"))
data <- rename(data, goles_local = FTHG, goles_visita = FTAG)

##########################################################
###################### POSTWORK 3 ########################
##########################################################


n_partidos <- length(data[,1])
################ Tabla goles_local #######################
t_goles_local <- table(data$goles_local)
p_goles_local <- t_goles_local[1:length(t_goles_local)]/n_partidos
locales <- data.frame(frecuencia = t_goles_local, probabilidad = p_goles_local)
locales <- locales[, -c(3)]
locales <- rename(locales, goles = frecuencia.Var1, frecuencia = frecuencia.Freq, probabilidad = probabilidad.Freq)

################# Tabla goles_local ######################
t_goles_visit <- table(data$goles_visita)
p_goles_visit <- t_goles_visit/n_partidos
visita <- data.frame(frecuencia = t_goles_visit, probabilidad = p_goles_visit)
visita <- visita[, -c(3)]
visita <- rename(visita, goles = frecuencia.Var1, frecuencia = frecuencia.Freq, probabilidad = probabilidad.Freq)

################# Tabla conjunta ##########################
l <- locales$goles
v <- visita$goles
cart <- expand.grid(l, v)
cart[, 3] = rep(0, length(cart[, 1]))
cart <- rename(cart, local = Var1, visita = Var2, freq = V3)

########## dataFrame con goles_local/goles_visita/freq #####

for(i in 1:length(data[, 1])){
  for(j in 1:length(cart[, 1])){
    if((data[i,4] == cart[j, 1]) & (data[i,5] == cart[j, 2])){
      cart[j, 3] = cart[j, 3] + 1 
    }
  }
}

cart[,4] = cart$freq / n_partidos
cart = rename(cart, probabilidad = V4)


####################### Graficas ############################
ggplot(locales, aes(x = goles, y = probabilidad)) + 
  geom_col(colour = "black", fill= "orange") +
  geom_text(aes(y = round(probabilidad, 4), label = round(probabilidad, 4)), 
            position = "identity", size=3, vjust = -1, hjust=0.5 ,col="black") +
  ggtitle("Probabilidades marginales de goles de equipos locales") + 
  xlab("Goles") +
  ylab("Probabilidades") +
  theme_minimal()

ggplot(visita, aes(x = goles, y = probabilidad)) + 
  geom_col(colour = "black", fill= "orange") +
  geom_text(aes(y = round(probabilidad, 4), label = round(probabilidad, 4)), 
            position = "identity", size=3, vjust = -1, hjust=0.5 ,col="black") +
  ggtitle("Probabilidades marginales de goles de equipos visitantes") + 
  xlab("Goles") +
  ylab("Probabilidades") +
  theme_minimal()

ggplot(cart, aes(x = local, y = visita, fill = probabilidad)) + 
  geom_tile() +
  scale_fill_gradient(low = "white", high = "steelblue") +
  ggtitle("Mapa de calor de la probabilidad conjunta", subtitle = 'Goles de equipos locales vs goles de equipos visitantes') +
  xlab("Goles de los locales") + 
  ylab("Goles de los visitantes")
