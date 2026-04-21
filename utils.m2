-- cartesian product of two lists

cartProduct = {A,B} -> {
	return flatten apply(toList A, x -> apply(toList B, y -> {x,y}))
};

----------------------------------------------------------------

-- Function to increment pairs

increasePairs = (s) -> (
    if #s == 0 then s
    else apply(s, p -> (p#0 + 1, p#1 + 1))
);

----------------------------------------------------------------

-- Function to decrement pairs

decreasePairs = (s) -> (
    if #s == 0 then s
    else apply(s, p -> (p#0 - 1, p#1 - 1))
);


----------------------------------------------------------------

randomrat = {M} -> {

    -- Input: M: a positive integer, choose M large
    -- Output: a random rational number between -M and M
    -- Usage: Generate random rational, distributed between -M and M

    num = random(-M, M);  --integer between -M and M
    den = random(-M, M);
    if den != 0 then return(num/den);
    return(num);
    };

---------------------------------------------------------------

daglist = {n} -> {
    
    -- Input: n: number of nodes
    -- Output: list of all dags with n nodes
    -- Usage: Generate all the dags with n nodes

    orders = permutations toList (1..n);
    dlist = {{}};
    for o in orders do(
    edgelist = {};
    for i from 0 to n-2 do (
    for j from i+1 to n-1 do(
    edgelist = append(edgelist,(o_i,o_j));
    );
    );
    edgeperm = permutations edgelist;
    for el in edgeperm do(
    for e from 1 to binomial(n,2) do(
    -- in a dag with n nodes, there can be at most binomial(n,2) edges
    dlist = append(dlist, sort el_{0..e-1});
    );
    );
    dlist = unique dlist;
    );
    return(dlist);
    };

----------------------------------------------------------------

bidlist = {n,k} -> { 
    
    -- Input: n: number of nodes,
    --      : k: number of bidirected edges
    -- Output: list of all dags with n nodes
    -- Usage: Generate all the dags with n nodes and k bidirected edges

     blist = {};
     edgelist = {};
     for i from 1 to n-1 do (
     	 for j from i+1 to n do(
	     edgelist = append(edgelist,(i,j));
	     );
     	 );	 
     edgeperm = permutations edgelist;
	 for el in edgeperm do(
	 blist = append(blist, sort el_{0..k-1});
	 blist = unique blist;
	 );
	 return(blist);
    };

----------------------------------------------------------------

randag = {n,enum} -> {
    
    -- Input: n: number of nodes,
    --      : enum: number of edges
    -- Output: a random dag with n nodes and enum edges
    -- Usage: Generate a random dag with n nodes and enum edges

    if enum > binomial(n,2) then return("there are too many edges");
    if enum == 0 then return({});
    edgelist = new MutableList;
    cord = random toList (1..n);
    for i from 0 to n-2 do(
	for j from i+1 to n-1 do(
	    edgelist##edgelist = (cord_(i),cord_(j));
	    );
    	);
	edgelist = toList edgelist;
	edgelist = random edgelist;
    edgelist = edgelist_{0..enum-1};
    return(sort edgelist);  
    };

----------------------------------------------------------------

ranbid = {n,bnum} -> {

    -- Input: n: number of nodes,
    --      : bnum: number of bidirected edges
    -- Output: a random bidirected part with bnum edges
    -- Usage: Generate random bidirected part

    if bnum > binomial(n,2)  then return("there are too many edges");
    edgelist = {};
    cord = random toList (1..n);
    for i from 0 to n-2 do(
	for j from i+1 to n-1 do(
	    edgelist = append(edgelist, (cord_(i),cord_(j)));
	    );
    	);
    edgelist = random edgelist;
    edgelist = edgelist_{0..bnum-1}; 
    ordlist = {};
    for edge in edgelist do(
	if edge_1 < edge_0 then ordlist = append(ordlist,(edge_1,edge_0))	
	else ordlist = append(ordlist,edge);
	);
    return(sort ordlist);         
    };

----------------------------------------------------------------
