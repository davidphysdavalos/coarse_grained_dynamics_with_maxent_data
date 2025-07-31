#!/usr/bin/env wolframscript
(* ::Package:: *)

Import[Directory[]<>"/CoolTools.m"];
Import[Directory[]<>"/Carlos.m"];
Import[Directory[]<>"/Quantum.m"];
Import[Directory[]<>"/ThesisTools.wl"];

Print["This script generates file fig_1_decay_data.csv in this folder \
for specific values of p and r."];

(* ========Parameters========*)
omega = 1;
pList = {0.1, 0.2, 0.3, 0.5};
radius = 0.9;

(*Time values to evaluate*)
tMin = 0;
tMax = Pi;
dt = 0.01;
tValues = Range[tMin, tMax, dt];

(* ========Generate Data========*)
exprList = 
  MapThread[-D[SWAPContractionFactor[t, #2, #1, omega], t]/(4*
       SWAPContractionFactor[t, #2, #1, omega]) &, {Map[
     LagrangeMulFromRadius[radius, {#, 1 - #}] &, pList], pList}];

yData = Table[(expr /. t -> #) & /@ tValues, {expr, exprList}] // 
   Transpose;

(* ========Export Data to CSV========*)
csvData = MapThread[Prepend, {yData, tValues}];
header = Prepend[Map["p1=" <> ToString[#] &, pList], "t"];
finalData = Prepend[csvData, header];
Export[Directory[] <> "/fig_1_decay_data.csv", finalData]
