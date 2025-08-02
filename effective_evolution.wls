#!/usr/bin/env wolframscript
(*::Package::*)

Print["Generating data. They can be \
plotted using ListLinePlot."]

args = $ScriptCommandLine;
n = ToExpression[args[[2]]];
J = ToExpression[args[[3]]];
label = args[[4]];

(* ========Parameters========*)
p1 = 0.5;
\[Mu] = 1.5;
\[Sigma] = 0.2;
tc = 2*Pi/\[Sigma];
tf = 4*tc;
steps = Round[tc*100];
r = 0.8;
x = 0.9; y = 0.0; z = 0.2;
rvec = r*Normalize[{x, y, z}];
pvec = Prepend[Table[(1 - p1)/(n - 1), n - 1], p1];
seed = 1234;

(* ========Functions========*)

OmegaGenerator[n_, \[Mu]_, \[Sigma]_, seed_] := 
 Module[{}, SeedRandom[seed];
  \[Omega] = RandomVariate[NormalDistribution[\[Mu], \[Sigma]], n];
  \[Omega][[1]] = \[Mu]; \[Omega]]

LagrangeMulFromRadius[r_, p_] := 
 FindRoot[
   Sum[p[[k]]  Tanh[p[[k]]*\[Lambda]], {k, 1, Length[p]}] - r == 
    0, {\[Lambda], 1}][[1, 2]]

EvolutionWithInteraction[rhovec_, prvec_, J_, freqs_, time_] := 
 Module[{lag = LagrangeMulFromRadius[Norm[rhovec], prvec], 
   unit = Normalize[rhovec]}, 
  rkx[k_] := (unit[[1]]*Cos[freqs[[k]]*time] - 
     unit[[2]]*Sin[freqs[[k]]*time]);
  rky[k_] := (unit[[1]]*Sin[freqs[[k]]*time] + 
     unit[[2]]*Cos[freqs[[k]]*time]);
  {Cos[J*time]*
    Sum[prvec[[k]]*Tanh[prvec[[k]]*lag]*rkx[k], {k, 1, 
      Length[prvec]}], 
   Cos[J*time]*
    Sum[prvec[[k]]*Tanh[prvec[[k]]*lag]*rky[k], {k, 1, 
      Length[prvec]}], rhovec[[3]]}]

CreateData[rvec_, pvec_, J_, \[Omega]_, tend_, steps_] := 
  Table[EvolutionWithInteraction[rvec, pvec, J, \[Omega], 
     t][[1 ;; 2]], {t, 0, tend, tend/steps}];

(* ========Generate Data========*)
\[Omega] = OmegaGenerator[n, \[Mu], \[Sigma], seed];
data = CreateData[rvec, pvec, J, \[Omega], tf, steps];

(* ========Export Data to CSV========*)
dt = tf/steps;
timeValues = N[Range[0, tf, dt]];
csvData = MapThread[Prepend, {data, timeValues}];
header = {"t", "x", "y"};
finalData = Prepend[csvData, header];
Export[Directory[] <> label <> "_data.csv", finalData];
Print["Data generated and exported to"<>Directory[] <> label <> "_data.csv"]