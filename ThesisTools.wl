(* ::Package:: *)

BeginPackage["ThesisTools`"]
Needs["CoolTools`"]
Needs["Carlos`"]
Needs["Quantum`"]
CNOT::usage="CNOT[t] evaluates the controlled not gate at a time t."
MatrixToLatex::usage="something"
ShowOperatorsWithSphere::usage="something"
KetsToBlochVector::usage="something"
UnitaryStep::usage="something"
ApplyUnitaryButSlowly::usage="something"
UniformMixedStates::usage="something"
MixedToPure::usage="something"
UB2Q::usage="something"
UnitaryToRotateFineStates::usage="something"
AssignementMapForStateNotInZ::usage="something"
RotatedFineStates::usage="something"
SWAPContractionFactor::usage="SWAPContractionFactor[t,p,\[Lambda]] gives the contraction factor of the coarse system resulting from applying the swap gate to a MaxEnt state characterized by p,\[Lambda]."
SWAP::usage="SWAP[t] applies the operator at a time t. t=1 is the full swap gate, while t=0 is the identity operator."
SWAP2::usage="SWAP2[t] applies the operator at a time t. t=1 is the full swap gate, while t=0 is the identity operator."
PlotTwoCoarseSets::usage="PlotTwoCoarseSets[set1,set2,legend,title] takes two sets of two level density operators and plots their bloch vectors."
PlotTwoCoarseSetsWLine::usage="PlotTwoCoarseSets[set1,set2,legend,title] takes two sets of two level density operators and plots their bloch vectors, with a line joining corresponding points."
ShowWithBlochSphere::usage="Acts like Show function, but appends a Graphics3D showing the bloch sphere. Also, argument is a list."
SphereMesh::usage="Draws a sphere mesh with latitudinal and longitudinal lines."
TransformedSphereMesh::usage="Same as sphere mesh but accepts a transformation parameter. Transforms the sphere mesh using the given transformation."
SU2ToSO3::usage="Transforms a SU(2) matrix into a SO(3) matrix using the Pauli basis"
FunctionSphereMesh::usage="Same as sphere mesh but accepts a function parameter. Transforms the sphere mesh using the given function."


Begin["`Private`"]


(*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@GENERAL TOOLS@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*)


CNOT[t_]:={{1,0,0,0},{0,1,0,0},{0,0,Exp[I*Pi*t/2]*Cos[Pi*t/2],-I*Exp[I*Pi*t/2]*Sin[Pi*t/2]},{0,0,-I*Exp[I*Pi*t/2]*Sin[Pi*t/2],Exp[I*Pi*t/2]*Cos[Pi*t/2]}}
PauliVector=Table[PauliMatrix[i],{i,3}];
DirProd[rho_,varrho_]:=KroneckerProduct[rho,varrho];

