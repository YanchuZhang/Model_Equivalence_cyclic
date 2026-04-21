load("main.m2");

--search equivalent graph by exhaustive search
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


-- progressive output
findEqGraphsProg = {n,edg1,b1} -> {
    dlist = daglist(n);
	blist = bidlist(n,#b1);
	count = 1;
    totalCount = #dlist * #blist;
    print("----------------------------");
	print("Initialized:");
    eqclass = {};
    for edg2 in dlist do(
    	for b2 in blist do (
	    if checkEquivalence(n,edg1,edg2,b1,b2)  then (eqclass=append(eqclass,{edg2,b2});
        print("Found: " | toString{edg2,b2});
        );
        print("Progress: " | toString count | "/" | toString totalCount);
        count = count + 1;
        );
    	);
    print("Finished.");
    print("----------------------------");
    return(eqclass);
    };

-- Time for a random equivalence checking 
-- Turn on rejectOptionDetails in main.m2 to get more detailed output on rejection reasons
timeRandomEquivalence = {n} -> {
    edg1 = randag(n, random(binomial(n,2)+1));
    edg2 = randag(n, random(binomial(n,2)+1));
    bnum = random(binomial(n,2)+1);
    b1 = ranbid(n, bnum);
    b2 = ranbid(n, bnum);
    t0 = cpuTime();
    checkEquivalence(n, edg1, edg2, b1, b2);
    t1 = cpuTime();
    return t1-t0;
};

-- Time for a random equivalence checking with given number of bidirected edges
timeBnum = {n, bnum} -> {
    edg1 = randag(n, random(binomial(n,2)+1));
    edg2 = randag(n, random(binomial(n,2)+1));
    b1 = ranbid(n, bnum);
    b2 = ranbid(n, bnum);
    t0 = cpuTime();
    checkEquivalence(n, edg1, edg2, b1, b2);
    t1 = cpuTime();
    return (t1 - t0);
};


--- average time by random sampling

getSampleTime = {n, N} -> (
    sampleTime = new MutableList from apply(N, i -> 0);
    for i from 0 to N-1 do(
         print("Sample " | toString (i+1) | " out of " | toString N);
         sampleTime#i = timeRandomEquivalence(n);
    );
    return sampleTime;
);

-- average time by random sampling with given number of bidirected edges
getSampleTimeBnum = {n, N, bnum} -> (
    sampleTimeBnum = new MutableList from apply(N, i -> 0);
    for i from 0 to N-1 do(
         print("Sample " | toString (i+1) | " out of " | toString N);
         sampleTimeBnum#i = timeBnum(n, bnum);
    );
    return sampleTimeBnum;
);

-- record as csv
recordSampleTime = {sampleTime, filename} -> (
    f = openOut ("Visualize/output/"|filename);
    for x in sampleTime do f << toString x << endl;
    close f;
);

-- find equivalent graphs with given target set of graphs
findEqGraphs2 = {n,edg1,b1,dlist,blist} -> {
	count = 1;
    nfounded = 0;
    totalCount = #dlist * #blist;
    print("----------------------------");
	print("Initialized:");
    eqclass = {};
    for edg2 in dlist do(
    	for b2 in blist do (
	    if checkEquivalence(n,edg1,edg2,b1,b2)  then (eqclass=append(eqclass,{edg2,b2});
        print("Found: " | toString{edg2,b2});
        nfounded = nfounded + 1;
        );
        print("Progress: " | toString count | "/" | toString totalCount | " Found: " | toString nfounded);
        count = count + 1;
        );
    	);
    print("Finished.");
    print("----------------------------");
    return(eqclass);
    };