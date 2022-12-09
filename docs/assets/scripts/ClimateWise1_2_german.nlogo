patches-own [
  co2             ;; amount of co2 on this patch
  o2              ;; amount of o2 on this patch
  temp            ;; temp on this patch
  ]

turtles-own [my-temp age x-origin y-origin home-range temp-diff wisdom]

globals [initial-temp max-temp min-temp max-factory min-factory max-forest min-forest action-timer ]

breed [ climate-scientist climate-scientists]
breed [anti-scientist anti-scientists]
breed [ citizen citizens ]
breed [ forest forests ]
breed [ factory factorys ]
breed [policy-makers policy-maker]

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Setup procedures ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

to setup
  clear-all
  set-default-shape policy-makers "building institution"
  create-policy-makers 1   [ set size 1  set color gray  ]
  set-default-shape climate-scientist "citizen student"
  create-climate-scientist no-of-climate-scientists   [ set size 2  set color black  ]
  set-default-shape anti-scientist "person lumberjack"
  create-anti-scientist no-of-anti-scientists  [ set size 3  set color black  ]
  set-default-shape citizen "citizen"
  create-citizen no-of-citizens   [ set size 2  set color black];
  set-default-shape factory "house colonial"
  create-factory initial-no-of-factories   [ set size 2  set color red  ]
   set-default-shape forest "forest"
  create-forest initial-no-of-forests   [ set size 2 set color green  ]

  ask policy-makers [setxy max-pxcor max-pycor]
  ask factory [setxy random-xcor random-ycor]
  ask forest [setxy random-xcor random-ycor]
  ask climate-scientist [set x-origin random-xcor set y-origin  random-ycor setxy x-origin y-origin ]
  ask anti-scientist [set x-origin random-xcor set y-origin  random-ycor setxy x-origin y-origin ]
  ask citizen [set x-origin random-xcor set y-origin  random-ycor setxy x-origin y-origin set wisdom random-normal mean-public-wisdom 0.25]
  set max-factory initial-no-of-factories
  set min-factory initial-no-of-factories
  set max-forest initial-no-of-forests
  set min-forest initial-no-of-forests
  setup-patches
  reset-ticks
 set initial-temp 25
 set min-temp initial-temp
 set min-temp 25 set max-temp 25
end

to setup-patches
  ask patches
  [ recolor-patch ]
end

to recolor-patch  ;; patch procedure
if temp  >= 25 [ set pcolor scale-color red (co2 - o2) 10 0.1 ]
if temp < 25 [ set pcolor scale-color blue (o2 - co2) 10 0.1 ]
end

;;;;;;;;;;;;;;;;;;;;;
;;; Go procedures ;;;
;;;;;;;;;;;;;;;;;;;;;

to go  ;; forever button
  if not any? citizen [ stop ]
  if not any? climate-scientist [ stop ]
  if not any? forest [ stop ]
  if ticks = stop-experiment [stop]

   ask factory
  [ set co2 co2 + 1
    set o2 o2 - 1
    if o2 < 0 [set o2 0]
    set age age + 1
    if age > 500 + random 100 [hatch 1 [setxy random-xcor random-ycor set age 0 set size 2 set color red] ; move factories around
     die]
   ]
     diffuse co2 1

  ask forest
  [set o2 o2 + 1
   set co2 co2 - 1
   if co2 < 0 [set co2 0]
    set age age + 1
    if age > 500 + random 100 [hatch 1 [setxy random-xcor random-ycor set age 0 set size 2 set color green]
      die]
  ]
  diffuse o2 1

