load("methods.m2");

testOneEdge = (n, N) -> (
    for i from 1 to N do(
        edg1 = randag(n, random(binomial(n,2)+1));
        b1 = ranbid(n, 1);
        eqclass = findEqGraphs(n,edg1,b1);
        bidEdges = {};
        for element in eqclass do(
            bidEdges = append(bidEdges, element#1);
        );
        if not all(bidEdges, x -> x == bidEdges#0) then (
            print(eqclass);
            return (eqclass);
        );
    );
    return ({});
);

testOneEdge(4, 100)