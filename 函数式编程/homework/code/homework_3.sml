fun norm(a,b) = fn x => (2.0*x-a-b)/(b-a)

fun map f [] = [] 
| map f (x::R) = (f x)::(map f R)

fun subLists [] = [[]]
| subLists (x::R) = 
    let 
        val S = subLists R
    in
        S @ map (fn A => x::A) S
    end

fun toInt b = fn L => case L of
   x::[] => x
   | x::R => 0 ;

fun toInt a = fn L=>case L of 
                  []=>0
                  |x::R=>x+a*(toInt a R);
                
fun toBase b=fn n=>case Int.compare(n,b) of 
                    LESS=>[n]
                     |_=>(n mod b)::toBase b (n div b);

fun convert(b1,b2)=fn L=>toBase b2 (toInt b1 L);

