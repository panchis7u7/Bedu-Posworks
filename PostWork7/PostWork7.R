#Viridiana Escarzaga Solis
#Carlos Sebastián Madrigal Rodríguez
#Diego Armando Morales Corona
#Carlos Rodríguez Tenorio

#https://www.football-data.co.uk/mmz4281/1516/SP1.csv
#Instalamos la libreria que nos permitira la conexion a mongodb.
suppressMessages(suppressWarnings(install.packages("mongolite", dependencies = TRUE)))

#Cargamos la libreria de mongolite.
suppressMessages(suppressWarnings(library(mongolite)))

#A partir del conjunto de datos proporcinado en datos.csv, 
#se importara y analizara para conocer el contenido de 
#este archivo. Primero se cambia el 'Working directory' 
#a la ubicacion en donde tenemos el conjunto de datos 
#guardados, posteriormente se guarda en un data frame y 
#se imprime las primeras filas para conocer mas sobre la 
#integridad de los datos del archivo.
setwd("/media/panchis/ExtraHDD/EstadisticaRP/Sesion_7/PostWork7/")
data <- read.csv('data.csv')
head(data)

#Como este dataset no tiene el registro que nos interesa obtener (registros del 2015), 
#importamos el dataset que contiene los partidos del ano 2015.
data_extension <- read.csv("https://www.football-data.co.uk/mmz4281/1516/SP1.csv")
head(data_extension)

#Añadimos la fila de ID de registro.
data_extension <- mutate(data_extension, X = row_number())

#Le damos Formato a la fecha.
data_extension$Date <- format(as.Date(data_extension$Date), "%d-%m-%Y")

#Completamos el año.
data_extension$Date <- paste0("20", data_extension$Date)
data_extension <- mutate(data_extension, Fecha = as.Date(Date, "%m-%d-%Y"))

#Seleccionamos las filas que corresponden al archivo local.
data_extension <- select(data_extension, X, Date, HomeTeam, AwayTeam, FTHG, FTAG, FTR)

#Unimos los datasets.
final_data <- rbind(data, data_extension)

#Reseteamos los ID de las tuplas.
final_data <- mutate(final_data, X = row_number())

#Ahora las columnas coinciden y se agrupo de manera correcta.
head(final_data)

#creamos la bd match_games con la coleccion match en mongo.
#Se realiza la conexion a mongo.
coleccion = mongo("match", "match_games")

#Se aloja el fichero data.csv.
coleccion$insert(final_data)

#Conocer la cantidad de registros de la base de datos.
coleccion$count()

#realizamos la consulta
#Para conocer el número de goles que metió el Real Madrid 
#el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió 
#ó fue goleada?
coleccion$find('{"Date":"2015-12-20", "HomeTeam":"Real Madrid"}')

#El Equipo del real madrid le dio una goliza al Vallecano! 10 - 2.

#Ya habiendo hecho la consulta, debemos de cerrar la 
#conexion con la base de datos.
rm(coleccion)
