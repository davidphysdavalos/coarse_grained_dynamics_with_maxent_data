#!/usr/bin/env wolframscript
(* ::Package:: *)

Import[Directory[]<>"/Carlos.m"];
Import[Directory[]<>"/Quantum.m"];

Print["This script generates files fig_5_convergence.csv and fig_5_inset_convergence.csv in the same folder."];
Print["They correspond to figure 5 and its inset, respectively."];

TraceDistance[\[Rho]_,\[Sigma]_]:=Module[{mat},mat=\[Rho]-\[Sigma];0.5*Total[SingularValueList[mat]]];
Pauli1[i_,\[Alpha]_,n_]:= Pauli[ReplacePart[Table[0,{n}],(i+1)->\[Alpha]]];
DistribucionUniforme[NumeroParticulas_]:=Table[1,{NumeroParticulas}]/NumeroParticulas;
coarsegrainingoptimized[state_,distro_]:=PartialTrace[Sum[distro[[i]]Proyector[ApplySwap[state,1,i]],{i,1,Length[distro]}],2^(Length[distro]-1)];
HamiltonianClosedChain2[n_,g_]:=- Sum[Pauli1[i,3,n] . Pauli1[Mod[i+1,n],3,n],{i,0,n-1}]+g Sum[Pauli1[i,1,n],{i,0,n-1}];


number=10;times={0.1,0.5,1.0,1.2,1.5};gs={0.1,0.5,1.0,1.5};
Table[distros[n]=DistribucionUniforme[n],{n,4,number}];


Table[Ham[particles,g]=HamiltonianClosedChain2[particles,g],{particles,4,number},{g,gs}];
Table[U[time,particles,g]=MatrixExp[-I*Ham[particles,g]*time],{time,times},{particles,4,number},{g,gs}];


Table[state=RandomState[2];Table[total=KroneckerProduct@@Table[state,{particles}]//Flatten;Table[final=U[time,particles,g] . total;finalcg[time,particles,g, i]=coarsegrainingoptimized[final,distros[particles]]//Chop,{time,times},{g,gs}],{particles,4,number}],{i,100}];


taberror=Table[Table[{particles+1,Mean[Table[TraceDistance[finalcg[time,particles,g,i],finalcg[time,particles+1,g,i]],{time,times},{i,100}]//Flatten]},{particles,4,number-1}],
{g,gs}];


taberrorinset=Table[Table[{particles,Mean[Table[TraceDistance[finalcg[time,particles,g,i],finalcg[time,8,g,i]],{time,times},{i,100}]//Flatten]},{particles,9,number}],
{g,gs}];


datataberror=Flatten[taberror];
datataberrorwithHeader=Prepend[datataberror,{"particles+1", "value"}];
Export[Directory[]<>"/fig_5_convergence.csv",datataberrorwithHeader];

datataberrorinset=Flatten[taberrorinset];
datataberrorwithHeaderinset=Prepend[datataberrorinset,{"particles+1", "value"}];
Export[Directory[]<>"/fig_5_inset_convergence.csv",datataberrorwithHeaderinset];
