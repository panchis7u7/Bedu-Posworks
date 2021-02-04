# author: Morales Corona Diego Armando.

library(dplyr)
library(janitor)
library(tidyr)


########## POSTWORK 1 ##########
part <- read.csv('https://www.football-data.co.uk/mmz4281/1920/SP1.csv')

info <- part[, c('FTHG', 'FTAG')]

n_partidos <- length(info$FTHG)

t_local <- info %>%group_by(FTHG) %>% summarise(frequency = n())
t_visit <- info %>%group_by(FTAG) %>% summarise(frequency = n())

p_local_marginal = t_local$frequency / n_partidos
p_visit_marginal = t_visit$frequency / n_partidos

##### Proba marginal. #######
t_l <- data.frame(t_local$FTHG, t_local$frequency, p_local)
t_l
t_v <- data.frame(t_visit$FTAG, t_visit$frequency, p_visit)
t_v

##### Probabilidad conjunta ######

info2 <- unite(info, variables,c(1:2),  sep = " ", remove = TRUE)
## La columa 'variables' representa la tupla (X=(1,2,..), Y=(1,2,...))

t_conj <- info2 %>%group_by(variables) %>% summarise(frequency = n())

p_conjunta <- t_conj$frequency / n_partidos

tabla_conjunta <- data.frame(t_conj, p_conjunta)
tabla_conjunta
