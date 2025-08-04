#!/usr/bin/env wolframscript
(* ::Package:: *)

Import[Directory[]<>"/Quantum.m"]

Print["This script generates file fig_4_ising_data.csv in this folder for 4 particles. If you want more particles just modify the NumeroParticulas variable."];
Print["It contains data ready to plot with ListSurfacePlot3D."];
Print["Consider that this is not exactly the method used to create fig 4 in our paper."];

NumeroParticulas = 4;

coarsegraining[state_,distro_]:=PartialTrace[Sum[distro[[i]]ApplySwap[state,1,i],{i,1,Length[distro]}],2^(Length[distro]-1)];
Pauli1[i_,\[Alpha]_,n_]:= Pauli[ReplacePart[Table[0,{n}],(i+1)->\[Alpha]]];
BlochToMatrix[r_]:=1/2 (IdentityMatrix[2]+r[[1]] PauliMatrix[1]+r[[2]] PauliMatrix[2]+r[[3]] PauliMatrix[3])



PureStatePropagatorNew[spherepoint_?VectorQ,distro_,U_]:=Module[{state, st, n},
state = BlochToMatrix[spherepoint];
n=Length[distro];
st=coarsegraining[U . (KroneckerProduct@@Table[state,{n}]) . Dagger[U]//Chop,distro];{Tr[st . PauliMatrix[1]],Tr[st . PauliMatrix[2]],Tr[st . PauliMatrix[3]]}//Chop
];

HamiltonianClosedChain2[n_,g_]:=- Sum[Pauli1[i,3,n] . Pauli1[Mod[i+1,n],3,n],{i,0,n-1}]+g Sum[Pauli1[i,1,n],{i,0,n-1}];
DeformationFunction[distro_,t_,NumeroParticulas_,g_]:=Module[{U3},
U3=MatrixExp[-I t HamiltonianClosedChain2[NumeroParticulas,g]];
(PureStatePropagatorNew[#,distro,U3]&)];
TransformSphere[sphere_,DeformationObject_]:=ReplacePart[sphere,1->(DeformationObject/@(sphere[[1]]))];
DistribucionUniforme[NumeroParticulas_]:=Table[1,{NumeroParticulas}]/NumeroParticulas;


(*Parameters Set Up*)
gs={0.0,0.2,0.5,1.0};
times={0.3,0.5,0.7,0.9};
distro=DistribucionUniforme[NumeroParticulas];
wireresolution=0.1;
\[Phi]step=0.3; 

nEsfera=15;  (*Level of subdivision;higher n creates more detail*)
sphere=GeodesicPolyhedron["Icosahedron",nEsfera];

(*Extract vertex coordinates and face (polygon) index lists*)
vertices=MeshCoordinates[sphere];
facesIndices=MeshCells[sphere,2][[All,1]];

(*Compute per-face colors:-Hue is determined by the normalized polar angle,-Intensity (brightness) is determined by the normalized azimuth angle,but shifted so it never gets too low.*)
faceSphericalColors=Table[Module[{pts,azimuths,polars,avgAz,avgPol,brightness},pts=vertices[[facesIndices[[i]]]];(*the vertices of face i*)(*Compute normalized azimuth for each vertex.ArcTan returns an angle (radians);normalize by 2\[Pi].*)azimuths=(Mod[ArcTan[#[[2]],#[[1]]],2 Pi]/(2 Pi))&/@pts;
(*Compute normalized polar angle (colatitude).Use ArcCos[z/Norm[{x,y,z}]] and divide by \[Pi].*)polars=(ArcCos[#[[3]]/Norm[#]]/Pi)&/@pts;
avgAz=Mean[azimuths];
avgPol=Mean[polars];
(*Adjust brightness to lie in[0.5,1] instead of[0,1]*)brightness=0.5+0.5*avgAz^2;
Hue[avgPol,1,brightness]],{i,Length[facesIndices]}];

(*Build a GraphicsComplex with per-face colors.Each face is given as {color,Polygon[indexList]}.*)
coloredSphere=GraphicsComplex[vertices,Table[{EdgeForm[None],faceSphericalColors[[i]],Polygon[facesIndices[[i]]]},{i,Length[facesIndices]}]];

Table[tablag[g]=Table[
DeformationObject=DeformationFunction[distro,EvolutionTime,NumeroParticulas,g];{TransformSphere[coloredSphere,DeformationObject]}
,{EvolutionTime,{0.3,0.5,0.7,0.9}}];
,{g,gs}];

data=Flatten[Table[{g,i,tablag[g][[i]][[1]][[1]]},{g,gs},{i,Length[times]}],1];

(*Optional:add header*)
dataWithHeader=Prepend[data,{"g","i","value"}];


(*Export to CSV*)
Export[Directory[]<>"/fig_4_ising_data.csv",dataWithHeader]

