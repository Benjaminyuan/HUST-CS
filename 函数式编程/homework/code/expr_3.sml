fun multi x = x*2;
fun thenAddOne f x = 1 + (f x);

fun mapList f [] = [] 
| mapList f (x::R) = (f x)::(mapList f R);

fun mapList' f = fn L => case L of
   [] => []
 | x::R => (f x)::(mapList' f R);

fun findOdd([] : int list): int option = NONE
  | findOdd(x::L) = if (x mod 2)=1 then SOME x else findOdd L;

fun subSetSumOption( L:int list, 0:int): int list option = SOME []
| subSetSumOption([],s) = NONE
| subSetSumOption(x::L,s) = 
    if subSetSumOption(L,s-x) = NONE
    then subSetSumOption(L,s)
    else
    SOME(x::(valOf(subSetSumOption(L,s-x))));


fun subsetSumOption (l : int list, 0 : int) : int list option = SOME []
  | subsetSumOption ([], n) = NONE
  | subsetSumOption (x::L, sum) =
  if subsetSumOption(L, sum-x) =NONE 
  then subsetSumOption(L, sum)  (*不符合，去掉x*)
  else
  SOME (x::(valOf(subsetSumOption(L, sum-x))))

fun exists f = fn L => case L of
   [] => false
 | (x::R) => 
 if (f x) 
 then true
 else (exists f R);

fun forall f = fn L => case L of
   [] => true
 | x::R => 
 if (f x) = false 
 then false
 else (exists f R);