if action-timer < 1 [ask policy-makers
  [
  if decision-making-system = "climate-scientist quorum" and count climate-scientist with [color = red]   >= quorum-threshold  and ticks > 1
  ; plant forests and demolish factories occasionally
 [hatch-forest 1 [ setxy random-xcor random-ycor set age  0 set size 2 set color green set action-timer action-interval]  if count factory > 1 [ask one-of factory [die]] ]

 if decision-making-system = "climate-scientist quorum" and count climate-scientist with [color = blue]   >= quorum-threshold  and ticks > 1
 ; build factories and chop down forests forests occasionally
 [hatch-factory 1 [setxy random-xcor random-ycor set size 2 set color red set action-timer action-interval] if count forest > 1 [ask one-of forest [die]] ]

 ;climate-scientists are excluded from the majority vote because they form such a negligable proportion of citizens in real life
 if decision-making-system = "public majority" and  count citizen with [color = red] / count citizen > (majority-threshold / 100) and ticks > 1
 ; plant forests and demolish factories occasionally
 [hatch-forest 1 [ setxy random-xcor random-ycor set age  0 set size 2 set color green set action-timer action-interval ]  if count factory > 1 [ask one-of factory [die]] ]

 if decision-making-system = "public majority" and  count citizen with [color = blue] / count citizen > (majority-threshold / 100) and ticks > 1
 ; build factories and chop down forests forests occasionally
 [hatch-factory 1 [setxy random-xcor random-ycor set size 2 set color red set action-timer action-interval] if count forest > 1 [ask one-of forest [die]] ]
  ]
  ]

ask climate-scientist
  [
    set home-range science-dissemination
    move
    if ticks mod scientist-collection-interval = 0 [collect-data] ; determines interval between data collection
    ]

ask anti-scientist

[
 set home-range anti-science-dissemination
move
if count climate-scientist with [color = blue]   >= quorum-threshold  [set color red]
if count climate-scientist with [color = red]    >= quorum-threshold  [set color blue]
]

ask citizen
 [
  ;mean public wisdom low
  if count anti-scientist-here with [color = red] > 0  and wisdom <= -0.67 [set color red]
  if count anti-scientist-here with [color = blue]  > 0 and wisdom <= -0.67 [set color blue]

  ;mean public wisdom high
  if count climate-scientist-here > 0 and count climate-scientist with [color = red]  >= quorum-threshold and wisdom >= 0.67 [set color red]
  if count climate-scientist-here > 0 and count climate-scientist with [color = blue] >= quorum-threshold and wisdom >= 0.67 [set color blue]
  if count climate-scientist-here > 0 and count climate-scientist with [color = black] >= (no-of-climate-scientists - quorum-threshold) and wisdom >= 0.67 [set color black]

  ;mean public wisdom intermediate
  if count anti-scientist-here with [color = red] > 0  and wisdom > -0.67 and wisdom < 0.67 [set color red]
  if count anti-scientist-here with [color = blue] > 0 and wisdom > -0.67 and wisdom < 0.67  [set color blue]
  if count anti-scientist-here with [color = black]  > 0 and wisdom > -0.67 and wisdom < 0.67 [set color black]
  if count climate-scientist-here > 0 and count climate-scientist with [color = red]  >= quorum-threshold and wisdom > -0.67 and wisdom < 0.67 [set color red]
  if count climate-scientist-here > 0 and count climate-scientist with [color = blue] >= quorum-threshold and wisdom > -0.67 and wisdom < 0.67 [set color blue]
 ]

ask patches [set temp co2 / 8 - o2 / 8 + 25   recolor-patch ]
; temperature not solely dependent on forests and factories

if max-temp < mean [temp] of patches [set max-temp  mean [temp] of patches]
if min-temp > mean [temp] of patches [set min-temp  mean [temp] of patches]
if count factory > max-factory [ set max-factory count factory]
if count factory < min-factory [ set min-factory count factory]
if count forest > max-forest [ set max-forest count forest]
if count forest < min-forest [ set min-forest count forest]
set action-timer action-timer - 1
tick
end


;;;;;;;;;;;;;;;;;;;;;
;;;  Sub-routines ;;;
;;;;;;;;;;;;;;;;;;;;;
to add-factory
hatch-factory 1 [setxy random-xcor random-ycor set size 2 set color red set action-timer action-interval] if count forest > 1 [ask one-of forest [die]]
end

to  add-forest
hatch-forest 1 [ setxy random-xcor random-ycor set age  0 set size 2 set color green set action-timer action-interval]  if count factory > 1 [ask one-of factory [die]]
end