MatrixToLatex[matrix_]:=
"\\begin{pmatrix}"<>Fold[
(#1<>"\\"<>"\\"<>#2)&,
Map[
Fold[(ToString[#1]<>"&"<>ToString[#2])&,#]&,matrix
]
]<>"\\end{pmatrix}"

ShowOperatorsWithSphere[operators_]:=
Show[
ListPointPlot3D[
densityMatrixToPoint[operators,gellMannBasis[1]],BoxRatios->{1, 1, 1},PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}}],
Graphics3D[{Opacity[0.2],GrayLevel[0.9],Sphere[]},BoxRatios->1,Axes->True]]

KetsToBlochVector[kets_,basis_]:=
densityMatrixToPoint[ketsToDensity[kets],basis]

UnitaryStep[unitary_,t_]:=MatrixPower[unitary,t];

ApplyUnitaryButSlowly[unitary_,steps_,rhos_]:=
With[
{stepsize=1/steps},
Table[
MapMonitored[
UnitaryStep[unitary,i*stepsize] . # . Dagger[UnitaryStep[unitary,i*stepsize]]&,
rhos
],
{i,0,steps}
]
]

UniformMixedStates[r_,n_]:=
With[
{basis=gellMannBasis[1]},
Map[
(IdentityMatrix[2]+# . Rest[basis])/2&,
r*KetsToBlochVector[Table[RandomState[2],n],basis]
]
]

MixedToPure[mixedstate_]:=
{Cos[#[[1]]/2],Exp[I*#[[2]]]*Sin[#[[1]]/2]}&[
Rest[ToSphericalCoordinates[densityMatrixToPoint[{mixedstate},gellMannBasis[1]][[1]]]]
]

UB2Q[qubit2_,qubit1_]:=
With[
{u1={{qubit1[[1]],-Conjugate[qubit1[[2]]]},{qubit1[[2]],Conjugate[qubit1[[1]]]}}
,u2={{Conjugate[qubit2[[1]]],Conjugate[qubit2[[2]]]},{-qubit2[[2]],qubit2[[1]]}}},u1 . u2]

UnitaryToRotateFineStates[cstate_]:=
KroneckerProduct[#,#]&[
UB2Q[{1,0},MixedToPure[cstate]]
]

AssignementMapForStateNotInZ[cstate_,fdata_]:=
With[
{preassignement=Total[fdata/Length[fdata]],
Ubig=UnitaryToRotateFineStates[cstate]
},
Ubig . preassignement . Dagger[Ubig]
]

RotatedFineStates[cstate_,fdata_]:=
With[
{preassignement=Total[fdata/Length[fdata]],
Ubig=UnitaryToRotateFineStates[cstate]
},
Ubig . #&/@fdata
]



SWAPContractionFactor[t_, p_, l_, omega_: Pi/2] := ((p*Cos[omega*t]^2 + (1 - p)*Sin[omega*t]^2)*Tanh[-l*p] +((1 - p)*Cos[omega*t]^2 + p*Sin[omega*t]^2)*Tanh[-l*(1 - p)])/(p*Tanh[-l*p] + (1 - p)*Tanh[-l*(1 - p)]);
SWAP[t_]:={{1,0,0,0},{0,Exp[I*Pi*t/2]*Cos[Pi*t/2],-I*Exp[I*Pi*t/2]*Sin[Pi*t/2],0},{0,-I*Exp[I*Pi*t/2]*Sin[Pi*t/2],Exp[I*Pi*t/2]*Cos[Pi*t/2],0},{0,0,0,1}}
SWAP2[t_]:={{1,0,0,0},{0,(1+Exp[I*Pi*t])/2,(1-Exp[I*Pi*t])/2,0},{0,(1-Exp[I*Pi*t])/2,(1+Exp[I*Pi*t])/2,0},{0,0,0,1}};
PlotTwoCoarseSets[set1_,set2_,legend_,title_]:=Show[
ListPointPlot3D[
{densityMatrixToPoint[set1,gellMannBasis[1]],densityMatrixToPoint[set2,gellMannBasis[1]]},
BoxRatios->{1,1,1},
PlotRange->{{-1.,1.},{-1.`,1.`},{-1.,1.}},
PlotLegends->legend,
PlotLabel->title,
AxesLabel->{"x","y","z"}
],
Graphics3D[{Opacity[0.2],GrayLevel[0.9],Sphere[]},BoxRatios->1,Axes->True]
]

PlotTwoCoarseSetsWLine[set1_,set2_,legend_,title_]:=
With[{points={densityMatrixToPoint[set1,gellMannBasis[1]],densityMatrixToPoint[set2,gellMannBasis[1]]}},
Show[
ListPointPlot3D[points,BoxRatios->{1,1,1},PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}},PlotLegends->legend,PlotLabel->title],
Graphics3D[{Opacity[0.2],ColorData[1][1],Thickness[0.005],Line/@Transpose[points]}],
Graphics3D[{Opacity[0.2],GrayLevel[0.9],Sphere[]},BoxRatios->1,Axes->True]
]
]

SphereMesh[r_]:=Show[
	ParametricPlot3D[{r*Sin[t] Cos[p], r*Sin[t] Sin[p], r*Cos[t]}, {t, 0, \[Pi]}, {p, 0, 2 \[Pi]}, Lighting -> {"Neutral", White},
	PlotStyle -> GrayLevel[.5], PlotTheme -> None,
			BoxRatios->{1, 1, 1},
			PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}},
			AxesLabel->{Style["x", 16],Style["y", 16],Style["z", 16]},
			LabelStyle->Black],
	ParametricPlot3D[{r*Cos[t],r*Sin[t],0},{t,0,2*Pi},PlotStyle->Red],
	ListPointPlot3D[{{0,0,r},{0,0,-r}},PlotStyle->{Red,PointSize[0.03]}]];
	
