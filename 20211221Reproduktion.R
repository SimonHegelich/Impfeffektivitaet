# library
library(readxl)
library(survival)

### Daten laden ###
# Die original Daten zu den Impfdurchbrüchen habe ich aus den RKI
# Wochenberichten zusammengestellt.

ID <- read.csv("https://github.com/SimonHegelich/Impfeffektivitaet/raw/main/20211221Impfdurchbrueche.csv")

# Inzidenz_Impfstatus
download.file(destfile = paste0(Sys.Date(), "Inzidenz_Impfstatus.xlsx"),
              url ="https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Daten/Inzidenz_Impfstatus.xlsx?__blob=publicationFile")

Inz_Symp <- read_xlsx(paste0(Sys.Date(), "Inzidenz_Impfstatus.xlsx"), 
                      sheet = 2,
                      skip = 3,
                      na = "--")

Inz_Hosp <- read_xlsx(paste0(Sys.Date(), "Inzidenz_Impfstatus.xlsx"), 
                      sheet = 3,
                      skip = 3,
                      na = "--")

# Meldewochen in Datum umwandeln
Inz_Hosp$Datum <- as.Date(paste(2021, Inz_Hosp$Meldewoche, 1, sep="-"), "%Y-%U-%u")
Inz_Symp$Datum <- as.Date(paste(2021, Inz_Symp$Meldewoche, 1, sep="-"), "%Y-%U-%u")

png("Inzidenz_Hosp.png", width = 18, height = 16, units = "cm", res = 600)
plot(Inz_Hosp$Datum, Inz_Hosp$`Ungeimpfte 12-17 Jahre`,
     main = "Inzidenz Hospitalisiert",
     type = "l",
     xlab = "",
     ylab = "",
     ylim = c(0,55),
     col = "darkgoldenrod1")
points(Inz_Hosp$Datum, Inz_Hosp$`Grundimmunisierte  12-17 Jahre`,
       type = "l",
       col = "deepskyblue1")
points(Inz_Hosp$Datum, Inz_Hosp$`Ungeimpfte 18-59 Jahre`,
       type = "l",
       col = "chartreuse1")
points(Inz_Hosp$Datum, Inz_Hosp$`Grundimmunisierte  18-59 Jahre`,
       type = "l",
       col = "deeppink1")
points(Inz_Hosp$Datum, Inz_Hosp$`Ungeimpfte 60+ Jahre`,
       type = "l",
       col = "aquamarine1")
points(Inz_Hosp$Datum, Inz_Hosp$`Grundimmunisierte 60+ Jahre`,
       type = "l",
       col = "darkorchid")
legend("topleft", legend = c("12-17 ungeimpft", 
                             "12-17 geimpft",
                             "18-59 ungeimpft",
                             "18-59 geimpft",
                             "60+ ungeimpft",
                             "60+ geimpft"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1",
                "chartreuse1",
                "deeppink1",
                "aquamarine1",
                "darkorchid"))
dev.off()

png("Inzidenz_Symp.png", width = 18, height = 16, units = "cm", res = 600)
plot(Inz_Symp$Datum, Inz_Symp$`Ungeimpfte 12-17 Jahre`,
     main = "Inzidenz Symptomatisch",
     type = "l",
     xlab = "",
     ylab = "",
     ylim = c(0,500),
     col = "darkgoldenrod1")
points(Inz_Symp$Datum, Inz_Symp$`Grundimmunisierte  12-17 Jahre`,
       type = "l",
       col = "deepskyblue1")
points(Inz_Symp$Datum, Inz_Symp$`Ungeimpfte 18-59 Jahre`,
       type = "l",
       col = "chartreuse1")
points(Inz_Symp$Datum, Inz_Symp$`Grundimmunisierte  18-59 Jahre`,
       type = "l",
       col = "deeppink1")
points(Inz_Symp$Datum, Inz_Symp$`Ungeimpfte 60+ Jahre`,
       type = "l",
       col = "aquamarine1")
points(Inz_Symp$Datum, Inz_Symp$`Grundimmunisierte 60+ Jahre`,
       type = "l",
       col = "darkorchid")
