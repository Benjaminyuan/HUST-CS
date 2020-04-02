fun prefixsum [] = []
| prefixsum [x] = [x]
fun prefixsum(l:int list):int list = 
prefixsumhelp'(l,0);
fun prefixsumhelp'([],_) = []
| prefixsumhelp'(x::L,sum) = 
 (x+sum)::prefixsumhelp'(L,x+sum);

fun sum [] = 0 
| sum(x::L) = (x+sum L);
fun help(l:int list ,x::[]) = [sum(l@([x]))]
| help(l:int list ,x::L) =  sum(l@([x]))::help(l@([x]),L); 

fun prefixsum2(l:int list):int list = help([],l);
