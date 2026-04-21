load("utils.m2");
needsPackage ("Graphs");

checkEquivalence = {n,edg1,edg2,b1,b2} -> {

	-- Input: n: number of nodes
	--      : edg1: directed edges of graph 1 (or G)
	--      : edg2: directed edges of graph 2 (or G_tilde)
	--      : b1: bidirected edges of graph 1 
	--      : b2: bidirected edges of graph 2
	-- Output: True if equivalent, False otherwise 
	-- Usage: Check model equivalence of two ADMGs

	-- reject if the numbers of bidirected edges are different
	if (#b1 != #b2) then {
		return false;
	};

	-- decrease the indices
	edg1 = decreasePairs(edg1); 
	edg2 = decreasePairs(edg2);
	b1 = decreasePairs(b1);
	b2 = decreasePairs(b2);

	-- reject if the size of the largest connected components of the bidirected parts are different
	Components1 = connectedComponents(graph(b1));
	Components2 = connectedComponents(graph(b2));
	maxCom1 = max apply(Components1, x -> #x);
	maxCom2 = max apply(Components2, x -> #x);
	if (maxCom1 != maxCom2) then {
		return false;
	};

	R = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)];

    -- adjacency matrix for bidiricted parts
    Bad1 =  mutableIdentity(R,n);
    for e in b1 do(
		Bad1_e = Bad1_(e_1,e_0) = 1; -- symmetry
	);
    Bad2 =  mutableIdentity(R,n);
    for e in b2 do(
		Bad2_e = Bad2_(e_1,e_0) = 1;
	);

    -- adjacency matrix of the directed part of G
    L1 = mutableIdentity(R,n);
    for e in edg1 do (
		te = (e_0+1,e_1+1);
		L1_e = -l_te;      
	);
     -- adjacency matrix of the directed part of G_tilde
    L2 = mutableIdentity(R,n);
    for e in edg2 do (
		te = (e_0+1,e_1+1);
		L2_e = -m_te;      
	);
    
    L1 = matrix(L1);
    L2 = matrix(L2);
    
	-- A1 matrix for checking G in G_tilde
    -- A2 matrix for checking G_tilde in G
    A1 = (transpose L2)*transpose(inverse(L1));
    A2 = (transpose L1)*transpose(inverse(L2));
    
	-- Randomization
    S1 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)];
    A1 = substitute(A1,S1);
    for i from 1 to n do(
	for j from 1 to n do(
	    A1 = substitute(A1, l_(i,j) => randomrat(1000000));
	    );	
	);

    S2 = QQ[m_(1,1)..m_(n,n),l_(1,1)..l_(n,n)];  
    A2 = substitute(A2, S2);
    for i from 1 to n do(
	for j from 1 to n do(
	    A2 = substitute(A2, m_(i,j) => randomrat(1000000));
	    );	
	);
    
	-- A1 should be solved for m, with l substituded with random rationals, corresponding to checking M(G) in M(G_tilde)
	-- A2 should be solved for l, with m substituded with random rationals, corresponding to checking M(G_tilde) in M(G)
    
	eqlist1 = new MutableList;
    eqlist2 = new MutableList;

    for i from 0 to n-1 do(
	for j from 0 to i do(
		-- consider the lower triangular part and the diagonal
	    if Bad2_(i,j) != 1 then (
		for k1 from 0 to n-1 do(
		for k2 from 0 to n-1 do(
			if(Bad1_(k1,k2) != 0 and A1_(i,k1) != 0 and A1_(j,k2) != 0) then(
			    eqlist1##eqlist1 = A1_(i,k1)*A1_(j,k2);   		    
			    ) 
			);
		    );
		);
		
	    if Bad1_(i,j) != 1 then (
		for k1 from 0 to n-1 do(
		for k2 from 0 to n-1 do(
			if(Bad2_(k1,k2) != 0 and A2_(i,k1) != 0 and A2_(j,k2) != 0) then(
			    eqlist2##eqlist2 = A2_(i,k1)*A2_(j,k2);
			    ) 
			);
		    );
		);
	    );
	);

	-- eqlist 1 gives the system of equations to be solved for checking M(G) in M(G_tilde)
	-- eqlist 2 gives the system of equations to be solved for checking M(G_tilde) in M(G)
    	    	    	    
    I1 = ideal(toList eqlist1);
	I2 = ideal(toList eqlist2);

    if (dim I1 != -1 and dim I2 != -1 ) then {
		-- dim of ideal != -1 means there is a solution
		return true;
	};
	return false;
}