to move
 rt random-float 90 - random-float 90
 fd 1
 if xcor > x-origin + home-range [set xcor x-origin + home-range] ; keep individual within home range
 if xcor < x-origin - home-range [set xcor x-origin - home-range]
 if ycor > y-origin + home-range [set ycor y-origin + home-range]
 if ycor < y-origin - home-range [set ycor y-origin - home-range]
end

to collect-data
set my-temp [temp] of patch-here
set temp-diff my-temp - initial-temp
if temp-diff  >=  temperature-threshold  [set color red]
if temp-diff < temperature-threshold  and temp-diff  > temperature-threshold * -1  [set color black]; undecided catgeory
if temp-diff  <= temperature-threshold * -1  [set color blue]
end

to-report average-temp
  report mean [temp] of patches
end

@#$#@#$#@
GRAPHICS-WINDOW
470
19
976
526
-1
-1
7.0141
1
10
1
1
1
0
0
0
1
-35
35
-35
35
1
1
1
ticks
30.0

BUTTON
11
10
66
43
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
80
11
135
44
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
12
82
228
115
initial-no-of-factories
initial-no-of-factories
0.0
100
55.0
1.0
1
NIL
HORIZONTAL

PLOT
16
421
455
665
The response to climate
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Mean temperature" 1.0 0 -16777216 true "" "plot mean [temp] of patches"
"Scientist - perceivers" 1.0 0 -14070903 true "" "if count climate-scientist > 0 [plot 100 * count climate-scientist with [color = red] / count climate-scientist ]"
"Citizen - perceivers" 1.0 0 -1184463 true "" "if count citizen > 0 [plot 100 * count citizen with [color = red] / count citizen]"
"Forests" 1.0 0 -13840069 true "" "plot count forest"
"Factories" 1.0 0 -2674135 true "" "plot count factory"

SLIDER
12
48
228
81
initial-no-of-forests
initial-no-of-forests
0
100
45.0
1
1
NIL
HORIZONTAL

SLIDER
12
221
228
254
no-of-climate-scientists
no-of-climate-scientists
0
100
20.0
1
1
NIL
HORIZONTAL

BUTTON
150
10
205
43
go once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
352
363
418
408
Mean T
mean [temp] of patches
1
1
11

SLIDER
249
195
450
228
no-of-citizens
no-of-citizens
0
200
200.0
1
1
NIL
HORIZONTAL

SLIDER
12
325
228
358
scientist-collection-interval
scientist-collection-interval
1
1000
10.0
1
1
NIL
HORIZONTAL

SLIDER
250
232
450
265
science-dissemination
science-dissemination
1
20
10.0
1
1
NIL
HORIZONTAL

MONITOR
276
364
342
409
Initial T
initial-temp
0
1
11

MONITOR
275
311
343
356
NIL
max-temp
1
1
11

MONITOR
351
312
419
357
NIL
min-temp
1
1
11

SLIDER
12
256
228
289
quorum-threshold
quorum-threshold
1
50
4.0
1
1
NIL
HORIZONTAL

CHOOSER
12
151
227
196
decision-making-system
decision-making-system
"climate-scientist quorum" "public majority"
0

SLIDER
246
88
451
121
majority-threshold
majority-threshold
50
100
50.0
1
1
%
HORIZONTAL

SLIDER
245
22
449
55
stop-experiment
stop-experiment
1
500001
500000.0
10000
1
NIL
HORIZONTAL

SLIDER
12
116
228
149
action-interval
action-interval
1
1000
500.0
1
1
NIL
HORIZONTAL

SLIDER
12
290
228
323
temperature-threshold
temperature-threshold
0.1
3
0.5
0.1
1
NIL
HORIZONTAL

SLIDER
247
124
451
157
mean-public-wisdom
mean-public-wisdom
-1
1
0.0
.1
1
NIL
HORIZONTAL

SLIDER
249
271
452
304
anti-science-dissemination
anti-science-dissemination
0
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
248
159
451
192
no-of-anti-scientists
no-of-anti-scientists
0
10
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
261
64
438
82
Public majority variables
13
0.0
1

TEXTBOX
12
200
234
218
Climate scientist quorum variables
13
0.0
1

MONITOR
137
366
228
411
NIL
count factory
17
1
11

