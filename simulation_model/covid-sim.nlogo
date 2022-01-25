extensions [profiler table csv]
__includes ["setup.nls" "people_management.nls" "global_metrics.nls" "environment_dynamics.nls" "animation.nls" "validation/testing.nls" "utils/all_utils.nls"]
breed [people person]

globals [
  slice-of-the-day
  day-of-the-week
  current-day
  #dead-people
  #dead-retired
  #dead-workers
  #dead-students
  #dead-young
  away-gathering-point
  #who-became-sick-while-travelling-locally
  import-scenario-name
]

to go

  reset-timer
  reset-metrics
  reset-economy-measurements
  spread-contagion
  update-within-agent-disease-status
  update-people-mind

  perform-people-activities
  run-economic-cycle
  update-display
  increment-time
  apply-active-measures
  update-metrics
  ;update-tables
  if OVERRIDE-ECONOMY?[ FIX-ECONOMY]
  ; Tick goes at the end of the go procedure for better plot updating
  tick
end

to go-profile
  profiler:reset
  profiler:start

  repeat 10 [go]
  export-profiling
end


to startup
  setup
end

to-report epistemic-accuracy if #infected = 0 [report 1] report count people with [is-infected? and is-believing-to-be-infected?] / #infected end

to-report epistemic-false-positive-error-ratio report count people with [is-believing-to-be-infected? and not is-infected?] / count people end

to-report epistemic-error-of-ignored-immunity-ratio report count people with [not is-believing-to-be-immune? and not is-immune?] / count people end

to FIX-ECONOMY
  ask people with [my-amount-of-capital < 20] [set my-amount-of-capital 20]
end
@#$#@#$#@
GRAPHICS-WINDOW
118
78
525
486
-1
-1
7.824
1
10
1
1
1
0
0
0
1
0
50
0
50
1
1
1
ticks
30.0

BUTTON
12
88
101
123
setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
13
129
105
165
go
go\nif not any? people with [is-contagious?]\n[stop]
T
1
T
OBSERVER
NIL
P
NIL
NIL
1

SLIDER
1984
97
2178
130
propagation-risk
propagation-risk
0
1
0.15
0.01
1
NIL
HORIZONTAL

