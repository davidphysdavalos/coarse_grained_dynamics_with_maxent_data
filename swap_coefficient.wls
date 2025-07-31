#!/usr/bin/env  wolframscript
(* ::Package:: *)

Import[Directory[]<>"/CoolTools.m"];
Import[Directory[]<>"/Carlos.m"];
Import[Directory[]<>"/Quantum.m"];
Import[Directory[]<>"/ThesisTools.wl"];

Print["This script generates file fig_1_inset.csv in this folder for \
specific values of p and r."];


(* ========Parameters========*)
omega = 1;
p = {0.1, 0.2, 0.3, 0.5};
radius = 0.9;

tMin = 0;
tMax = Pi;
dt = 0.01;
tValues = Range[tMin, tMax, dt];

(* ========Generate Data========*)
results = 
  Table[MapThread[
    SWAPContractionFactor[tCurrent, #2, #1, omega] &, {Map[
      LagrangeMulFromRadius[radius, {#, 1 - #}] &, p], p}], {tCurrent,
     tValues}];

(* ========Export Data to CSV========*)
dataToExport = Transpose[Prepend[Transpose[results], tValues]];
headers = Prepend[ToString /@ p, "time"];
Export[Directory[] <> "/fig_1_inset.csv", 
 Prepend[dataToExport, headers]]