legend("topleft", legend = c("12-17 ungeimpft", 
                             "12-17 geimpft",
                             "18-59 ungeimpft",
                             "18-59 geimpft",
                             "60+ ungeimpft",
                             "60+ geimpft"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1",
                "chartreuse1",
                "deeppink1",
                "aquamarine1",
                "darkorchid"))
dev.off()

# Bevölkerung
Bev <- read.csv2("https://raw.githubusercontent.com/SimonHegelich/Impfeffektivitaet/main/Bev%C3%B6lkerung.csv", skip = 6)

Bev <- Bev[c(1:87),]
colnames(Bev) <- c("Alter", "Anzahl")
Bev_Gesamt <- Bev$Anzahl[87]
Bev_60 <- sum(Bev$Anzahl[c(61:86)])
Bev_18_59 <- sum(Bev$Anzahl[c(19:60)])
Bev_12_17 <- sum(Bev$Anzahl[c(13:18)])

png("Bevölkerung.png", width = 18, height = 10, units = "cm", res = 600)
par(las=2) # make label text perpendicular to axis
par(mar=c(3,4,4,2)) # increase y-axis margin.
barplot(c(Bev_12_17, Bev_18_59, Bev_60)/1000000,
        horiz = T,
        main = "Bevölkerung in Millionen",
        names.arg = c("12-17","18-59", "60+"))
dev.off()

# Impfquoten
# Zunächst git clonen
# git clone https://github.com/robert-koch-institut/COVID-19-Impfungen_in_Deutschland
FL <- list.files("./COVID-19-Impfungen_in_Deutschland/Archiv")
FL <- FL[grep("Impfquoten", FL)]
df_IQ <- read.csv(paste0("./COVID-19-Impfungen_in_Deutschland/Archiv/", FL[1]))
df_IQ <- df_IQ[1,] # 1. Zeile ist Deutschland gesamt
Spalten <- colnames(df_IQ)
for (i in 2:length(FL)){
  df_IQ_n <- read.csv(paste0("./COVID-19-Impfungen_in_Deutschland/Archiv/", FL[i]))
  df_IQ_n <- df_IQ_n[Spalten]
  df_IQ <- rbind(df_IQ, df_IQ_n[1,]) # später kommen fünf Spalten für Booster dazu.
}
df_IQ$Datum <- as.Date(df_IQ$Datum)

png("Impfquoten.png", width = 18, height = 16, units = "cm", res = 600)
plot(df_IQ$Datum, df_IQ$Impfquote_gesamt_voll,
     type = "l",
     main = "Impfquoten",
     sub = "vollständig geimpft",
     xlab = "",
     ylab = "",
     ylim = c(25,90),
     col = "black")
points(df_IQ$Datum, df_IQ$Impfquote_12bis17_voll,
       type = "l",
       col = "red")
points(df_IQ$Datum, df_IQ$Impfquote_18bis59_voll,
       type = "l",
       col = "green")
points(df_IQ$Datum, df_IQ$Impfquote_60plus_voll,
       type = "l",
       col = "blue")
legend("bottomright", legend = c("gesamt", "12-17", "18-59", "60+"),
       fill = c("black", "red", "green", "blue"))
dev.off()

# Geimpfte
df_IQ$G_12_17 <- Bev_12_17 * (df_IQ$Impfquote_12bis17_voll/100)
df_IQ$G_18_59 <- Bev_18_59 * (df_IQ$Impfquote_18bis59_voll/100)
df_IQ$G_60 <- Bev_60 * (df_IQ$Impfquote_60plus_voll/100)

# Einmal Geimpft
df_IQ$E_12_17 <- Bev_12_17 * (df_IQ$Impfquote_12bis17_min1/100)
df_IQ$E_18_59 <- Bev_18_59 * (df_IQ$Impfquote_18plus_min1/100)
df_IQ$E_60 <- Bev_60 * (df_IQ$Impfquote_60plus_min1/100)

# Ungeimpft

df_IQ$U_12_17 <- Bev_12_17 - df_IQ$E_12_17
df_IQ$U_18_59 <- Bev_18_59 - df_IQ$E_18_59
df_IQ$U_60 <- Bev_60 - df_IQ$E_60

