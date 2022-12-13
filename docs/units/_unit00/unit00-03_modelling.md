---
title: Einstieg ins Modellieren
header:
  image: "/assets/images/00-unit-splash.jpg"
  caption: 'Photo: [**Environmental Informatics Marburg**](https://www.flickr.com/environmentalinformatics-marburg/)'
---

## Das Mammutspiel 
Modellierung kann helfen Prozesse zu verstehen, die intuitiv oft nicht zugänglich sind. Eine große Stärke liegt in der Kombination verschiedener Prozesse und ihrer Wechselwirkungen. Doch auch die einfachste Form eines systemdynamischen Modells kann hilfreich sein um probabilistische Prozesse nachvollziehbar zu machen.

Ein Beispiel soll das [Mammutspiel](static.clexchange.org/ftp/documents/x-curricular/CC2010-11Shape3MammothGameSF.pdf) dienen. 

## Analog
Jede Gruppe bekommt 15 Würfel, die die Mammuts einer Herde darstellen. Jedes Würfeln sympolisiert ein Jahr. Stirbt ein Mammut wird der entsprechnde Würfel aussortiert. Wird ein Mammut geboren kommt ein Würfel dazu. Zur besseren Nachvollziehbarkeit sollte eine Person den Spielstand jeder Runde, also die aktuelle Herdengröße für jedes Jahr in einer Tabelle erfassen und als Graph zeichnen.   



<img src="../assets/images/dice-one.png"> ein Mammutkalb wird geboren<br>
<img src="../assets/images/dice-two.png"> das Mammut wird getötet<br>
<img src="../assets/images/dice-three.png"> das Mammut verhungert<br>
<img src="../assets/images/dice-four.png"> das Mammut lebt ein weiteres Jahr<br>
<img src="../assets/images/dice-five.png"> das Mammut lebt ein weiteres Jahr<br>
<img src="../assets/images/dice-six.png"> das Mammut lebt ein weiteres Jahr<br>
{: .notice--success}


<iframe src="https://openprocessing.org/sketch/100534/embed/" width="400" height="400"></iframe>

## Fragen

* Warum ist die Herde ausgestorben, obwohl Kälber geboren wurden?<br>
* Warum ist der Graph keine Gerade?<br>
* Würde die Herde auch aussterben, wenn sie zu Beginn aus 100 Mammuts bestanden hätte?<br>
* Unter welchen Bedingungen bleibt die Population konstant?
{: .notice--info}


## Erläuterungen

Die Entwicklung der Herdengröße wird durch Feedbacks oder Wirkungskopplungen bestimmt. So erhöhen mehr Mammuts die Anzahl an Geburten, allerdings reduzieren mehr tote Mammuts die Anzahl der Mammuts und damit auch die Todeszahlen.

  <img src="../assets/images/Feedbackloop.png">

Die Modellierung der Herdenentwicklung als Wirkungsdiagramm ist die Grundlage für eine digitale systemdynamische Modellierung. 

## Digital
<iframe src="https://insightmaker.com/insight/7GjbYKkATFtF9ekSXNeyAj/embed?topBar=1&sideBar=1&zoom=1" title="Embedded model" width="800" height="600"></iframe>