MONITOR
16
366
119
411
NIL
count forest
17
1
11

@#$#@#$#@
## WAS IST DAS?

Dieses Modell ist inspiriert von Tom Seeleys Arbeit über das Entscheidungssystem von Honigbienen. Es untersucht die Auswirkungen von Entscheidungssystemen und der Verbreitung von Wissenschaft und Anti-Wissenschaft auf den Klimawandel. 

## WIE ES FUNKTIONIERT

Die Menschen haben eine Kolonie auf einem neuen Planeten gegründet. Die Erde hat sich überhitzt. Die Ursache ist umstritten, aber jetzt haben sie die Chance zu einem Neuanfang. Auf diesem Planeten diffundieren der von den Wäldern produzierte Sauerstoff und das von den Fabriken produzierte Kohlendioxid langsam durch die Atmosphäre und bilden Gaspakete. Es gibt drei Arten von menschlichen Akteuren - Klimawissenschaftler, Anti-Wissenschaftler und Bürger. Klimawissenschaftler sammeln Temperaturdaten. Der Benutzer kann zwischen zwei Entscheidungssystemen wählen. Im Falle des Quorums der Klimawissenschaftler ist das System den Honigbienen nachempfunden. Wenn ein Quorum von Wissenschaftlern zustimmt, dass der Klimawandel stattfindet, stimmen die politischen Entscheidungsträger zu, entweder mehr Wälder zu pflanzen und Fabriken abzureißen oder umgekehrt, je nach Richtung der Temperaturveränderung. Im Falle einer öffentlichen Mehrheit muss es einen Mehrheitskonsens geben, bevor Maßnahmen ergriffen werden. 

## WIE MAN ES BENUTZT

Klickt auf die Schaltfläche SETUP, um die Welt einzurichten. 
Klickt auf die Schaltfläche GO, um die Simulation zu starten. 
Wählt das Entscheidungssystem. 

Das action-interval legt das Intervall fest, bevor die nächste Aktion stattfinden kann. Je kleiner diese Zahl ist, desto heftiger ist die Reaktion auf den Klimawandel. 

Der quorum-threshold legt die Anzahl der Wissenschaftler fest, die sich einig sein müssen, dass ein Klimawandel stattfindet (in welcher Richtung auch immer), bevor Maßnahmen ergriffen werden. 

Der temperature-threshold in Grad gibt an, wie groß der Temperaturunterschied sein muss, damit die Klimawissenschaftler einen Klimawandel wahrnehmen. 
Das collection-interval der Wissenschaftler legt das Intervall fest, in dem die Temperaturdaten erhoben werden. Diese beiden Variablen bestimmen, wie gut die Klimawissenschaftler ihre Arbeit machen. Beachtet, dass die Variablen für die öffentliche Mehrheit nicht gelten, wenn das Quorum der Klimawissenschaftler als Entscheidungssystem gewählt wird. 

Die  majority-threshold  legt den Anteil der Bürger fest, die dem Klimawandel zustimmen müssen, bevor Maßnahmen ergriffen werden. 

Die Mean public wisdom legt den Mittelwert einer Normalverteilung für die Weisheit der Bürger fest. Personen mit einem Weisheitswert von 0,67 oder mehr folgen immer den Klimawissenschaftlern. Personen mit einem Weisheitswert von -0,67 oder weniger geben immer den Gegnern von Wissenschaftlern den Vorzug (das Ergebnis ist offensichtlich, wird aber der Vollständigkeit halber angeführt). Personen mit einem Wert  zwischen diesen Werten werden gleichermaßen von Wissenschaftlern und Anti-Wissenschaftlern überzeugt. 

Die Science-dissemination bestimmt, wie mobil die Wissenschaftler sind und damit, wie gut sie den Zustand des Klimas popularisieren. Anti-Wissenschaftler nehmen die gegenteilige Position zu Wissenschaftlern ein. Wenn die anti-science dissemination hoch eingestellt ist können sie ihre gegenteilige Position wirksam verbreiten.

Wenn der public wisdom  Wert hoch eingestellt ist, gilt der Wert für die anti-science dissemination nicht. Der Standardwert für die Verbreitung ist für die anti-science höher angesetzt als für die science, um die Situation in der realen Welt widerzuspiegeln. 

