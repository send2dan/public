#Package load
library(qrcode)
library(here)

#https://stackoverflow.com/questions/7144118/how-to-save-a-plot-as-image-on-the-disk

#Open a device, using png(), bmp(), pdf() or similar
png(here("images", "qr.png"))

#Create the plot
# e.g. google_qr <- qrcode::qr_code("www.google.com") |> plot()
# e.g. zenodo_qr <- qrcode::qr_code("https://doi.org/10.5281/zenodo.7079019") |> plot()
github_send2dan_qr <- qrcode::qr_code("https://github.com/send2dan/public") |> plot()

#Close the device using dev.off()
dev.off()  
