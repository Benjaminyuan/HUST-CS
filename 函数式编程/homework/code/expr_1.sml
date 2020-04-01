fun mult[] = 1 | mult(x::L) = x*mult(L);
fun Mult[] = 1 | Mult(r::R) = mult(r)*Mult(R);
fun mult'([],a) =a | mult'(x::L,a) = mult'(L,x*a);
fun Mult'([],a) = a | Mult'(r::R,a) = mult(r)*Mult'(R,a);
fun double(0:int):int=0 |double(x:int)=2+double(x-1);
fun square(0:int):int = 0 | square(x:int)=square(x-1)+double(x-1)+1; 
fun divisibleByThree(0:int):bool = true
| divisibleByThree 1= false
| divisibleByThree 2= false
| divisibleByThree n= divisibleByThree (n-3);

fun oddP(0:int):bool = false
| oddP 1 = true
| oddP n = oddP(n-2);