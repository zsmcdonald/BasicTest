// Run operation 6 times, for a 1 million element list on each iteration
q)\s
6
q)\t { sum (x?1.0) xexp 1.7 } each 6#1000000
802
q)\t { sum (x?1.0) xexp 1.7 } peach 6#1000000
136



// Peach takes longer when just doing a product
q)\t:1000 { x*1?10 } each 10?1.0
3
q)\t:1000 { x*1?10 } peach 10?1.0
18
// Increasing the complexity makes the overhead worthwhile
q)\t:100 { sqrt (1000?x) xexp 1.7 } each 10?1.0
145
q)\t:100 { sqrt (1000?x) xexp 1.7 } peach 10?1.0
33



// Single-threaded mode. Atomic vs. vector argument
q)a:1000000?1.0
// Taking the exponent of each value and sum the result
q)sum { x xexp 1.7 } each a
370110f
q)\t sum { x xexp 1.7 } each a
321
// Apply sum and exponent operations to the whole vector instead
q){ sum x xexp 1.7 } a
370110f
q)\t { sum x xexp 1.7 } a
132
// Performance of peach is slower than single-thread each
q)\t { sum x xexp 1.7 } peach a
448
// Parallel speed-up is observed using .Q.fc
q)\t .Q.fc[{ sum x xexp 1.7 }] a
28



// Define Function
q)f: { x:7000*x;sum sqrt (x?1.0) xexp 1.7;};
q)\t f[100]
102
q)\t f[1000]
1053
// Single threaded
q)\t f each 10 10 10 10 1000 1000 1000 1000
4162
// Single threaded unbalanced
q)\t f each 10 1000 10 1000 10 1000 10 1000
4163
// Multi threaded unbalanced
q)\t f peach 10 1000 10 1000 10 1000 10 1000
4131
// Multi threaded balanced
q)\t f peach 10 10 10 10 1000 1000 1000 1000
2090
