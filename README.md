# Rekonstruktion der Impfeffektivität
Im folgenden Beitrag geht es darum, die Daten zur Impfeffektivität des RKI zu rekonstruieren. Das ist leider notwendig, da das RKI an diversen Stellen zwar die Ergebnisse seiner Berechnungen veröffentlicht, nicht aber die Daten, die zu Grunde liegen. Richtige Transparenz fehlt daher.
Um es Interessierten zu ermöglichen, sich ein eigenes Bild zu verschaffen und eigene Berechnungen anzustellen, habe ich die folgenden Auswertungen in R programmiert und stelle die Skripte auf meinem Github-Repository bereit.
Im ersten Teil dieses Blogbeitrags habe ich auf einige theoretische Schwächen in der Ermittlung der Impfeffektivität hingewiesen (https://politicaldatascience.blogspot.com/2021/12/deep-dive-impfeffektivitat-eine.html). Dieser zweite Teil dient zunächst dazu, die Berechnung des RKI transparent zu machen. In wie weit sich die besprochenen Argumente tatsächlich auswirken würden, kann mit Hilfe der hier rekonstruierten Daten untersucht werden. Dies wird dann der dritte Teil des Beitrags.

Um die Berechnungen des RKI zur Impfeffektivität nachvollziehen zu können, braucht man Daten zum Anteil der Geimpften unter den Erkrankten und zur Impfquote zu einem gegebenen Zeitpunkt. Beides wird vom RKI so nicht bereit gestellt.

# Was ist der Anteil der geimpften Erkrankten?
Das RKI stellt die Impfdurchbrüche nur als aggregierte Daten über vier Wochen bereit. Das ist Problematisch, weil erstens die angegebene Impfeffektivität im RKI-Wochenbericht wöchentlich berechnet wird, mit diesen Zahlen also nicht überprüft werden kann. Zweitens ist die Aggregation immer vier Wochen hinter der eigentlichen Entwicklung. Drittens sind Timelags ein möglicher Grund für eine stark verzerrte Berechnung.
Die 4-Wochen-Daten aus den Wochenberichten habe ich zu einer aktualisierten Tabelle zusammengetragen. https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/20211221Impfdurchbrueche.csv

Das RKI stellt aber für die Endpunkte “Symptomatische Erkrankung” und “Hospitalisierung” die wöchentliche Inzidenz unterschieden nach geimpft/ungeimpft zur Verfügung. Aus diesen Werten lassen sich die Anzahl der Impfdurchbrüche für diese beiden Endpunkte rekonstruieren.
Die Abbildungen zeigen die Inzidenzen für verschiedene Altersgruppen.
![Inzidenz Symptomatisch](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Inzidenz_Symp.png)
![Inzidenz Hospitalisiert](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Inzidenz_Hosp.png)
Die Inzidenzen werden berechnet mit:

Inzidenz = Anzahl geimpfter (ungeimpfter) Fälle / (Anzahl geimpfter (ungeimfter) Personen / 100000)

Auflösung der Formel nach “Anzahl Fälle” ergibt:

Anzahl geimpfter Fälle = Inzidenz * Anzahl geimpfter Personen / 100000

# Was ist die Anzahl der Geimpften/Ungeimpften?
Wir brauchen also nur die Anzahl der geimpften (ungeimpften) Personen. Dafür verweist das RKI auf folgenden Link des Statistischen Bundesamts: 
https://www.destatis.de/DE/Themen/Gesellschaft-Umwelt/Bevoelkerung/Bevoelkerungsstand/Tabellen/bevoelkerung-nichtdeutsch-laender.html
Dort sind die Daten, die benötigt werden, aber nicht abrufbar. Es geht um die Bevölkerung Stand 31.12.2020. Diese Daten finden sich unter: https://www-genesis.destatis.de/
Die entsprechende Tabelle wurde im Github-Repository gespeichert. https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Bev%C3%B6lkerung.csv

Aus den Daten lässt sich die Anzahl der 12-17-Jährigen, der 18-59-Jährigen und der Über-60-Jährigen berechnen. Die Abbildung zeigt die Verteilung auf die Altersgruppen.
![Bevölkerung](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Bev%C3%B6lkerung.png
Für die Berechnung der Geimpften und Ungeimpften braucht man die Impfquote für die entsprechende Altersklasse. Da auch der Effekt von Timelags analysiert werden soll, brauchen wir historische Daten. Das RKI stellt diese seit 18.09.2021 in einem Archiv zur Verfügung. Allerdings muss man dafür für jeden Tag eine eigene Datei öffnen und die entsprechende Werte zusammentragen. Wie auch zu allen hier präsentierten Grafiken findet sich der entsprechende Code dafür auf Github.
Die Abbildung zeigt die Quoten für Vollständig Geimpfte über den Zeitverlauf.
![Impfquoten](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Impfquoten.png)
Für die Berechnung der Geimpften und Ungeimpften braucht man die Impfquote für die entsprechende Altersklasse. Da auch der Effekt von Timelags analysiert werden soll, brauchen wir historische Daten. Das RKI stellt diese seit 18.09.2021 in einem Archiv zur Verfügung. Allerdings muss man dafür für jeden Tag eine eigene Datei öffnen und die entsprechende Werte zusammentragen. Wie auch zu allen hier präsentierten Grafiken findet sich der entsprechende Code dafür auf Github.
Die Abbildung zeigt die Quoten für Vollständig Geimpfte über den Zeitverlauf.
![Impfquoten](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Impfquoten.png)
Mit der Impfquote und der Bevölkerungsverteilung lässt sich nun die Anzahl der Geimpften am jeweiligen Tag berechnen, also zum Beispiel Anzahl 60+ multipliziert mit Impfquote/100.

Damit lässt sich nun die Anzahl der Symptomatischen und Hospitalisierten zurückrechnen.
Die Anzahl der Ungeimpften ermittelt das RKI aus der Gesamtzahl der Bevölkerung in der Altersgruppe – die Anzahl der mindestens einmal Geimpften.
![Geimpft/Ungeimpft](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/AnzahlGeimpftUngeimpft.png)
Damit können wir jetzt die Anzahl der Impfdurchbrüche pro Woche berechnen, in dem von der Inzidenz auf diese Zahl zurückgeschlossen wird.
Die Abbildungen zeigen die Entwicklung für die Endpunkte “Symptomatisch” und “Hospitalisiert”.
![Impfdurchbrüche Symptomatisch](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/ImpfdurchbruecheSymp.png)
![Impfdurchbrüche Hospitalisiert](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/ImpfeffektivitaetHosp.png)
Mit diesen Daten lässt sich nun die Impfeffektivität mit der Farrington Formel berechnen. Auf die Schwierigkeiten bei dieser Methode habe ich im ersten Teil der Analyse deutlich hingewiesen. Die Formel lautet:
![Farrington-Formel](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/Farrington-Formel.png)
Mit VE = Impfeffektivität
PCV = Anteil der Geimpften an den Erkrankten
PPV = Anteil der Geimpften an der Grundgesamtheit.

PCV ist also der Anteil der Geimpften an den zuvor wöchentlich ermittelten Impfdurchbrüchen und PPV ist der Anteil der Geimpften an den Geimpften und Ungeimpften zum entsprechenden Zeitpunkt.
Die Abbildung zeigt die rekonstruierte Impfeffektivität für symptomatische Erkrankungen, die mit der Abbildung 18 im RKI-Wochenbericht https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Situationsberichte/Wochenbericht/Wochenbericht_2021-12-23.pdf?__blob=publicationFile
verglichen werden kann.
![Impfeffektivität Symptomatisch](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/ImpfdurchbruecheSymp.png)7
Der Vergleich zeigt, dass die Kurven sehr ähnlich sind, aber nicht identisch. Die Impfeffektivität liegt in dem rekonstruierten Plot unter den Werten, die das RKI angibt. Meine Vermutung ist, dass  das RKI trotz der wöchentlichen Darstellung die aggregierte Impfquote über vier Wochen benutzt, die dann systematisch zu hoch wäre.
Die nächste Abbildung zeigt die Impfeffektivität für den Endpunkt Hospitalisierung.
![Impfeffektivität Hospitalisiert](https://github.com/SimonHegelich/Impfeffektivitaet/blob/main/ImpfeffektivitaetHosp.png)
Auch hier weichen die rekonstruierten Werte leicht von den veröffentlichten Werten ab.
Insgesamt scheint die Rekonstruktion aber ziemlich genau zu sein. Dadurch ergeben sich jetzt die Möglichkeiten, erstens die RKI-Berechnungen im Detail nachzuvollziehen. Zweitens kann man nun andere Szenarien gegen rechnen. Zum Beispiel könnte man sich fragen, wie die Impfeffektivität aussehe, wenn alle Fälle mit unbekanntem Impfstatus geimpft oder ungeimpft wären. 