TransformedSphereMesh[r_,transformation_,legend_,pos_]:=Show[
	ParametricPlot3D[transformation . {r*Sin[t] Cos[p], r*Sin[t] Sin[p], r*Cos[t]}, {t, 0, \[Pi]}, {p, 0, 2 \[Pi]}, Lighting -> {"Neutral", White},
	PlotStyle -> GrayLevel[.5], PlotTheme -> None,
			BoxRatios->{1, 1, 1},
			PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}},\.b4
			AxesLabel->{Style["x", 16],Style["y", 16],Style["z", 16]},
			LabelStyle->Black,
			Placed[PlotLabel[legend],pos]],
	ParametricPlot3D[transformation . {r*Cos[t],r*Sin[t],0},{t,0,2*Pi},PlotStyle->Red],
	ListPointPlot3D[(Map[transformation . #&,{{0,0,r},{0,0,-r}}]),PlotStyle->{Red,PointSize[0.03]}]];
SU2ToSO3[su2_]:=densityMatrixToPoint[Table[su2 . PauliMatrix[i] . Dagger[su2],{i,1,3}],gellMannBasis[1]/2];


FunctionSphereMesh[r_,function_,opa_:1.]:=Show[
	ParametricPlot3D[function[{r*Sin[t] Cos[p], r*Sin[t] Sin[p], r*Cos[t]}], {t, 0, \[Pi]}, {p, 0, 2 \[Pi]}, Lighting -> {"Neutral", White},
	PlotStyle -> {GrayLevel[.5],Opacity[opa]}, PlotTheme -> None,
			BoxRatios->{1, 1, 1},
			PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}},
			AxesLabel->{Style["x", 16],Style["y", 16],Style["z", 16]},
			LabelStyle->Black],
	ParametricPlot3D[function[{r*Cos[t],r*Sin[t],0}],{t,0,2*Pi},PlotStyle->Red],
	ListPointPlot3D[(Map[function[#]&,{{0,0,r},{0,0,-r}}]),PlotStyle->{Red,PointSize[0.03]}]]


ShowWithBlochSphere[args_]:=Show[
Sequence@@args,
Graphics3D[{Opacity[0.2],GrayLevel[0.9],Sphere[]},BoxRatios->1,Axes->True,
AxesLabel->{"x","y","z"},AxesOrigin->{0,0,0}, AxesStyle->Black,
			Ticks->Automatic]
]


(*
CoarseEvolutionPNGSet[zcoord_,swapP_,]:= With[
{coarseev=Table[Map[coarseGraining2[#,swapP]&,ApplyUnitaryButSlowly[unitary,steps,assignements][[i]]],{i,1,Length[ApplyUnitaryButSlowly[unitary,steps,assignements]]}];
},
Table[
Labeled[
Show[
ListPointPlot3D[densityMatrixToPoint[coarseev[[i]],gellMannBasis[1]],BoxRatios->{1, 1, 1},PlotRange->{{-1.,1.},{-1.,1.},{-1.,1.}}],
Graphics3D[{Opacity[0.2],GrayLevel[0.9],Sphere[]},BoxRatios->1,Axes->True]
],
{"t="<>ToString[i],"Coarse evolution for p="<>ToString[swapP]<>", z="<>ToString[zcoord]},
{Top,Bottom}], 
{i,Length[coarseev]}]];

PNGSetToGif[set_]:=Export["../figures/"<>"coarse_swap_evol_"<>ToString[steps]<>"steps"<>"_n="<>ToString[n]<>"_z="<>ToString[zcoord]<>"_p="<>ToString[swapP]<>"_beta="<>ToString[beta]<>"_delta="<>ToString[delta]<>".gif",
Flatten[{gif, Table[gif[[i]], {i, Length[gif] }]}]]
*)



End[]
EndPackage[]
