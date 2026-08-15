load("utils.m2");
load("linearity.m2");

findEqGraphs = {n,edg1,b1} -> {
    eqclass = {};
	dlist = daglist(n);
	blist = bidlist(n,#b1);
    for edg2 in dlist do(
    	for b2 in blist do (
	    if checkEquivalence(n,edg1,edg2,b1,b2) then eqclass=append(eqclass,{edg2,b2});
	    );
    	);
    return(eqclass);
    };


n = 3;

edg1 = {(1,2),(2,3)};
b1 = {(2,3)};

eqclass = findEqGraphs(n,edg1,b1);

for e in eqclass do(
     print(e);
     );



-------------------------------
load("utils.m2");
load("linearity.m2");

n = 3;
findSystem(n)

M = 10000;

for i from 1 to M do (
    if (findSystem(n) != false) then (
        print {edg1, edg2, b1, b2};
        break;
        );
)


n = 3;
edg1 = {(1,2),(2,3)};
b1 = {(2,3)};
edg2 = {(2,3),(3,2)};
b2 = {(2,3)};