png("AnzahlGeimpftUngeimpft.png", width = 18, height = 16, units = "cm", res = 600)
plot(df_IQ$Datum, df_IQ$U_12_17,
     type = "l",
     main = "Anzahl Geimpft/Ungeimpft",
     # sub = "vollständig geimpft",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(20:26)]),max(df_IQ[,c(17:26)])),
     col = "darkgoldenrod1")
points(df_IQ$Datum, df_IQ$G_12_17,
       type = "l",
       col = "deepskyblue1")
points(df_IQ$Datum, df_IQ$U_18_59,
       type = "l",
       col = "chartreuse1")
points(df_IQ$Datum, df_IQ$G_18_59,
       type = "l",
       col = "deeppink1")
points(df_IQ$Datum, df_IQ$U_60,
       type = "l",
       col = "aquamarine1")
points(df_IQ$Datum, df_IQ$G_60,
       type = "l",
       col = "darkorchid")

legend("topleft", legend = c("12-17 ungeimpft", 
                             "12-17 geimpft",
                             "18-59 ungeimpft",
                             "18-59 geimpft",
                             "60+ ungeimpft",
                             "60+ geimpft"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1",
                "chartreuse1",
                "deeppink1",
                "aquamarine1",
                "darkorchid"))
dev.off()

# Rekonstruktion Impfdurchbrüche
# Anzahl geimpfter Fälle = Inzidenz * Anzahl geimpfter Personen / 100000

# Zunächst Inzidenz in Datensatz integrieren

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_G12_17[i] <- Inz_Hosp$`Grundimmunisierte  12-17 Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_U12_17[i] <- Inz_Hosp$`Ungeimpfte 12-17 Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_G18_59[i] <- Inz_Hosp$`Grundimmunisierte  18-59 Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_U18_59[i] <- Inz_Hosp$`Ungeimpfte 18-59 Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_G60[i] <- Inz_Hosp$`Grundimmunisierte 60+ Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Hosp_U60[i] <- Inz_Hosp$`Ungeimpfte 60+ Jahre`[which(abs(Inz_Hosp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Hosp$Datum - df_IQ$Datum[i])))]
}

# Symptomatisch
for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_G12_17[i] <- Inz_Symp$`Grundimmunisierte  12-17 Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_U12_17[i] <- Inz_Symp$`Ungeimpfte 12-17 Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_G18_59[i] <- Inz_Symp$`Grundimmunisierte  18-59 Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_U18_59[i] <- Inz_Symp$`Ungeimpfte 18-59 Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_G60[i] <- Inz_Symp$`Grundimmunisierte 60+ Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

for (i in 1:dim(df_IQ)[1]){
  df_IQ$Inz_Symp_U60[i] <- Inz_Symp$`Ungeimpfte 60+ Jahre`[which(abs(Inz_Symp$Datum - df_IQ$Datum[i]) == min(abs(Inz_Symp$Datum - df_IQ$Datum[i])))]
}

df_IQ$Hosp_G12_17 <- df_IQ$Inz_Hosp_G12_17 * df_IQ$G_12_17 / 100000
df_IQ$Hosp_U12_17 <- df_IQ$Inz_Hosp_U12_17 * df_IQ$U_12_17 / 100000
df_IQ$Hosp_G18_59 <- df_IQ$Inz_Hosp_G18_59 * df_IQ$G_18_59 / 100000
df_IQ$Hosp_U18_59 <- df_IQ$Inz_Hosp_U18_59 * df_IQ$U_18_59 / 100000
df_IQ$Hosp_G60 <- df_IQ$Inz_Hosp_G60 * df_IQ$G_60 / 100000
df_IQ$Hosp_U60 <- df_IQ$Inz_Hosp_U60 * df_IQ$U_60 / 100000

