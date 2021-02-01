########### RETOMAR LA PRECTICA 2 ###########

#1. Importar los datos de soccer de las temporadas 2017/2018, 
#2018/2019 y 2019/2020 de la primera división de la liga 
#española a R.
setwd('C:/Users/MORALES/Desktop/BEDU postwoks/P2')
suppressMessages(suppressWarnings(library(dplyr)))
library(dplyr)
library(ggplot2)
library(fitdistrplus)

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

###################### postwork 3 ########################

n_partidos <- length(data[,1])
### Tabla goles_local
t_goles_local <- table(data$goles_local)
p_goles_local <- t_goles_local[1:length(t_goles_local)]/n_partidos
locales <- data.frame(frecuencia = t_goles_local, probabilidad = p_goles_local)
locales <- locales[, -c(3)]
locales <- rename(locales, goles = frecuencia.Var1, frecuencia = frecuencia.Freq, probabilidad = probabilidad.Freq)

### Tabla goles_local
t_goles_visit <- table(data$goles_visita)
p_goles_visit <- t_goles_visit/n_partidos
visita <- data.frame(frecuencia = t_goles_visit, probabilidad = p_goles_visit)
visita <- visita[, -c(3)]
visita <- rename(visita, goles = frecuencia.Var1, frecuencia = frecuencia.Freq, probabilidad = probabilidad.Freq)

### Tabla conjunta
l <- locales$goles
v <- visita$goles
cart <- expand.grid(l, v)
cart[, 3] = rep(0, length(cart[, 1]))
cart <- rename(cart, local = Var1, visita = Var2, freq = V3)
########## dataFrame con goles_local/goles_visita/freq
for(i in 1:length(data[, 1])){
  for(j in 1:length(cart[, 1])){
    if((data[i,4] == cart[j, 1]) & (data[i,5] == cart[j, 2])){
      cart[j, 3] = cart[j, 3] + 1 
    }
  }
}

cart[,4] = cart$freq / n_partidos
cart = rename(cart, probabilidad = V4)

##### Multiplicacion de las marginales #######
cart[, 5] = rep(0, length(cart[, 1]))
for(i in 1:length(cart$local)){
  for(j in 1:length(locales$goles)){
    for(k in 1:length(visita$goles)){
      if((cart[i,1] == locales[j,1]) & (cart[i,2] == visita[k,1])){
        cart[i,5] = locales[j,3] * visita[k, 3]
      }
    }
  }
}
cart <- rename(cart, multi_marginal = V5) ##### DataFrame con las multiplicaciones de marginales

##### Cociente
cart[, 'cociente'] <- cart$probabilidad / cart$multi_marginal


x <- c()
for(i in 1:10000){
  set.seed(2*i)
  x[i] = mean(sample(cart$cociente, length(cart$multi_marginal), replace = TRUE))
  
}

ggplot() + geom_histogram(aes(x), bins = 50) + geom_vline(aes(xintercept = mean(x)))

# Ho: media = 1 vs H1: media != 1
t.test(x, alternative = "two.sided", mu = 1)
## p-value < 2.2e-16  < alpha ==>> Rechazar Ho  == > No son independientes 

descdist(data = x, graph = FALSE)
distribucion <- fitdist(x, distr = "norm")
summary(distribucion)
plot(distribucion)
