library(raster)

#load useable data mask
udm2_clip <- raster("Test_Order_psscene_analytic_sr_udm2/PSScene/20230628_204656_17_24b4_3B_udm2_clip.tif")
plot(umd2_clip)

blue <- raster("Test_Order_psscene_analytic_sr_udm2/PSScene/20230628_204656_17_24b4_3B_AnalyticMS_SR_clip.tif", band = 1)
green <- raster("Test_Order_psscene_analytic_sr_udm2/PSScene/20230628_204656_17_24b4_3B_AnalyticMS_SR_clip.tif", band = 2)
red<- raster("Test_Order_psscene_analytic_sr_udm2/PSScene/20230628_204656_17_24b4_3B_AnalyticMS_SR_clip.tif", band = 3)
nir <- raster("Test_Order_psscene_analytic_sr_udm2/PSScene/20230628_204656_17_24b4_3B_AnalyticMS_SR_clip.tif", band = 4)

stack <- stack(udm2_clip, blue, green, red, nir)
names(stack) <- c("UDM", "Blue", "Green", "Red", "NIR")

stack_df  <- as.data.frame(stack, xy = TRUE)

test_conversion <- stack
test_df <- as.data.frame(test_conversion, xy = TRUE)
test_df <- na.omit(test_df)

#Normalize the radiance and scale to 0-255 for plotting
for(i in 4:7){
  test_conversion[,i] <- ((test_conversion[,i] - min(test_df[,i]))/(max(test_df[,i]) - test_conversion[,i])) * 255
}

#Plot true color composite
plotRGB(test_conversion,
        r = "Red", g = "Green", b = "Blue")

#Plot false color composite
plotRGB(test_conversion,
        r = "NIR", g = "Red", b = "Green")
plotRGB(test_conversion,
        r = "NIR", g = "Green", b = "Blue")

#Calculate and plot NDVI
stack$NDVI <- (stack$NIR - stack$Red)/(stack$NIR + stack$Red)
cols <- colorRampPalette(c("red", "yellow", "green", "darkgreen"))
plot(stack$NDVI, col = cols(10000))