df_IQ$Symp_G12_17 <- df_IQ$Inz_Symp_G12_17 * df_IQ$G_12_17 / 100000
df_IQ$Symp_U12_17 <- df_IQ$Inz_Symp_U12_17 * df_IQ$U_12_17 / 100000
df_IQ$Symp_G18_59 <- df_IQ$Inz_Symp_G18_59 * df_IQ$G_18_59 / 100000
df_IQ$Symp_U18_59 <- df_IQ$Inz_Symp_U18_59 * df_IQ$U_18_59 / 100000
df_IQ$Symp_G60 <- df_IQ$Inz_Symp_G60 * df_IQ$G_60 / 100000
df_IQ$Symp_U60 <- df_IQ$Inz_Symp_U60 * df_IQ$U_60 / 100000

png("ImpfdurchbruecheSymp.png", width = 18, height = 26, units = "cm", res = 600)
par(mfrow=c(3,1))
plot(df_IQ$Datum, df_IQ$Symp_U12_17,
     type = "l",
     main = "Impfdurchbrüche/Symptomatisch 12-17",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(45,46)]),max(df_IQ[,c(45,46)])),
     col = "darkgoldenrod1")
points(df_IQ$Datum, df_IQ$Symp_G12_17,
       type = "l",
       col = "deepskyblue1")
legend("topleft", legend = c("12-17 ungeimpft", 
                             "12-17 geimpft"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1"))

plot(df_IQ$Datum, df_IQ$Symp_U18_59,
     type = "l",
     main = "Impfdurchbrüche/Symptomatisch 18-59",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(47,48)]),max(df_IQ[,c(47,48)])),
     col = "chartreuse1")
points(df_IQ$Datum, df_IQ$Symp_G18_59,
       type = "l",
       col = "deeppink1")
legend("topleft", legend = c("18-59 ungeimpft", 
                             "18-59 geimpft"),
       fill = c("chartreuse1", 
                "deeppink1"))

plot(df_IQ$Datum, df_IQ$Symp_U60,
     type = "l",
     main = "Impfdurchbrüche/Symptomatisch 60+",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(49,50)]),max(df_IQ[,c(49,50)])),
     col = "aquamarine1")
points(df_IQ$Datum, df_IQ$Symp_G60,
       type = "l",
       col = "darkorchid")
legend("topleft", legend = c("60+ ungeimpft", 
                             "60+ geimpft"),
       fill = c("aquamarine1", 
                "darkorchid"))
dev.off()

png("ImpfdurchbruecheHosp.png", width = 18, height = 26, units = "cm", res = 600)
par(mfrow=c(3,1))
plot(df_IQ$Datum, df_IQ$Hosp_U12_17,
     type = "l",
     main = "Impfdurchbrüche/Hospitalisiert 12-17",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(39,40)]),max(df_IQ[,c(39,40)])),
     col = "darkgoldenrod1")
points(df_IQ$Datum, df_IQ$Hosp_G12_17,
       type = "l",
       col = "deepskyblue1")
legend("topleft", legend = c("12-17 ungeimpft", 
                             "12-17 geimpft"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1"))

plot(df_IQ$Datum, df_IQ$Hosp_U18_59,
     type = "l",
     main = "Impfdurchbrüche/Hospitalisiert 18-59",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(41,42)]),max(df_IQ[,c(41,42)])),
     col = "chartreuse1")
points(df_IQ$Datum, df_IQ$Hosp_G18_59,
       type = "l",
       col = "deeppink1")
legend("topleft", legend = c("18-59 ungeimpft", 
                             "18-59 geimpft"),
       fill = c("chartreuse1", 
                "deeppink1"))

plot(df_IQ$Datum, df_IQ$Hosp_U60,
     type = "l",
     main = "Impfdurchbrüche/Hospitalisiert 60+",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(min(df_IQ[,c(43,44)]),max(df_IQ[,c(43,44)])),
     col = "aquamarine1")
points(df_IQ$Datum, df_IQ$Hosp_G60,
       type = "l",
       col = "darkorchid")
legend("topleft", legend = c("60+ ungeimpft", 
                             "60+ geimpft"),
       fill = c("aquamarine1", 
                "darkorchid"))
dev.off()

# Impfeffektivität
Farrington <- function(PCV, PVV){
  VE = 1-PCV/(1-PCV)*(1-PVV)/PVV
  return(VE)
}