*Zur Eräuterung: Im Zusammenhang mit der globalen Erwärmung ist Lord Christopher Monckton auf YouTube hundertmal so präsent wie John Houghton. Monckton wurde als der weltweit führende Skeptiker der globalen Erwärmung bezeichnet. Er hat jedoch keine einzige von Experten begutachtete wissenschaftliche Arbeit veröffentlicht, geschweige denn in der Klimawissenschaft. Houghton ist Professor für Atmosphärenphysik an der Universität Oxford und Ko-Vorsitzender der Arbeitsgruppe für die wissenschaftliche Bewertung des Zwischenstaatlichen Ausschusses für Klimaänderungen (IPCC). Der IPCC ist ein Gremium von Tausenden von Wissenschaftlern, das die Risiken des Klimawandels umfassend bewertet.*

Graphik: Scientist und citizen-perceivers geben den Prozentsatz der Wissenschaftler und Bürger an, die eine globale Erwärmung akzeptieren. Initial-T ist die anfängliche und ideale Temperatur. Mean-T ist die mittlere tatsächliche Temperatur der Flecken. 

## WAS IST ZU BEACHTEN?

Für einen wirksamen Umgang mit dem Klimawandel muss viel getan werden, sonst könnte das Klima in wilde Schwingungen geraten. Welches Entscheidungssystem auch immer gewählt wird: **Die Datenerfassung muss gut sein und das Intervall der Maßnahmen muss angemessen sein.** 
Falls man sich für das System der öffentlichen Mehrheit entscheidet, muss noch viel mehr getan werden um einem negativen Klimawandel zu begegnen. Aber auch wenn die public wisdom hoch ist, muss die Verbreitung der wissenschaftlichen Erkenntnisse hoch sein.

Wenn das public wisdom mittelmäßig ist, muss die Verbreitung der Wissenschaft drastisch viel höher sein, vor allem, wenn Anti-Wissenschaftler in der Nähe sind und  wenn die anti-science dissemination hoch ist.   

## ERWEITERUNG DES MODELLS

In diesem Modell gibt es keinen Schwellenwert. Eine Möglichkeit, dies umzusetzen, wäre das Absterben der Wälder, wenn die Temperatur zu hoch ist. 

## NETLOGO-FUNKTIONEN

Das Primitiv "diffus" wird für die Diffusion von Sauerstoff und Kohlendioxid verwendet. Die Funktion random-normal wird verwendet, um eine Öffentlichkeit mit einer Normalverteilung der Weisheit zu schaffen.

## LITERATURVERZEICHNIS

Seeley, T. D. (2010) Honeybee Democracy. Princeton University Press, Princeton.

Seeley, T. (2010) The Five Habits of Highly Effective Honeybees (Die fünf Gewohnheiten hocheffektiver Honigbienen). Princeton University Press, Princeton

## Informationen zum Autor

Mike L. Anderson
E-Mail: mike@mikelanderson.com

## COPYRIGHT UND LIZENZ

Copyright 2012 Mike L. Anderson
![CC BY-NC-SA 3.0](http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png)

Dieses Werk ist lizenziert unter der Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  Um eine Kopie dieser Lizenz einzusehen, besuchen Sie http://creativecommons.org/licenses/by-nc-sa/3.0/ oder senden Sie einen Brief an Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

citizen
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

citizen graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

citizen student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

forest
false
0
Rectangle -6459832 true false 135 135 165 300
Polygon -10899396 true false 120 135 90 60 150 15 195 60 180 135
Polygon -10899396 true false 90 165 75 120 105 75 135 120 135 165
Rectangle -6459832 true false 90 165 120 300
Rectangle -6459832 true false 180 165 210 300
Polygon -10899396 true false 180 165 150 120 195 30 240 120 210 165
Rectangle -6459832 true false 45 180 75 300
Polygon -10899396 true false 30 180 0 135 60 75 90 135 90 180
Rectangle -6459832 true false 225 135 255 300
Polygon -10899396 true false 210 135 195 90 240 30 300 90 270 135

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
