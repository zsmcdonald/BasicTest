f:{[x];
   list:key `;
   :count distinct raze key each `$(raze each string each `.,/:(key `));
 }

f[]
