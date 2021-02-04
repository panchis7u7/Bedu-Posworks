#Viridiana Escarzaga Solis
#Carlos Sebastián Madrigal Rodríguez
#Diego Armando Morales Corona
#Carlos Rodríguez Tenorio

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

#creamos la bd match_games con la coleccion match en mongo.
#Se realiza la conexion a mongo.
coleccion = mongo("match", "match_games")

#Se aloja el fichero data.csv.
coleccion$insert(data)

#Conocer la cantidad de registros de la base de datos.
coleccion$count()

#realizamos la consulta
#Para conocer el número de goles que metió el Real Madrid 
#el 20 de diciembre de 2015 y contra que equipo jugó, ¿perdió 
#ó fue goleada?
coleccion$find('{"Date":"2017-12-20", "HomeTeam":"Real Madrid"}')

#No hay ningun registro que corresponde a tal fecha.

#Ya habiendo hecho la consulta, debemos de cerrar la 
#conexion con la base de datos.
rm(coleccion)
