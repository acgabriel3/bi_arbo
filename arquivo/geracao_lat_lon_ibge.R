
# municipios <- mapaF("BR", e o codigo aqui)
codIbge <- municipios$CD_GEOCMU

data <- data.frame(codIbge = codIbge, lat = NA, lon = NA)
for(i in 1:length(municipios$NM_MUNICIP)) {
  data$lon[i] <- municipios@polygons[[i]]@labpt[1]
  data$lat[i] <- municipios@polygons[[i]]@labpt[2]
}

fwrite(data, "lat_lon_municipios.csv")
teste <- fread("lat_lon_municipios.csv")
