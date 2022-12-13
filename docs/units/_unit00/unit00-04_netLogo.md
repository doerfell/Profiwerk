---
title: Agentenbasierte Modelierung 
header:
  image: "/assets/images/greedy-splash.png"
  caption: 'Photo: **Rieke Ammoneit**'
---


## Idee
Nachdem wir uns in das Verständnis der Nachhaltigkeit eingearbeitet und uns mit dem systemdynamischen Weltmodell beschäftigt haben soll es nun noch etwas "wirklicher" werden. Der systemdynamischen Modellierung mangelt es hierfür an dem Raum. Akteure (Menschen, Tiere, Pflanzen etc.) handeln und wechselwirken im Raum. Ich muss vor einem Baum stehen um ihn zu fällen oder eine Kuh muss auf der Weide sein um Gras abweiden zu können.
Gleichzeitig ist es sehr schwer das Handeln z.B. einer Kuh in Bezug auf das Fressen von Gras in eine mathematische Gleichung zu fassen. Eher folgt es Regeln (z.B. "friß das saftigste Gras im Umkreis von einem Meter und gehe weiter")

Ihr sollt nun ein einfaches NetLogo-Modell nutzen, um Aussagen über nachhaltiges Verhalten zu treffen. 

Im Workshoppfad solltet ihr hier ca. 45 Minuten verwenden.
{: .notice--success}

<!--more-->

### Agentbasierter Modellierung ein interaktiver Einstieg
Zum Einstieg machen wir ein kurzes Spiel.

### Die NetLogo Modellierungssoftware
Wir benötigen die Software NetLogo. Falls NetLogo auf euren Rechnern nicht installiert sein, könnt ihr die freie Software in einer passenden Version für euer Betriebssystem auf der [Download-Seite](https://ccl.northwestern.edu/netlogo/6.2.0/) herunterladen und installieren. Vor allem wenn ihr über unseren Workshop hinaus ein wenig stöbern und ausprobieren wollt ist diese Variante sinnvoll.

Falls ihr mit der lokalen Installation von NetLogo arbeitet, ladet ihr bitte die Modelldatei [nachhaltigesWirtschaften.nlogo]({{ site.baseurl }}/assets/scripts/nachhaltigesWirtschaften.nlogo){:target="_blank"} herunter und speichert sie an einem geeigneten Ort ab. Dann könnt ihr das Modell mit NetLogo öffnen
{: .notice--info}


Habt ihr keine Lust auf eine Installation oder sollte es beim Download Probleme geben könnt ihr auch mit der der hier unten eingebetten Online-Variante arbeiten. Ihr könnt das nachstehende Online-Modell mit einem Klick auf den Button "NetLogo exportieren" und herunterladen um es mit einer lokalen Installation von NetLogo öffnen.

{% include media url="/assets/misc/Mammoths.html" %}

### NetLogo Modell Cooperation
Das Modell Cooperation und die Adaption funktionieren beide nach den gleichen Grundregel:

* die Kühe essen auf dem Feld auf dem sie sich befinden Gras und erhalten dadurch Energie
* haben sie genug Energie reproduzieren sie sich
* haben sie zu wenig Energie sterben sie
* sie gehen nach jedem Zeitschritt weiter auf ein neues Grasfeld
* das Gras wächst nach; halbhohes Gras schneller als ganz abgefressenes Gras

* es gibt nachhaltige gehaltene Kühe (cooperative cows) und gierige Kühe (greedy cows)
* die cooperative cows essen nur hohes Gras und fressen es bis zur Hälfte ab
* die greedy cows essen sowohl hohes als auch halb hohes Gras 

### Probiert doch mal aus...
Nach dem ihr jetzt das Modell entweder hier auf der Webseite oder mit Hilfe eurer lokalen Installation nutzen könnt ist es spannend einfach mal ein paar Dinge auszuprobieren. 

Versucht einmal folgende Fragen zu beantworten in dem ihr die Einstellungen der Modellwelt durch die Schieberegeler anpasst:

* wie viele nachhaltig gehaltenen Kühe auf der Weide leben können
* wie viele Kühe in nicht nachhaltiger Haltung auf die Weide passen
* welche Kühe bei gemischter Haltung kurzfristig und welche Kühe langfristig dominieren
* was scheint euch ein optimales Ergebnis zu sein? Warum?


## In den Rucksack...

Die Regeln für die Nutzung von Ressourcen sollten klar definiert und so einfach wie möglich sein. 
Regeln müssen von den Akteuren akzeptiert werden bzw. das gemeinsam definierte Nutzungsziel muss erreicht werden.
Die Entwicklung, Akzeptanz und Durchsetzung (Schieberegler!) von Regel sind die Basis der kollektiven Nutzung von Ressourcen.
Damit wir keine (vermutlich nicht-umkehrbaren) Experimente an der echten Welt machen müssen können wir mit spezieller Modellierungssoftwar (NetLogo, Insightmaker...) vereinfachte Modelle entwickeln und testen.

## Lust auf mehr?
Ein [Tutorial](https://ccl.northwestern.edu/netlogo/docs/tutorial1.html) zum Einstieg in NetLogo. 

Mehr zum Hintergund von [Cooperation](http://ccl.northwestern.edu/rp/each/index.shtml).