# Symptomatisch
PCV_Symp_12_17 <- df_IQ$Symp_G12_17/(df_IQ$Symp_G12_17 + df_IQ$Symp_U12_17)
PVV_Symp_12_17 <- df_IQ$G_12_17/(df_IQ$G_12_17+df_IQ$U_12_17)
df_IQ$VE_Symp_12_17 <- Farrington(PCV_Symp_12_17, PVV_Symp_12_17)

PCV_Symp_18_59 <- df_IQ$Symp_G18_59/(df_IQ$Symp_G18_59 + df_IQ$Symp_U18_59)
PVV_Symp_18_59 <- df_IQ$G_18_59/(df_IQ$G_18_59+df_IQ$U_18_59)
df_IQ$VE_Symp_18_59 <- Farrington(PCV_Symp_18_59, PVV_Symp_18_59)   

PCV_Symp_60 <- df_IQ$Symp_G60/(df_IQ$Symp_G60 + df_IQ$Symp_U60)
PVV_Symp_60 <- df_IQ$G_60/(df_IQ$G_60+df_IQ$U_60)
df_IQ$VE_Symp_60 <- Farrington(PCV_Symp_60, PVV_Symp_60) 

# Hospitalisiert
PCV_Hosp_12_17 <- df_IQ$Hosp_G12_17/(df_IQ$Hosp_G12_17 + df_IQ$Hosp_U12_17)
PVV_Hosp_12_17 <- df_IQ$G_12_17/(df_IQ$G_12_17+df_IQ$U_12_17)
df_IQ$VE_Hosp_12_17 <- Farrington(PCV_Hosp_12_17, PVV_Hosp_12_17)

PCV_Hosp_18_59 <- df_IQ$Hosp_G18_59/(df_IQ$Hosp_G18_59 + df_IQ$Hosp_U18_59)
PVV_Hosp_18_59 <- df_IQ$G_18_59/(df_IQ$G_18_59+df_IQ$U_18_59)
df_IQ$VE_Hosp_18_59 <- Farrington(PCV_Hosp_18_59, PVV_Hosp_18_59)   

PCV_Hosp_60 <- df_IQ$Hosp_G60/(df_IQ$Hosp_G60 + df_IQ$Hosp_U60)
PVV_Hosp_60 <- df_IQ$G_60/(df_IQ$G_60+df_IQ$U_60)
df_IQ$VE_Hosp_60 <- Farrington(PCV_Hosp_60, PVV_Hosp_60) 

# Plots
png("ImpfeffektivitaetSymp.png", width = 18, height = 16, units = "cm", res = 600)
plot(df_IQ$Datum, df_IQ$VE_Symp_12_17,
     type = "l",
     main = "Impfeffektivität Symptomatisch",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(0,1),
     col = "darkgoldenrod1")
points(df_IQ$Datum, df_IQ$VE_Symp_18_59,
       type = "l",
       col = "deepskyblue1")
points(df_IQ$Datum, df_IQ$VE_Symp_60,
       type = "l",
       col = "deeppink1")

abline(h=(seq(0,1,0.1)), col="lightgray", lty="dotted")
grid()

legend("bottomleft", legend = c("12-17", 
                             "18-59", "60+"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1",
                "deeppink1"))

dev.off()

png("ImpfeffektivitaetHosp.png", width = 18, height = 16, units = "cm", res = 600)
plot(df_IQ$Datum, df_IQ$VE_Hosp_12_17,
     type = "l",
     main = "Impfeffektivität Hospitalisiert",
     # sub = "12-17",
     xlab = "",
     ylab = "",
     ylim = c(0,1),
     col = "darkgoldenrod1")
points(df_IQ$Datum, df_IQ$VE_Hosp_18_59,
       type = "l",
       col = "deepskyblue1")
points(df_IQ$Datum, df_IQ$VE_Hosp_60,
       type = "l",
       col = "deeppink1")
abline(h=(seq(0,1,0.1)), col="lightgray", lty="dotted")
grid()

legend("bottomleft", legend = c("12-17", 
                                "18-59", "60+"),
       fill = c("darkgoldenrod1", 
                "deepskyblue1",
                "deeppink1"))
dev.off()