PLOT
1820
639
2328
967
population status
time
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Uninfected" 1.0 0 -11085214 true "" "plot count people with [infection-status = \"healthy\"]"
"Dead" 1.0 0 -10873583 true "" "plot #dead-people"
"Immune" 1.0 0 -11033397 true "" "plot count people with [infection-status = \"immune\"]"
"Infected" 1.0 0 -2674135 true "" "plot count people with [is-infected?]"
"EInfected" 1.0 0 -1604481 true "" "plot count people with [epistemic-infection-status = \"infected\"]"
"EImmune" 1.0 0 -5516827 true "" "plot count people with [is-believing-to-be-immune?]"
"Inf. Retired" 1.0 0 -10141563 true "" "plot count people with [age = \"retired\" and infection-status = \"infected\"]"
"Healthy" 1.0 0 -12087248 true "" "plot count people with [infection-status = \"healthy\" or infection-status = \"immune\"]"

TEXTBOX
565
689
884
737
Contagion (Proxemics) Model
16
125.0
1

INPUTBOX
829
805
918
865
#schools-gp
14.0
1
0
Number

INPUTBOX
916
805
1009
865
#universities-gp
2.0
1
0
Number

INPUTBOX
1008
805
1101
865
#workplaces-gp
11.0
1
0
Number

TEXTBOX
748
778
1540
798
Number of units per activity type (sharing a unit incurs a transmission risk: due to contact)
11
125.0
1

INPUTBOX
1099
805
1214
865
#public-leisure-gp
12.0
1
0
Number

INPUTBOX
1216
805
1334
865
#private-leisure-gp
76.0
1
0
Number

TEXTBOX
682
476
832
494
Age model
11
53.0
1

SLIDER
642
1033
910
1066
density-factor-schools
density-factor-schools
0
1
0.85
0.01
1
NIL
HORIZONTAL

SLIDER
642
1195
920
1228
density-factor-universities
density-factor-universities
0
1
0.75
0.01
1
NIL
HORIZONTAL

SLIDER
640
990
910
1023
density-factor-workplaces
density-factor-workplaces
0
1
0.75
0.01
1
NIL
HORIZONTAL

SLIDER
642
1155
915
1188
density-factor-public-leisure
density-factor-public-leisure
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
642
1115
915
1148
density-factor-private-leisure
density-factor-private-leisure
0
1
0.95
0.01
1
NIL
HORIZONTAL

SLIDER
642
1075
914
1108
density-factor-homes
density-factor-homes
0
1
0.95
0.01
1
NIL
HORIZONTAL

TEXTBOX
2882
870
3190
916
Measures (Interventions) Model
16
105.0
1

CHOOSER
2987
559
3156
604
global-confinement-measures
global-confinement-measures
"none" "social-distancing" "total-lockdown" "lockdown-10-5" "soft-lockdown-5-2" "social-distancing-testing-tracking-and-tracing"
4

PLOT
10
681
518
831
measures
NIL
NIL
0.0
1.0
0.0
1.0
true
true
"" ""
PENS
"@home" 1.0 0 -7500403 true "" "plot count people with [is-at-home?] / count people"
"watched-kids" 1.0 0 -955883 true "" "plot count children with [is-currently-watched-by-an-adult?] / count children"
"workersWorking@work" 1.0 0 -6459832 true "" "plot count workers with [is-working-at-work?] / count workers"
"working@home" 1.0 0 -1184463 true "" "plot count workers with [is-working-at-home?] / count workers"
"kids@home" 1.0 0 -10899396 true "" "plot count children with [is-at-home?] / count children"

MONITOR
1208
1418
1326
1463
NIL
day-of-the-week
17
1
11

MONITOR
1208
1472
1324
1517
NIL
slice-of-the-day
17
1
11

INPUTBOX
1332
805
1451
865
#essential-shops-gp
5.0
1
0
Number

SLIDER
643
1233
919
1266
density-factor-essential-shops
density-factor-essential-shops
0
1
0.9
0.01
1
NIL
HORIZONTAL

SLIDER
643
1273
918
1306
density-factor-non-essential-shops
density-factor-non-essential-shops
0
1
0.9
0.01
1
NIL
HORIZONTAL

INPUTBOX
1449
805
1609
866
#non-essential-shops-gp
12.0
1
0
Number

INPUTBOX
736
805
832
865
#hospital-gp
1.0
1
0
Number

SLIDER
640
948
909
981
density-factor-hospitals
density-factor-hospitals
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
936
495
1186
528
probability-hospital-personel
probability-hospital-personel
0
1
0.086497678
0.01
1
NIL
HORIZONTAL

SLIDER
941
532
1190
565
probability-school-personel
probability-school-personel
0
1
0.087107961
0.01
1
NIL
HORIZONTAL

SLIDER
938
568
1186
601
probability-university-personel
probability-university-personel
0
1
0.005572074
0.01
1
NIL
HORIZONTAL

SLIDER
941
605
1186
638
probability-shopkeeper
probability-shopkeeper
0
1
0.091423339
0.01
1
NIL
HORIZONTAL

SWITCH
2765
1054
3035
1087
closed-workplaces?
closed-workplaces?
1
1
-1000

SWITCH
2332
951
2518
984
closed-universities?
closed-universities?
1
1
-1000

SWITCH
547
47
658
80
animate?
animate?
1
1
-1000

MONITOR
568
1402
685
1447
NIL
#dead-people
17
1
11

MONITOR
694
1400
797
1445
NIL
#dead-retired
17
1
11

BUTTON
10
206
105
241
1 Week Run
go\nwhile [day-of-the-week != \"monday\" or slice-of-the-day != \"morning\"] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
552
189
655
222
log?
log?
1
1
-1000

TEXTBOX
1901
54
2068
81
Disease Model
16
15.0
1

TEXTBOX
1551
124
1845
157
Time between transitions
11
15.0
1

INPUTBOX
1517
147
1760
207
infection-to-asymptomatic-contagiousness
8.0
1
0
Number

INPUTBOX
1764
147
2101
207
asympomatic-contagiousness-to-symptomatic-contagiousness
16.0
1
0
Number

INPUTBOX
2104
147
2291
207
symptomatic-to-critical-or-heal
7.0
1
0
Number

INPUTBOX
2301
147
2413
207
critical-to-terminal
2.0
1
0
Number

INPUTBOX
2421
147
2540
207
terminal-to-death
7.0
1
0
Number

SLIDER
1707
377
1952
410
probability-unavoidable-death
probability-unavoidable-death
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1711
214
1976
247
probability-self-recovery-symptoms
probability-self-recovery-symptoms
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
1711
314
1980
347
probability-recorvery-if-treated
probability-recorvery-if-treated
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1711
247
2064
280
probability-self-recovery-symptoms-old
probability-self-recovery-symptoms-old
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
1707
344
1980
377
probability-recorvery-if-treated-old
probability-recorvery-if-treated-old
0
1
0.6
0.01
1
NIL
HORIZONTAL

SLIDER
1707
407
1970
440
probability-unavoidable-death-old
probability-unavoidable-death-old
0
1
0.2
0.01
1
NIL
HORIZONTAL

TEXTBOX
547
13
779
53
Simulation management
16
0.0
1

TEXTBOX
589
346
797
384
Demographics Model
16
53.0
1

MONITOR
760
420
929
465
Adults rooming together
count houses-hosting-adults2
17
1
11

MONITOR
1022
420
1130
465
Retired couples
count houses-hosting-retired-couple
17
1
11

MONITOR
936
420
1016
465
Family
count houses-hosting-family
17
1
11

MONITOR
1142
422
1317
467
Multi-generational living
count houses-hosting-multiple-generations
17
1
11

TEXTBOX
4274
321
4429
361
Migration model
16
35.0
1

SLIDER
4297
357
4571
390
probability-infection-when-abroad
probability-infection-when-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
4581
401
4878
434
probability-getting-back-when-abroad
probability-getting-back-when-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

SWITCH
4447
321
4559
354
migration?
migration?
1
1
-1000

SLIDER
1242
1025
1531
1058
density-factor-walking-outside
density-factor-walking-outside
0
1
0.01
0.01
1
NIL
HORIZONTAL

MONITOR
576
1458
640
1503
#@home
count people with [[gathering-type] of current-activity = \"home\"]
17
1
11

MONITOR
636
1458
705
1503
#@school
count people with [[gathering-type] of current-activity = \"school\"]
17
1
11

MONITOR
698
1458
787
1503
#@workplace
count people with [[gathering-type] of current-activity = \"workplace\"]
17
1
11

MONITOR
786
1458
874
1503
#@university
count people with [[gathering-type] of current-activity = \"university\"]
17
1
11

MONITOR
868
1458
945
1503
#@hospital
count people with [[gathering-type] of current-activity = \"hospital\"]
17
1
11

PLOT
10
834
517
1153
Average need satisfaction
time
need satisfaction
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"belonging" 1.0 0 -16777216 true "" "plot mean [belonging-satisfaction-level] of people"
"risk avoidance" 1.0 0 -13345367 true "" "plot mean [risk-avoidance-satisfaction-level] of people"
"autonomy" 1.0 0 -955883 true "" "plot mean [autonomy-satisfaction-level] of people"
"luxury" 1.0 0 -8330359 true "" "plot mean [luxury-satisfaction-level] of people with [not is-child?]"
"health" 1.0 0 -2674135 true "" "plot mean [health-satisfaction-level] of people"
"sleep" 1.0 0 -7500403 true "" "plot mean [sleep-satisfaction-level] of people"
"compliance" 1.0 0 -6459832 true "" "plot mean [compliance-satisfaction-level] of people"
"financial-stability" 1.0 0 -1184463 true "" "plot mean [financial-stability-satisfaction-level] of people with [not is-child?]"
"food-safety" 1.0 0 -14439633 true "" "plot mean [food-safety-satisfaction-level] of people"
"leisure" 1.0 0 -865067 true "" "plot mean [leisure-satisfaction-level] of people"
"financial-survival" 1.0 0 -7858858 true "" "plot mean [financial-survival-satisfaction-level] of people with [not is-child?]"
"conformity" 1.0 0 -12345184 true "" "plot mean [conformity-satisfaction-level] of people"

MONITOR
944
1458
1014
1503
#@leisure
count people with [member? \"leisure\" [gathering-type] of current-activity]
17
1
11

MONITOR
1010
1458
1112
1503
#@essential-shop
count people with [[gathering-type] of current-activity = \"essential-shop\"]
17
1
11

MONITOR
1114
1458
1189
1503
#@NEshop
count people with [[gathering-type] of current-activity = \"non-essential-shop\"]
17
1
11

SWITCH
1831
97
1970
130
with-infected?
with-infected?
0
1
-1000

MONITOR
2528
1168
2749
1213
NIL
closed-schools?
17
1
11

SWITCH
2528
1052
2750
1085
is-closing-school-when-any-reported-case-measure?
is-closing-school-when-any-reported-case-measure?
1
1
-1000

SLIDER
676
530
924
563
ratio-family-homes
ratio-family-homes
0
1
0.352
0.01
1
NIL
HORIZONTAL

SLIDER
2530
949
2752
982
ratio-omniscious-infected-that-trigger-school-closing-measure
ratio-omniscious-infected-that-trigger-school-closing-measure
0
1
1.0
0.01
1
NIL
HORIZONTAL

INPUTBOX
2528
988
2751
1049
#days-trigger-school-closing-measure
10000.0
1
0
Number

SLIDER
2765
954
3033
987
ratio-omniscious-infected-that-trigger-non-essential-closing-measure
ratio-omniscious-infected-that-trigger-non-essential-closing-measure
0
1
1.0
0.01
1
NIL
HORIZONTAL

INPUTBOX
2765
985
3034
1046
#days-trigger-non-essential-business-closing-measure
10000.0
1
0
Number

MONITOR
2765
1094
3038
1139
NIL
closed-non-essential?
17
1
11

SLIDER
676
495
928
528
ratio-adults-homes
ratio-adults-homes
0
1
0.330714286
0.01
1
NIL
HORIZONTAL

SLIDER
676
565
924
598
ratio-retired-couple-homes
ratio-retired-couple-homes
0
1
0.282785714
0.01
1
NIL
HORIZONTAL

SLIDER
675
602
927
635
ratio-multi-generational-homes
ratio-multi-generational-homes
0
1
0.0345
0.01
1
NIL
HORIZONTAL

SLIDER
1711
277
2065
310
factor-reduction-probability-transmission-young
factor-reduction-probability-transmission-young
0
1
0.69
0.01
1
NIL
HORIZONTAL

PLOT
21
1713
533
1863
Average amount of capital per people age
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
"worker" 1.0 0 -13345367 true "" "plot workers-average-amount-of-capital"
"retired" 1.0 0 -955883 true "" "plot retirees-average-amount-of-capital"
"student" 1.0 0 -13840069 true "" "plot students-average-amount-of-capital"

PLOT
21
1868
533
2018
Amount of capital per gathering point
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
"essential-shop" 1.0 0 -16777216 true "" "plot essential-shop-amount-of-capital"
"non-essential-shop" 1.0 0 -13345367 true "" "plot non-essential-shop-amount-of-capital"
"university" 1.0 0 -955883 true "" "plot university-amount-of-capital"
"hospital" 1.0 0 -13840069 true "" "plot hospital-amount-of-capital"
"workplace" 1.0 0 -2674135 true "" "plot workplace-amount-of-capital"
"school" 1.0 0 -6917194 true "" "plot school-amount-of-capital"

PLOT
1113
1658
1575
1808
Total amount of capital available in the system
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
"total" 1.0 0 -16777216 true "" "plot total-amount-of-capital-in-the-system"
"government-reserve" 1.0 0 -13345367 true "" "plot government-reserve-of-capital"

SLIDER
561
2001
772
2034
ratio-tax-on-essential-shops
ratio-tax-on-essential-shops
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
556
2061
768
2094
ratio-tax-on-non-essential-shops
ratio-tax-on-non-essential-shops
0
1
0.52
0.01
1
NIL
HORIZONTAL

SLIDER
556
2101
768
2134
ratio-tax-on-workplaces
ratio-tax-on-workplaces
0
1
0.55
0.01
1
NIL
HORIZONTAL

SLIDER
556
2138
768
2171
ratio-tax-on-workers
ratio-tax-on-workers
0
1
0.37
0.01
1
NIL
HORIZONTAL

TEXTBOX
558
1963
801
1994
Taxes charged by the government
11
25.0
1

TEXTBOX
786
2163
1010
2192
Distribution of government subsidy
11
25.0
1

SLIDER
781
2223
954
2256
ratio-hospital-subsidy
ratio-hospital-subsidy
0
1
0.04
0.01
1
NIL
HORIZONTAL

SLIDER
781
2258
954
2291
ratio-university-subsidy
ratio-university-subsidy
0
1
0.03
0.01
1
NIL
HORIZONTAL

SLIDER
781
2183
953
2216
ratio-school-subsidy
ratio-school-subsidy
0
1
0.03
0.01
1
NIL
HORIZONTAL

CHOOSER
583
379
743
424
household-profiles
household-profiles
"Custom" "Belgium" "Canada" "Germany" "Great Britain" "France" "Italy" "Korea South" "Netherlands" "Norway" "Spain" "Singapore" "Sweden" "U.S.A." "World"
14

SLIDER
3063
939
3350
972
ratio-population-randomly-tested-daily
ratio-population-randomly-tested-daily
0
1
0.0
0.01
1
NIL
HORIZONTAL

SWITCH
3065
1019
3355
1052
test-workplace-of-confirmed-people?
test-workplace-of-confirmed-people?
1
1
-1000

SWITCH
3065
980
3354
1013
test-home-of-confirmed-people?
test-home-of-confirmed-people?
1
1
-1000

TEXTBOX
3180
915
3330
933
Testing
11
105.0
1

SLIDER
553
1788
765
1821
price-of-rations-in-essential-shops
price-of-rations-in-essential-shops
0.5
10
2.8
0.1
1
NIL
HORIZONTAL

PLOT
23
2023
534
2173
Accumulated amount of goods in stock per type of business
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
"essential-shop" 1.0 0 -16777216 true "" "plot essential-shop-amount-of-goods-in-stock"
"non-essential-shop" 1.0 0 -13345367 true "" "plot non-essential-shop-amount-of-goods-in-stock"
"workplace" 1.0 0 -2674135 true "" "plot workplace-amount-of-goods-in-stock"

SLIDER
556
2198
765
2231
goods-produced-by-work-performed
goods-produced-by-work-performed
1
50
12.0
1
1
NIL
HORIZONTAL

SLIDER
556
2236
765
2269
unit-price-of-goods
unit-price-of-goods
0.1
5
2.5
0.1
1
NIL
HORIZONTAL

SWITCH
668
47
781
80
static-seed?
static-seed?
1
1
-1000

CHOOSER
548
89
790
134
preset-scenario
preset-scenario
"none" "scenario-7-cultural-model"
1

MONITOR
762
373
850
418
#children
count children
17
1
11

MONITOR
860
372
931
417
#students
count students
17
1
11

MONITOR
937
372
1003
417
#workers
count workers
17
1
11

MONITOR
1008
373
1067
418
#retired
count retireds
17
1
11

TEXTBOX
2602
929
2751
948
Closing schools\n
11
105.0
1

TEXTBOX
2845
929
2995
947
Closing workplaces
11
105.0
1

TEXTBOX
2365
925
2515
943
Closing universities
11
105.0
1

TEXTBOX
941
475
1261
524
Worker distribution (relevant for economic model)
11
53.0
1

TEXTBOX
563
788
723
863
Density factors:\nRelative proximity between individuals within an activity type (impacts contamination risks).
10
125.0
1

TEXTBOX
1243
976
1545
1032
Density settings influence risk of becoming sick when travelling locally (is related with contagion model)
11
65.0
1

TEXTBOX
3375
1095
3550
1126
All people at home are tested if one is confirmed sick.
9
105.0
1

TEXTBOX
3375
1139
3557
1168
All people at work are tested if one is confirmed sick.
9
105.0
1

TEXTBOX
3000
534
3195
562
General Lockdown Measures
11
105.0
1

TEXTBOX
571
1708
721
1734
Economic Model
16
25.0
1

BUTTON
803
98
1061
133
load scenario-specific parameter settings
load-scenario-specific-parameter-settings
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

SLIDER
553
1828
749
1861
days-of-rations-bought
days-of-rations-bought
1
28
3.0
1
1
NIL
HORIZONTAL

SLIDER
4297
397
4572
430
probability-going-abroad
probability-going-abroad
0
1
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
1104
1402
1161
1447
#away
count people with [is-away?]
17
1
11

MONITOR
808
1402
1088
1447
NIL
#who-became-sick-while-travelling-locally
17
1
11

SWITCH
786
2441
986
2474
government-pays-wages?
government-pays-wages?
1
1
-1000

SLIDER
786
2481
1057
2514
ratio-of-wage-paid-by-the-government
ratio-of-wage-paid-by-the-government
0
1
0.8
0.01
1
NIL
HORIZONTAL

INPUTBOX
786
2523
985
2583
government-initial-reserve-of-capital
10000.0
1
0
Number

SLIDER
556
2276
774
2309
max-stock-of-goods-in-a-shop
max-stock-of-goods-in-a-shop
0
1000
500.0
10
1
NIL
HORIZONTAL

SLIDER
781
2058
1051
2091
starting-amount-of-capital-workers
starting-amount-of-capital-workers
0
100
75.0
1
1
NIL
HORIZONTAL

SLIDER
781
2091
1052
2124
starting-amount-of-capital-retired
starting-amount-of-capital-retired
0
100
40.0
1
1
NIL
HORIZONTAL

SLIDER
781
2123
1065
2156
starting-amount-of-capital-students
starting-amount-of-capital-students
0
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
2975
817
3329
850
social-distancing-density-factor
social-distancing-density-factor
0
1
0.3
0.01
1
NIL
HORIZONTAL

TEXTBOX
3326
1273
3476
1291
Social distancing
11
105.0
1

SLIDER
2977
783
3331
816
ratio-omniscious-infected-that-trigger-social-distancing-measure
ratio-omniscious-infected-that-trigger-social-distancing-measure
0
0.05
0.02
0.01
1
NIL
HORIZONTAL

MONITOR
2975
731
3260
776
NIL
was-social-distancing-enforced?
17
1
11

PLOT
1118
1828
1484
1978
Velocity of money in total system
NIL
NIL
0.0
10.0
0.0
0.5
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot velocity-of-money-in-total-system"

PLOT
1118
1993
1485
2143
Goods production of total system
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot goods-production-of-total-system"

PLOT
1503
1828
1913
1978
Number of adult people out of capital
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
"total" 1.0 0 -16777216 true "" "plot #adult-people-out-of-capital"
"worker" 1.0 0 -13345367 true "" "plot #workers-out-of-capital"
"retired" 1.0 0 -955883 true "" "plot #retired-out-of-capital"
"student" 1.0 0 -10899396 true "" "plot #students-out-of-capital"

PLOT
1503
1988
1914
2138
Number of gathering points out of capital
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
"essential-shop" 1.0 0 -16777216 true "" "plot #essential-shops-out-of-capital"
"non-essential-shop" 1.0 0 -13345367 true "" "plot #non-essential-shops-out-of-capital"
"university" 1.0 0 -955883 true "" "plot #universities-out-of-capital"
"hospital" 1.0 0 -13840069 true "" "plot #hospitals-out-of-capital"
"workplace" 1.0 0 -2674135 true "" "plot #workplaces-out-of-capital"
"school" 1.0 0 -8630108 true "" "plot #schools-out-of-capital"

PLOT
23
2186
532
2350
Activities
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
"@Work" 1.0 0 -14070903 true "" "plot count people with [is-at-work?]"
"@Pu-Leisure" 1.0 0 -2674135 true "" "plot count people with [is-at-public-leisure-place?]"
"@Pr-Leisure" 1.0 0 -955883 true "" "plot count people with [is-at-private-leisure-place?]"
"@Home" 1.0 0 -14439633 true "" "plot count people with [is-at-home?]"
"@Univ" 1.0 0 -4079321 true "" "plot count people with [is-at-university?]"
"Treated" 1.0 0 -7500403 true "" "plot count people with [current-motivation = treatment-motive]"
"@E-Shop" 1.0 0 -8630108 true "" "plot count people-at-essential-shops"
"@NE-Shop" 1.0 0 -5825686 true "" "plot count people-at-non-essential-shops"

SLIDER
553
1751
725
1784
workers-wages
workers-wages
0
30
9.0
0.5
1
NIL
HORIZONTAL

SLIDER
3281
561
3591
594
mean-social-distance-profile
mean-social-distance-profile
0
1
0.5
0.01
1
NIL
HORIZONTAL

INPUTBOX
582
495
662
558
#households
400.0
1
0
Number

MONITOR
582
438
657
483
#people
count people
17
1
11

MONITOR
568
1352
793
1397
NIL
#people-saved-by-hospitalization
17
1
11

MONITOR
1416
2421
1592
2466
NIL
#hospital-workers
17
1
11

MONITOR
1236
2370
1402
2415
NIL
#essential-shop-workers
17
1
11

MONITOR
1416
2368
1591
2413
NIL
#non-essential-shop-workers
17
1
11

MONITOR
800
1352
1038
1397
NIL
#denied-requests-for-hospital-beds
17
1
11

MONITOR
1238
2423
1401
2468
NIL
#university-workers
17
1
11

MONITOR
1416
2476
1589
2521
NIL
#school-workers
17
1
11

MONITOR
1048
1350
1330
1395
NIL
#people-dying-due-to-lack-of-hospitalization
17
1
11

MONITOR
1236
2478
1399
2523
NIL
#workplace-workers
17
1
11

SLIDER
3281
604
3593
637
std-dev-social-distance-profile
std-dev-social-distance-profile
0
1
0.1
0.01
1
NIL
HORIZONTAL

MONITOR
3278
731
3435
776
#social-distancing
count people with [is-I-apply-social-distancing?]
17
1
11

PLOT
23
2361
522
2511
Number of workers actually working at each gathering point
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
"essential-shop" 1.0 0 -16777216 true "" "plot #workers-working-at-essential-shop"
"non-essential-shop" 1.0 0 -13345367 true "" "plot #workers-working-at-non-essential-shop"
"university" 1.0 0 -955883 true "" "plot #workers-working-at-university"
"hospital" 1.0 0 -13840069 true "" "plot #workers-working-at-hospital"
"workplace" 1.0 0 -2674135 true "" "plot #workers-working-at-workplace"
"school" 1.0 0 -8630108 true "" "plot #workers-working-at-school"

SLIDER
551
1873
777
1906
price-of-rations-in-non-essential-shops
price-of-rations-in-non-essential-shops
0.5
10
2.68
0.1
1
NIL
HORIZONTAL

BUTTON
548
141
614
174
import
ask-user-for-import-file\nload-scenario-from-file
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
619
141
688
174
export
ask-user-for-export-file\nsave-world-state
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
2864
237
3044
282
NIL
hospital-effectiveness
17
1
11

SLIDER
3065
1200
3359
1233
ratio-population-daily-immunity-testing
ratio-population-daily-immunity-testing
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
2187
97
2537
130
daily-risk-believe-experiencing-fake-symptoms
daily-risk-believe-experiencing-fake-symptoms
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
1405
923
1671
956
ratio-workers-and-retired-owning-cars
ratio-workers-and-retired-owning-cars
0
1
0.512867692
0.01
1
NIL
HORIZONTAL

INPUTBOX
1565
1005
1721
1065
#bus-per-timeslot
10.0
1
0
Number

INPUTBOX
1563
1070
1719
1130
#max-people-per-bus
20.0
1
0
Number

MONITOR
1725
1080
1920
1125
#people-staying-out-queuing
count people with [stayed-out-queuing-for-bus?]
17
1
11

SLIDER
1242
1063
1531
1096
density-factor-queuing
density-factor-queuing
0
1
0.3
0.01
1
NIL
HORIZONTAL

SLIDER
1242
1100
1531
1133
density-factor-public-transport
density-factor-public-transport
0
1
0.95
0.01
1
NIL
HORIZONTAL

MONITOR
1725
1015
1914
1060
NIL
#people-denied-bus
17
1
11

BUTTON
10
248
102
283
1 Month Run
let starting-day current-day\nlet end-day starting-day + 28\nwhile [current-day <= end-day] [ go ]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
3289
117
3569
162
load-country-specific-settings
load-country-specific-settings
"Custom" "Belgium" "Canada" "Germany" "Great Britain" "France" "Italy" "Korea South" "Netherlands" "Norway" "Spain" "Singapore" "Sweden" "U.S.A." "World" "NoCluster" "ClusterA" "ClusterB" "ClusterC" "ClusterD" "ClusterE"
14

SLIDER
3281
257
3455
290
uncertainty-avoidance
uncertainty-avoidance
0
100
43.45
1
1
NIL
HORIZONTAL

SLIDER
3467
257
3682
290
individualism-vs-collectivism
individualism-vs-collectivism
0
100
77.82
1
1
NIL
HORIZONTAL

SLIDER
3284
297
3456
330
power-distance
power-distance
0
100
32.09
1
1
NIL
HORIZONTAL

SLIDER
3471
297
3685
330
indulgence-vs-restraint
indulgence-vs-restraint
0
100
67.64
1
1
NIL
HORIZONTAL

SLIDER
3281
334
3455
367
masculinity-vs-femininity
masculinity-vs-femininity
0
100
39.64
1
1
NIL
HORIZONTAL

SLIDER
3471
337
3686
370
long-vs-short-termism
long-vs-short-termism
0
100
38.09
1
1
NIL
HORIZONTAL

SLIDER
3924
521
4147
554
value-system-calibration-factor
value-system-calibration-factor
0
40
20.0
1
1
NIL
HORIZONTAL

SLIDER
3281
401
3474
434
survival-multiplier
survival-multiplier
0
3
2.5
0.1
1
NIL
HORIZONTAL

SLIDER
3481
397
3731
430
maslow-multiplier
maslow-multiplier
0
1
0.0
0.01
1
NIL
HORIZONTAL

TEXTBOX
3388
11
3896
32
Country-Based Cultural Profile Model
16
83.0
1

SLIDER
4581
361
4889
394
owning-solo-transportation-probability
owning-solo-transportation-probability
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
2545
1319
2860
1352
ratio-of-people-using-the-tracking-app
ratio-of-people-using-the-tracking-app
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
3656
1526
3882
1559
percentage-news-watchers
percentage-news-watchers
0
1
1.0
0.01
1
NIL
HORIZONTAL

MONITOR
2886
1396
3179
1441
#recorded-contacts-in-tracing-app
average-number-of-people-recorded-by-recording-apps
4
1
11

INPUTBOX
2449
1453
2609
1514
#days-recording-tracing
7.0
1
0
Number

MONITOR
3375
1180
3503
1225
NIL
#tests-performed
17
1
11

BUTTON
10
288
103
323
go once
go
NIL
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
10
328
105
363
inspect person
inspect one-of people
NIL
1
T
OBSERVER
NIL
I
NIL
NIL
1

BUTTON
3656
1482
3879
1517
NIL
inform-people-of-measures
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
3281
441
3473
474
weight-survival-needs
weight-survival-needs
0
1
0.5
0.01
1
NIL
HORIZONTAL

TEXTBOX
3284
176
3618
203
Hofstede dimension settings
11
83.0
1

TEXTBOX
3924
501
4121
531
Agent value system settings
11
83.0
1

TEXTBOX
3284
377
3474
395
Agent need system settings
11
83.0
1

CHOOSER
4161
67
4363
112
network-generation-method
network-generation-method
"random" "value-similarity"
1

TEXTBOX
4164
34
4400
80
Social Network Model
16
115.0
1

SLIDER
4161
117
4405
150
peer-group-friend-links
peer-group-friend-links
1
150
7.0
1
1
NIL
HORIZONTAL

SLIDER
786
2001
958
2034
productivity-at-home
productivity-at-home
0
2
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
4161
161
4449
194
percentage-of-agents-with-random-link
percentage-of-agents-with-random-link
0
1
0.15
0.01
1
NIL
HORIZONTAL

SLIDER
2542
1279
2862
1312
ratio-of-anxiety-avoidance-tracing-app-users
ratio-of-anxiety-avoidance-tracing-app-users
0
1
1.0
0.01
1
NIL
HORIZONTAL

BUTTON
4164
204
4321
237
Write network as dot
write-network-to-file user-new-file
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
2886
1260
3179
1305
#tracing-app-users
count people with [is-user-of-tracking-app?]
17
1
11

BUTTON
678
436
741
469
set
load-population-profile-based-on-current-preset-profile
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1513
2156
2089
2352
Macro Economic Model - Capital Flow
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
"agriculture-essential" 1.0 0 -16777216 true "" "plot total-capital-agriculture-essential"
"agriculture-luxury" 1.0 0 -13345367 true "" "plot total-capital-agriculture-luxury"
"manufacturing-essential" 1.0 0 -955883 true "" "plot total-capital-manufacturing-essential"
"manufacturing-luxury" 1.0 0 -13840069 true "" "plot total-capital-manufacturing-luxury"
"services-essential" 1.0 0 -2674135 true "" "plot total-capital-services-essential"
"services-luxury" 1.0 0 -8630108 true "" "plot total-capital-services-luxury"
"education-research" 1.0 0 -13791810 true "" "plot total-capital-education-research"
"households-sector" 1.0 0 -6459832 true "" "plot total-capital-households-sector"
"government-sector" 1.0 0 -5825686 true "" "plot total-capital-government-sector"

TEXTBOX
3314
497
3724
527
Agent social distancing and quarantining settings
11
83.0
1

PLOT
1628
2363
2086
2513
Macro Economic Model - International Sector
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
"international-sector" 1.0 0 -14835848 true "" "plot total-capital-international-sector"

SWITCH
1308
2193
1502
2226
close-services-luxury?
close-services-luxury?
1
1
-1000

PLOT
1926
1828
2266
1978
Number of adult people in poverty
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
"total" 1.0 0 -16777216 true "" "plot count people with [not is-young? and is-in-poverty?]"
"worker" 1.0 0 -13345367 true "" "plot count workers with [is-in-poverty?]"
"retired" 1.0 0 -955883 true "" "plot count retireds with [is-in-poverty?]"
"students" 1.0 0 -13840069 true "" "plot count students with [is-in-poverty?]"

PLOT
1926
1988
2254
2138
Histogram of available capital
my-amount-of-capital
counts
0.0
500.0
0.0
10.0
true
true
"foreach [\"worker\" \"retired\" \"student\"] [ pen ->\n  set-current-plot-pen pen\n  set-plot-pen-mode 1\n]\nset-histogram-num-bars 500" ""
PENS
"worker" 1.0 0 -13345367 true "" "histogram [my-amount-of-capital] of workers"
"retired" 1.0 0 -955883 true "" "histogram [my-amount-of-capital] of retireds"
"student" 1.0 0 -13840069 true "" "histogram [my-amount-of-capital] of students"

PLOT
11
1178
529
1426
Quality of Life Indicator
Time
Quality of Life
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"Mean" 1.0 0 -13840069 true "" "plot mean [change-of-quality-of-life-indicator-compared-to-setup] of people"
"Median" 1.0 0 -14454117 true "" "plot median [change-of-quality-of-life-indicator-compared-to-setup] of people"
"Min" 1.0 0 -2674135 true "" "plot min [change-of-quality-of-life-indicator-compared-to-setup] of people"
"Max" 1.0 0 -1184463 true "" "plot max [change-of-quality-of-life-indicator-compared-to-setup] of people"

TEXTBOX
22
13
210
55
ASSOCC
32
14.0
1

TEXTBOX
2605
1253
2773
1296
Tracing (smartphone app)
11
105.0
1

SWITCH
3281
524
3589
557
make-social-distance-profile-value-based?
make-social-distance-profile-value-based?
0
1
-1000

MONITOR
2864
134
3048
179
NIL
#healthy-hospital-personel
17
1
11

MONITOR
2864
187
3046
232
NIL
#sick-hospital-personel
17
1
11

SLIDER
1203
2306
1503
2339
government-sector-subsidy-ratio
government-sector-subsidy-ratio
0
1
0.0
0.01
1
NIL
HORIZONTAL

PLOT
2093
2363
2528
2513
Macro Economic Model - Central Bank
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
"reserve-of-capital" 1.0 0 -16777216 true "" "plot sum [reserve-of-capital] of central-banks"
"total-credit" 1.0 0 -13345367 true "" "plot sum [total-credit] of central-banks"

PLOT
2101
2156
2640
2350
Macro Economic Model - Debt
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
"agriculture-essential" 1.0 0 -16777216 true "" "plot total-debt-agriculture-essential"
"agriculture-luxury" 1.0 0 -13345367 true "" "plot total-debt-agriculture-luxury"
"manufacturing-essential" 1.0 0 -955883 true "" "plot total-debt-manufacturing-essential"
"manufacturing-luxury" 1.0 0 -13840069 true "" "plot total-debt-manufacturing-luxury"
"services-essential" 1.0 0 -2674135 true "" "plot total-debt-services-essential"
"services-luxury" 1.0 0 -8630108 true "" "plot total-debt-services-luxury"
"education-research" 1.0 0 -13791810 true "" "plot total-debt-education-research"
"households-sector" 1.0 0 -6459832 true "" "plot total-debt-households-sector"

PLOT
2538
2363
2950
2513
Macro Economic Model - Government Debt
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
"debt" 1.0 0 -16777216 true "" "plot total-debt-government-sector"

SLIDER
1198
2231
1503
2264
services-luxury-ratio-of-expenditures-when-closed
services-luxury-ratio-of-expenditures-when-closed
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
1201
2266
1502
2299
services-luxury-ratio-of-income-when-closed
services-luxury-ratio-of-income-when-closed
0
1
0.0
0.01
1
NIL
HORIZONTAL

SLIDER
2618
1449
2849
1482
ratio-young-with-phones
ratio-young-with-phones
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
2618
1488
2857
1521
ratio-retired-with-phones
ratio-retired-with-phones
0
1
1.0
0.01
1
NIL
HORIZONTAL

MONITOR
2886
1442
3179
1487
#phone-owners
count people with [has-mobile-phone?]
17
1
11

MONITOR
2886
1489
3175
1534
ratio-phone-owners
count people with [has-mobile-phone?] / count people
17
1
11

SLIDER
1308
2156
1502
2189
interest-rate-by-tick
interest-rate-by-tick
0
0.01
0.001
0.0001
1
NIL
HORIZONTAL

CHOOSER
2041
44
2179
89
disease-fsm-model
disease-fsm-model
"assocc" "oxford"
1

MONITOR
1711
451
1910
496
NIL
r0
17
1
11

INPUTBOX
3525
1170
3643
1231
#available-tests
10000.0
1
0
Number

SWITCH
3065
1055
3356
1088
prioritize-testing-health-care?
prioritize-testing-health-care?
1
1
-1000

BUTTON
12
168
104
201
1 Day run
if slice-of-the-day = \"morning\" [go]\nwhile [slice-of-the-day != \"morning\"] [go]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
3065
1125
3357
1158
do-not-test-youth?
do-not-test-youth?
0
1
-1000

SWITCH
3065
1165
3359
1198
only-test-retirees-with-extra-tests?
only-test-retirees-with-extra-tests?
1
1
-1000

MONITOR
3138
1858
3285
1903
#Violating quarantine
count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]
17
1
11

MONITOR
3290
1859
3439
1904
#Quarantiners
count should-be-isolators
17
1
11

SWITCH
2339
1672
2751
1705
food-delivered-to-isolators?
food-delivered-to-isolators?
0
1
-1000

PLOT
3138
1708
3516
1858
Quarantining & isolation
time
#people
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"breaking isolation" 1.0 0 -2674135 true "" "plot count people with [is-officially-asked-to-quarantine? and not is-in-quarantine?]"
"of. quarantiners" 1.0 0 -11085214 true "" "plot count people with [is-officially-asked-to-quarantine?]"
"online supplying" 1.0 0 -7171555 true "" "plot  #delivered-supply-proposed-this-tick"
"sick quarantiners" 1.0 0 -13791810 true "" "plot count people with [is-officially-asked-to-quarantine? and is-believing-to-be-infected?]"
"pen-4" 1.0 0 -2064490 true "" "plot count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]"

TEXTBOX
2845
1559
2995
1580
Self-isolation
11
105.0
1

SLIDER
2763
1712
3081
1745
ratio-self-quarantining-when-a-family-member-is-symptomatic
ratio-self-quarantining-when-a-family-member-is-symptomatic
0
1
1.0
0.01
1
NIL
HORIZONTAL

SWITCH
2763
1586
3077
1619
is-infected-and-their-families-requested-to-stay-at-home?
is-infected-and-their-families-requested-to-stay-at-home?
1
1
-1000

SWITCH
2339
1587
2754
1620
all-self-isolate-for-35-days-when-first-hitting-2%-infected?
all-self-isolate-for-35-days-when-first-hitting-2%-infected?
1
1
-1000

MONITOR
2340
1623
2752
1668
NIL
start-tick-of-global-quarantine
17
1
11

PLOT
2554
134
2856
274
hospitals
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
"#taken-beds" 1.0 0 -2674135 true "" "plot #taken-hospital-beds"
"#available-beds" 1.0 0 -10899396 true "" "plot #beds-available-for-admission"

SLIDER
2763
1668
3078
1701
ratio-self-quarantining-when-symptomatic
ratio-self-quarantining-when-symptomatic
0
1
0.0
0.01
1
NIL
HORIZONTAL

MONITOR
2452
785
2737
830
NIL
is-hard-lockdown-active?
17
1
11

CHOOSER
2545
1359
2855
1404
when-is-tracing-app-active?
when-is-tracing-app-active?
"always" "never" "7-days-before-end-of-global-quarantine" "at-end-of-global-quarantine" "RNaught-based"
1

SWITCH
2535
1409
2857
1442
is-tracking-app-testing-immediately-recursive?
is-tracking-app-testing-immediately-recursive?
0
1
-1000

MONITOR
2886
1352
3182
1397
NIL
is-tracing-app-active?
17
1
11

MONITOR
2886
1306
3182
1351
#people-ever-recorded-as-positive-in-the-app
count people-having-ever-been-recorded-as-positive-in-the-app
17
1
11

CHOOSER
3370
1004
3641
1049
when-is-daily-testing-applied?
when-is-daily-testing-applied?
"always" "never" "7-days-before-end-of-global-quarantine" "at-end-of-global-quarantine" "RNaught-based"
1

MONITOR
3370
945
3583
990
NIL
#tests-used-by-daily-testing
17
1
11

SWITCH
3065
1090
3357
1123
prioritize-testing-education?
prioritize-testing-education?
1
1
-1000

SWITCH
2763
1626
3076
1659
is-psychorigidly-staying-at-home-when-quarantining?
is-psychorigidly-staying-at-home-when-quarantining?
1
1
-1000

TEXTBOX
2479
1557
2629
1575
Global quarantine
11
105.0
1

SWITCH
662
190
834
223
log-contamination?
log-contamination?
1
1
-1000

SWITCH
549
233
804
266
log-preferred-activity-decision?
log-preferred-activity-decision?
1
1
-1000

TEXTBOX
1256
926
1444
949
Transport Model
16
65.0
1

SWITCH
550
271
663
304
log-setup?
log-setup?
1
1
-1000

SLIDER
3481
441
3733
474
financial-stability-learning-rate
financial-stability-learning-rate
0
1
0.05
0.01
1
NIL
HORIZONTAL

SWITCH
810
234
973
267
clear-log-on-setup?
clear-log-on-setup?
0
1
-1000

PLOT
2084
217
2424
393
contacts
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
"hospitals" 1.0 0 -16777216 true "" "plot  #contacts-in-hospitals"
"workplaces" 1.0 0 -7500403 true "" "plot  #contacts-in-workplaces"
"homes" 1.0 0 -2674135 true "" "plot  #contacts-in-homes"
"pub-lei" 1.0 0 -955883 true "" "plot  #contacts-in-public-leisure"
"pri-lei" 1.0 0 -6459832 true "" "plot  #contacts-in-private-leisure"
"schools" 1.0 0 -1184463 true "" "plot  #contacts-in-schools"
"univ" 1.0 0 -10899396 true "" " plot #contacts-in-universities"
"e-shops" 1.0 0 -13840069 true "" "plot  #contacts-in-essential-shops"
"ne-shops" 1.0 0 -14835848 true "" " plot #contacts-in-non-essential-shops"
"pub-trans" 1.0 0 -11221820 true "" "plot  #contacts-in-pubtrans"
"priv-trans" 1.0 0 -13791810 true "" " plot #contacts-in-shared-cars"
"queuing" 1.0 0 -13345367 true "" "plot  #contacts-in-queuing"

PLOT
2084
404
2416
584
infection per age
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
"R-Y" 1.0 0 -8053223 true "" "plot #cumulative-youngs-infected"
"R-S" 1.0 0 -7171555 true "" "plot #cumulative-students-infected"
"R-W" 1.0 0 -15040220 true "" "plot #cumulative-workers-infected"
"R-R" 1.0 0 -13403783 true "" "plot #cumulative-retireds-infected"
"S-Y" 1.0 0 -2139308 true "" "plot #cumulative-youngs-infector"
"S-S" 1.0 0 -987046 true "" "plot #cumulative-students-infector"
"S-W" 1.0 0 -8732573 true "" "plot #cumulative-workers-infector"
"S-R" 1.0 0 -11033397 true "" "plot #cumulative-retireds-infector"

MONITOR
3135
1911
3494
1956
NIL
ratio-quarantiners-currently-complying-to-quarantine
17
1
11

SWITCH
839
189
1010
222
log-violating-quarantine?
log-violating-quarantine?
1
1
-1000

SWITCH
2339
1713
2748
1746
keep-retired-quarantined-forever-if-global-quarantine-is-fired-global-measure?
keep-retired-quarantined-forever-if-global-quarantine-is-fired-global-measure?
1
1
-1000

SLIDER
3924
561
4157
594
influence-of-age-on-value-system
influence-of-age-on-value-system
0
25
5.0
1
1
NIL
HORIZONTAL

TEXTBOX
559
726
1125
766
Proxemics is represented as \"meeting spaces\" people can move into and be infected or spread infection.\nAs simplifications: each person relates to a fix set of spaces over time (same school, bus, bar) and gets in contact with everyone sharing this space; no contamination due to left germs.
10
125.0
1

CHOOSER
2191
44
2329
89
contagion-model
contagion-model
"oxford"
0

PLOT
1714
504
1979
625
avg-infectiousity per person
NIL
NIL
0.0
1.0
0.0
0.01
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "ifelse not any? people with [is-infected?] [plot 0]\n[plot mean [oxford-contagion-factor-between self (one-of people) (one-of gathering-points)] of people with [is-infected?]]"

MONITOR
2765
1762
3090
1807
NIL
count people with [is-officially-asked-to-quarantine?]
17
1
11

SLIDER
968
2261
1164
2294
ratio-parents-subsidy
ratio-parents-subsidy
0
1
0.1
0.01
1
NIL
HORIZONTAL

SLIDER
551
1913
779
1946
amount-of-rations-I-buy-when-going-to-shops
amount-of-rations-I-buy-when-going-to-shops
0
10
7.0
1
1
NIL
HORIZONTAL

TEXTBOX
1624
237
1706
294
ASSOCC\nincremental\nmodel\n(deprecated)
11
15.0
1

SWITCH
2765
1145
3040
1178
is-working-from-home-recommended?
is-working-from-home-recommended?
1
1
-1000

CHOOSER
3259
1633
3394
1678
condition-phasing-out
condition-phasing-out
"35 days of quarantine" "#infected has decreased since 5 days ago" "hospital not overrun & #hospitalizations has decreased since 5 days ago" "never"
3

SWITCH
2526
1086
2751
1119
close-schools-during-global-quarantine?
close-schools-during-global-quarantine?
1
1
-1000

TEXTBOX
3132
1593
3282
1611
Conditions for phasing out
11
105.0
1

MONITOR
3405
1633
3614
1678
NIL
current-governmental-model-phase
17
1
11

CHOOSER
3115
1633
3261
1678
condition-for-acknowledging-the-crisis
condition-for-acknowledging-the-crisis
"ratio infected>2%" "never"
1

CHOOSER
2526
1120
2748
1165
force-reopening-of-schools-after-phase
force-reopening-of-schools-after-phase
"never" "phase-1"
0

SWITCH
543
1653
725
1686
OVERRIDE-ECONOMY?
OVERRIDE-ECONOMY?
0
1
-1000

TEXTBOX
421
1596
950
1645
Solution for overriding the now-deprecated/unmaintained economy model.\nAt the start of each tick, people with less than 20 get 20$, so they don't end-up starving.
11
25.0
1

SWITCH
3656
1570
4021
1603
Aware-of-working-at-home-at-start-of-simulation?
Aware-of-working-at-home-at-start-of-simulation?
1
1
-1000

SWITCH
3656
1608
4020
1641
Aware-of-social-distancing-at-start-of-simulation?
Aware-of-social-distancing-at-start-of-simulation?
1
1
-1000

TEXTBOX
3706
1446
3919
1467
Awareness of Measures
11
105.0
1

INPUTBOX
781
2303
876
2363
retirees-tick-subsidy
3.0
1
0
Number

INPUTBOX
881
2306
1036
2366
students-tick-subsidy
1.5
1
0
Number

INPUTBOX
781
2371
1000
2431
parent-individual-subsidy-per-child-per-tick
2.0
1
0
Number

TEXTBOX
3754
251
3942
274
Cultural tightness settings
11
83.0
1

SWITCH
3754
277
4012
310
activate-intra-cultural-variation?
activate-intra-cultural-variation?
0
1
-1000

SLIDER
3757
317
3985
350
cultural-tightness
cultural-tightness
0
100
50.0
1
1
NIL
HORIZONTAL

SWITCH
3597
524
3894
557
is-decision-to-quarantine-value-based?
is-decision-to-quarantine-value-based?
0
1
-1000

SLIDER
3754
437
4039
470
cultural-tightness-function-modifier
cultural-tightness-function-modifier
0
0.2
0.0
1
1
NIL
HORIZONTAL

SLIDER
3757
357
3930
390
min-value-std-dev
min-value-std-dev
1
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
3754
397
3929
430
max-value-std-dev
max-value-std-dev
10
20
15.0
1
1
NIL
HORIZONTAL

CHOOSER
3284
196
3529
241
hofstede-schwartz-mapping-mode
hofstede-schwartz-mapping-mode
"theoretical" "empirical" "empirical & theoretical" "old settings"
0

SWITCH
3584
48
3956
81
sync-cultural-and-demographic-settings?
sync-cultural-and-demographic-settings?
0
1
-1000

CHOOSER
3583
86
3955
131
cultural-model-experimentation
cultural-model-experimentation
"default-cultural-model-settings" "no-policy-measures" "only-social-distancing" "social-distancing-soft-lockdown" "social-distancing-hard-lockdown" "social-distancing-tracking-tracing-testing-isolating"
3

TEXTBOX
3292
50
3579
73
General settings
11
83.0
1

MONITOR
4027
274
4129
319
NIL
value-std-dev
4
1
11

SLIDER
3944
397
4164
430
max-random-value-generator
max-random-value-generator
50
100
60.0
1
1
NIL
HORIZONTAL

SLIDER
3944
361
4166
394
min-random-value-generator
min-random-value-generator
0
50
20.0
1
1
NIL
HORIZONTAL

SLIDER
2455
655
2873
688
#days-agent-R-naught-remains-in-population-Rnaught-after-moment-of-recovery
#days-agent-R-naught-remains-in-population-Rnaught-after-moment-of-recovery
0
14
7.0
1
1
NIL
HORIZONTAL

PLOT
2441
297
2775
417
R-Naught of people recovered within last week
NIL
NIL
0.0
10.0
0.0
2.0
true
true
"" ""
PENS
"R-Naught" 1.0 0 -16777216 true "" "plot R-naught"

MONITOR
2441
544
2624
589
#Consecutive ticks R-Naught < 1
consecutive-ticks-R-naught-is-<-one
17
1
11

MONITOR
2441
487
2628
532
# Consecutive ticks R-naught >= 1
consecutive-ticks-R-naught-is->=-one
17
1
11

CHOOSER
2978
609
3202
654
global-confinement-metric
global-confinement-metric
"infection-ratio" "RNaught"
1

SLIDER
2454
697
2856
730
#consecutive-ticks-Rnaught-exceeds-1-to-trigger-implementing-measures
#consecutive-ticks-Rnaught-exceeds-1-to-trigger-implementing-measures
0
42
12.0
1
1
NIL
HORIZONTAL

SLIDER
2451
737
2855
770
#consecutive-ticks-Rnaught-is-below-1-to-trigger-lifting-measures
#consecutive-ticks-Rnaught-is-below-1-to-trigger-lifting-measures
0
42
0.0
1
1
NIL
HORIZONTAL

SWITCH
3658
1645
4026
1678
Aware-of-corona-virus-at-start-of-simulation?
Aware-of-corona-virus-at-start-of-simulation?
1
1
-1000

PLOT
1360
1228
2128
1570
Number of infected per location
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
"pubtrans" 1.0 0 -16777216 true "" "plot #people-infected-in-pubtrans"
"queuing" 1.0 0 -7500403 true "" "plot  #people-infected-in-queuing"
"gen-travel" 1.0 0 -2674135 true "" "plot #people-infected-in-general-travel"
"hospitals" 1.0 0 -955883 true "" "plot #people-infected-in-hospitals"
"workplaces" 1.0 0 -6459832 true "" "plot #people-infected-in-workplaces"
"homes" 1.0 0 -1184463 true "" "plot #people-infected-in-homes"
"public-leisure" 1.0 0 -8630108 true "" "plot #people-infected-in-public-leisure"
"private-leisure" 1.0 0 -13840069 true "" "plot  #people-infected-in-private-leisure"
"schools" 1.0 0 -14835848 true "" "plot #people-infected-in-schools"
"universities" 1.0 0 -11221820 true "" "plot #people-infected-in-universities"
"essen shops" 1.0 0 -13791810 true "" "plot #people-infected-in-essential-shops"
"non-essen shops" 1.0 0 -13345367 true "" "plot #people-infected-in-non-essential-shops"

TEXTBOX
945
901
1202
936
Density Factor Calibration Settings
12
125.0
1

SLIDER
939
926
1161
959
ventilation-weight
ventilation-weight
1
4
4.0
1
1
NIL
HORIZONTAL

SLIDER
939
966
1159
999
sterility-weight
sterility-weight
1
4
2.0
1
1
NIL
HORIZONTAL

SLIDER
941
1008
1160
1041
length-visit-time-weight
length-visit-time-weight
1
4
1.0
1
1
NIL
HORIZONTAL

SLIDER
941
1048
1160
1081
crowdedness-weight
crowdedness-weight
1
4
3.0
1
1
NIL
HORIZONTAL

SLIDER
941
1089
1160
1122
max-density-factor
max-density-factor
0.5
1
0.95
0.01
1
NIL
HORIZONTAL

SLIDER
942
1129
1158
1162
min-density-factor
min-density-factor
0
0.5
0.01
0.01
1
NIL
HORIZONTAL

CHOOSER
642
894
911
939
density-factor-computation
density-factor-computation
"default" "mapping: ranked" "mapping: proportional"
2

BUTTON
9
373
106
407
inspect gp
inspect one-of gathering-points
NIL
1
T
OBSERVER
NIL
J
NIL
NIL
1

SLIDER
2444
437
2767
470
contagion-factor
contagion-factor
1
20
5.0
0.05
1
NIL
HORIZONTAL

MONITOR
3706
1293
4090
1338
NIL
is-social-distancing-testing-tracking-and-tracing-active?
17
1
11

MONITOR
3705
1349
4092
1394
NIL
is-quarantining-measure-active?
17
1
11

MONITOR
2451
841
2733
886
NIL
is-soft-lockdown-active?
17
1
11

TEXTBOX
2621
624
2809
647
RNaught Settings
12
15.0
1

MONITOR
2633
485
2828
530
NIL
rnaught-exceeds-1-for-first-time?
17
1
11

MONITOR
2643
542
2861
587
NIL
R-Naught
17
1
11

SLIDER
2980
662
3213
695
infection-rate-based-trigger
infection-rate-based-trigger
0
0.06
0.08
0.005
1
NIL
HORIZONTAL

MONITOR
2877
550
2976
595
% infected
ratio-infected * 100
4
1
11

CHOOSER
1622
816
1767
861
gp-scaling-mode
gp-scaling-mode
"cultural branch" "default ASSOCC"
0

CHOOSER
253
18
447
63
model-branch
model-branch
"ASSOCC master branch" "cultural branch"
1

MONITOR
549
579
661
624
NIL
population-size
4
1
11

SLIDER
2874
94
3046
127
#beds-in-hospital
#beds-in-hospital
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
794
46
966
79
#random-seed
#random-seed
0
1000
999.0
1
1
NIL
HORIZONTAL

SWITCH
1134
59
1337
92
sensitivity-analysis?
sensitivity-analysis?
1
1
-1000

TEXTBOX
1139
30
1388
50
Global Sensitivity Analysis (GSA)
12
0.0
1

BUTTON
1134
244
1346
278
NIL
show lhs_matrix
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1135
160
1340
193
lhs_experiment_number
lhs_experiment_number
0
2000
161.0
1
1
NIL
HORIZONTAL

BUTTON
1134
202
1344
236
NIL
setup-lhs-parameter-settings
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
3291
76
3573
109
manual-calibration-of-cultural-vars?
manual-calibration-of-cultural-vars?
1
1
-1000

CHOOSER
1136
104
1342
149
GSA_purpose
GSA_purpose
"Cultural Model GSA" "Cultural Model Experimentation"
1

CHOOSER
3581
176
3958
221
load-country-hofstede-scores
load-country-hofstede-scores
"Belgium" "Canada" "Germany" "Great Britain" "France" "Italy" "Korea South" "Netherlands" "Norway" "Spain" "Singapore" "Sweden" "U.S.A." "World" "NoCluster" "ClusterA" "ClusterB" "ClusterC" "ClusterD" "ClusterE"
15

SWITCH
3583
137
3961
170
control-for-non-cultural-country-specific-factors?
control-for-non-cultural-country-specific-factors?
0
1
-1000

PLOT
3176
2060
3617
2287
Value system Person X
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" "update-value-plot"
PENS

TEXTBOX
1796
775
1946
887
S1 -> S3 = 4% \nS3 -> S2 = 4% \nS2 -> S3 = 8%\nContagiousness-fct = 5\nSocial-distancing-fct = 0.3\nNO SD NO SQ Stage 2\nCluster E
11
0.0
0

MONITOR
1622
648
1816
693
NIL
#agents-breaking-soft-lockdown
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

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

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

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

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

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

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

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

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="S7-REB3-ClusNo" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;NoCluster&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7-REB3-ClusA" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;ClusterA&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7-REB3-ClusB" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;ClusterB&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7-REB3-ClusC" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;ClusterC&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7-REB3-ClusD" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;ClusterD&quot;"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="S7-REB3-ClusE" repetitions="150" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go
if not any? people with [is-contagious?]
[stop]</go>
    <final>output-print (word "Execution of run " behaviorspace-run-number " finished in " timer " seconds")</final>
    <metric>cultural-tightness</metric>
    <metric>uncertainty-avoidance</metric>
    <metric>power-distance</metric>
    <metric>masculinity-vs-femininity</metric>
    <metric>individualism-vs-collectivism</metric>
    <metric>indulgence-vs-restraint</metric>
    <metric>long-vs-short-termism</metric>
    <metric>global-confinement-measures</metric>
    <metric>global-confinement-metric</metric>
    <metric>count people</metric>
    <metric>r0</metric>
    <metric>R-naught</metric>
    <metric>#taken-hospital-beds</metric>
    <metric>#beds-available-for-admission</metric>
    <metric>#dead-people</metric>
    <metric>count people with [is-infected?]</metric>
    <metric>count people with [epistemic-infection-status = "infected"]</metric>
    <metric>count people with [is-believing-to-be-immune?]</metric>
    <metric>count people with [infection-status = "healthy"]</metric>
    <metric>count people with [infection-status = "immune"]</metric>
    <metric>count people with [infection-status = "healthy" or infection-status = "immune"]</metric>
    <metric>count people with [epistemic-infection-status = "immune"]</metric>
    <metric>count people with [I-know-of-social-distancing?]</metric>
    <metric>count people with [is-I-apply-social-distancing?]</metric>
    <metric>count people with [I-know-of-working-from-home?]</metric>
    <metric>#tests-performed</metric>
    <metric>#tests-used-by-daily-testing</metric>
    <metric>count people with [is-user-of-tracking-app?]</metric>
    <metric>count people with [has-mobile-phone?]</metric>
    <metric>count people with [has-mobile-phone?] / count people</metric>
    <metric>count people-having-ever-been-recorded-as-positive-in-the-app</metric>
    <metric>average-number-of-people-recorded-by-recording-apps</metric>
    <metric>count people with [has-been-tested-immune?]</metric>
    <metric>mean [number-of-people-I-infected] of people</metric>
    <metric>standard-deviation [number-of-people-I-infected] of people</metric>
    <metric>mean [social-distance-profile] of people</metric>
    <metric>standard-deviation [social-distance-profile] of people</metric>
    <metric>rnaught-exceeds-1-for-first-time?</metric>
    <metric>consecutive-ticks-R-naught-is-&lt;-one</metric>
    <metric>consecutive-ticks-R-naught-is-&gt;=-one</metric>
    <metric>when-has-2%-infected-threshold-first-been-met?</metric>
    <metric>when-has-5%-infected-threshold-first-been-met?</metric>
    <metric>is-social-distancing-measure-active?</metric>
    <metric>was-social-distancing-enforced?</metric>
    <metric>is-hard-lockdown-active?</metric>
    <metric>is-hard-lockdown-measure-activated?</metric>
    <metric>is-soft-lockdown-active?</metric>
    <metric>is-soft-lockdown-measure-activated?</metric>
    <metric>is-social-distancing-testing-tracking-and-tracing-active?</metric>
    <metric>is-quarantining-measure-active?</metric>
    <metric>is-tracing-app-active?</metric>
    <metric>closed-schools?</metric>
    <metric>closed-non-essential?</metric>
    <metric>Aware-of-social-distancing-at-start-of-simulation?</metric>
    <metric>Aware-of-working-at-home-at-start-of-simulation?</metric>
    <metric>Aware-of-corona-virus-at-start-of-simulation?</metric>
    <metric>#youngs-at-start</metric>
    <metric>#students-at-start</metric>
    <metric>#workers-at-start</metric>
    <metric>#retireds-at-start</metric>
    <metric>ratio-adults-homes</metric>
    <metric>ratio-family-homes</metric>
    <metric>ratio-retired-couple-homes</metric>
    <metric>ratio-multi-generational-homes</metric>
    <metric>#essential-shop-workers</metric>
    <metric>#university-workers</metric>
    <metric>#workplace-workers</metric>
    <metric>#non-essential-shop-workers</metric>
    <metric>#hospital-workers</metric>
    <metric>#school-workers</metric>
    <metric>count gathering-points with [gathering-type = "hospital"]</metric>
    <metric>count gathering-points with [gathering-type = "university"]</metric>
    <metric>count gathering-points with [gathering-type = "home"]</metric>
    <metric>count gathering-points with [gathering-type = "school"]</metric>
    <metric>count gathering-points with [gathering-type = "public-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "private-leisure"]</metric>
    <metric>count gathering-points with [gathering-type = "essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "non-essential-shop"]</metric>
    <metric>count gathering-points with [gathering-type = "workplace"]</metric>
    <metric>count gathering-points with [gathering-type = "public-transport"]</metric>
    <metric>count people with [is-officially-asked-to-quarantine?]</metric>
    <metric>count should-be-isolators</metric>
    <metric>count should-be-isolators with [current-activity != my-home and current-activity != my-hospital and current-activity != away-gathering-point]</metric>
    <metric>ratio-quarantiners-currently-complying-to-quarantine</metric>
    <metric>#people-infected-in-hospitals</metric>
    <metric>#people-infected-in-workplaces</metric>
    <metric>#people-infected-in-homes</metric>
    <metric>#people-infected-in-public-leisure</metric>
    <metric>#people-infected-in-private-leisure</metric>
    <metric>#people-infected-in-schools</metric>
    <metric>#people-infected-in-universities</metric>
    <metric>#people-infected-in-essential-shops</metric>
    <metric>#people-infected-in-non-essential-shops</metric>
    <metric>#people-infected-in-pubtrans</metric>
    <metric>#people-infected-in-shared-cars</metric>
    <metric>#people-infected-in-queuing</metric>
    <metric>#contacts-last-tick</metric>
    <metric>#contacts-in-pubtrans</metric>
    <metric>#contacts-in-shared-cars</metric>
    <metric>#contacts-in-queuing</metric>
    <metric>#contacts-in-hospitals</metric>
    <metric>#contacts-in-workplaces</metric>
    <metric>#contacts-in-homes</metric>
    <metric>#contacts-in-public-leisure</metric>
    <metric>#contacts-in-private-leisure</metric>
    <metric>#contacts-in-schools</metric>
    <metric>#contacts-in-universities</metric>
    <metric>#contacts-in-essential-shops</metric>
    <metric>#contacts-in-non-essential-shops</metric>
    <metric>#cumulative-youngs-infected</metric>
    <metric>#cumulative-students-infected</metric>
    <metric>#cumulative-workers-infected</metric>
    <metric>#cumulative-retireds-infected</metric>
    <metric>#cumulative-youngs-infector</metric>
    <metric>#cumulative-students-infector</metric>
    <metric>#cumulative-workers-infector</metric>
    <metric>#cumulative-retireds-infector</metric>
    <metric>count people with [is-infected? and age = "young"]</metric>
    <metric>count people with [is-infected? and age = "student"]</metric>
    <metric>count people with [is-infected? and age = "worker"]</metric>
    <metric>count people with [is-infected? and age = "retired"]</metric>
    <metric>ratio-infected</metric>
    <metric>ratio-infected-youngs</metric>
    <metric>ratio-infected-students</metric>
    <metric>ratio-infected-workers</metric>
    <metric>ratio-infected-retireds</metric>
    <metric>#hospitalizations-youngs-this-tick</metric>
    <metric>#hospitalizations-students-this-tick</metric>
    <metric>#hospitalizations-workers-this-tick</metric>
    <metric>#hospitalizations-retired-this-tick</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections young-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections student-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections worker-age retired-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age young-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age student-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age worker-age</metric>
    <metric>ratio-age-group-to-age-group-#infections retired-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts young-age young-age</metric>
    <metric>age-group-to-age-group-#contacts young-age student-age</metric>
    <metric>age-group-to-age-group-#contacts young-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts young-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts student-age young-age</metric>
    <metric>age-group-to-age-group-#contacts student-age student-age</metric>
    <metric>age-group-to-age-group-#contacts student-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts student-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age young-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age student-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts worker-age retired-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age young-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age student-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age worker-age</metric>
    <metric>age-group-to-age-group-#contacts retired-age retired-age</metric>
    <metric>mean [sleep-satisfaction-level] of people</metric>
    <metric>mean [conformity-satisfaction-level] of people</metric>
    <metric>mean [risk-avoidance-satisfaction-level] of people</metric>
    <metric>mean [compliance-satisfaction-level] of people</metric>
    <metric>mean [belonging-satisfaction-level] of people</metric>
    <metric>mean [leisure-satisfaction-level] of people</metric>
    <metric>mean [luxury-satisfaction-level] of people</metric>
    <metric>mean [autonomy-satisfaction-level] of people</metric>
    <metric>min [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>max [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>mean [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>standard-deviation [change-of-quality-of-life-indicator-compared-to-setup] of people</metric>
    <metric>#bad-behaving-agents</metric>
    <metric>current-stage</metric>
    <metric>#agents-breaking-soft-lockdown</metric>
    <metric>TRANSFORM-LIST! contamination-network-table ","</metric>
    <metric>TRANSFORM-LIST! location-violating-quarantining-list ","</metric>
    <metric>TRANSFORM-LIST! needs-weight-table ","</metric>
    <metric>TRANSFORM-LIST! value-weight-table  ","</metric>
    <metric>TRANSFORM-LIST! value-mean-std-table  ","</metric>
    <metric>TRANSFORM-LIST! needs-mean-std-table ","</metric>
    <enumeratedValueSet variable="static-seed?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="sensitivity-analysis?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="manual-calibration-of-cultural-vars?">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="model-branch">
      <value value="&quot;cultural branch&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="preset-scenario">
      <value value="&quot;scenario-7-cultural-model&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="cultural-model-experimentation">
      <value value="&quot;social-distancing-soft-lockdown&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-specific-settings">
      <value value="&quot;World&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="hofstede-schwartz-mapping-mode">
      <value value="&quot;theoretical&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="contagion-factor">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="load-country-hofstede-scores">
      <value value="&quot;ClusterE&quot;"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
