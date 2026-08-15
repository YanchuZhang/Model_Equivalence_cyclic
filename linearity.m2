load("utils.m2");

getSystem = {n} -> {

    edg1 = randag(n, random(binomial(n,2)+1));
    edg2 = randag(n, random(binomial(n,2)+1));
    bnum = random(binomial(n,2)+1);
    b1 = ranbid(n, bnum);
    b2 = ranbid(n, bnum);

	-- reject if the numbers of bidirected edges are different
	if (#b1 != #b2) then {
		eqv = false;
	};

	-- decrease the indices
	edg1 = decreasePairs(edg1); 
	edg2 = decreasePairs(edg2);
	b1 = decreasePairs(b1);
	b2 = decreasePairs(b2);

	-- frac allows inverse in cyclic case
	R = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)]);

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
    S1 = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1]);
    A1 = substitute(A1,S1);
    for i from 1 to n do(
	for j from 1 to n do(
	    A1 = substitute(A1, l_(i,j) => randomrat(100));
	    );	
	);
	Q1 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1];
	L2 = substitute(L2,Q1);
	A1 = substitute(A1,Q1);


    S2 = frac(QQ[m_(1,1)..m_(n,n),l_(1,1)..l_(n,n)]);  
    A2 = substitute(A2, S2);
    for i from 1 to n do(
	for j from 1 to n do(
	    A2 = substitute(A2, m_(i,j) => randomrat(100));
	    );	
	);
	Q2 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)];
	L1 = substitute(L1,Q2);
	A2 = substitute(A2,Q2);
    
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
		eqv = true;
	} else eqv = false;

	return {I1,I2,edg1,edg2,b1,b2, eqv};
}


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

	-- frac allows inverse in cyclic case
	R = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)]);

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
    S1 = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1]);
    A1 = substitute(A1,S1);
    for i from 1 to n do(
	for j from 1 to n do(
	    A1 = substitute(A1, l_(i,j) => randomrat(1000000));
	    );	
	);
	Q1 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1];
	L2 = substitute(L2,Q1);
	A1 = substitute(A1,Q1);


    S2 = frac(QQ[m_(1,1)..m_(n,n),l_(1,1)..l_(n,n),tt2]);  
    A2 = substitute(A2, S2);
    for i from 1 to n do(
	for j from 1 to n do(
	    A2 = substitute(A2, m_(i,j) => randomrat(1000000));
	    );	
	);
	Q2 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt2];
	L1 = substitute(L1,Q2);
	A2 = substitute(A2,Q2);
    
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

    -- for cyclic graphs
	eqlist1##eqlist1 = tt1*det(L2)-1;
	eqlist2##eqlist2 = tt2*det(L1)-1;

	-- eqlist 1 gives the system of equations to be solved for checking M(G) in M(G_tilde)
	-- eqlist 2 gives the system of equations to be solved for checking M(G_tilde) in M(G)
    	    	    	    
    I1 = ideal(toList eqlist1);
	I2 = ideal(toList eqlist2);

    if (dim I1 != -1 and dim I2 != -1 and degree(I1) < 2 and degree(I2) < 2) then {
		-- dim of ideal != -1 means there is a solution
		return true;
	};
	return false;
}

findSystem = {n} -> {

    edg1 = randag(n, random(binomial(n,2)+1));
    edg2 = randag(n, random(binomial(n,2)+1));
    bnum = random(binomial(n,2)+1);
    b1 = ranbid(n, bnum);
    b2 = ranbid(n, bnum);

	-- decrease the indices
	edg1 = decreasePairs(edg1); 
	edg2 = decreasePairs(edg2);
	b1 = decreasePairs(b1);
	b2 = decreasePairs(b2);

	-- frac allows inverse in cyclic case
	R = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)]);

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
    S1 = frac(QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1]);
    A1 = substitute(A1,S1);
    for i from 1 to n do(
	for j from 1 to n do(
	    A1 = substitute(A1, l_(i,j) => randomrat(100));
	    );	
	);
	Q1 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n),tt1];
	L2 = substitute(L2,Q1);
	A1 = substitute(A1,Q1);


    S2 = frac(QQ[m_(1,1)..m_(n,n),l_(1,1)..l_(n,n)]);  
    A2 = substitute(A2, S2);
    for i from 1 to n do(
	for j from 1 to n do(
	    A2 = substitute(A2, m_(i,j) => randomrat(100));
	    );	
	);
	Q2 = QQ[l_(1,1)..l_(n,n),m_(1,1)..m_(n,n)];
	L1 = substitute(L1,Q2);
	A2 = substitute(A2,Q2);
    
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
	
	md1 = (max degrees I1)#0;
	md2 = (max degrees I2)#0;

    if (dim I1 != -1 and dim I2 != -1 and max (md1,md2) > 1) then {
		-- dim of ideal != -1 means there is a solution
		print {edg1, edg2, b1, b2};
		return {edg1, edg2, b1, b2};
	};

	return false;
}

