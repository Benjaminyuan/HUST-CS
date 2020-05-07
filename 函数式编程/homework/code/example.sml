fun change'(0,L) 


fun change(0,L) p = p [] 
| change(n,[]) p = false
| change(n,x::R) p = 
    if x <= n
    then (change(n-x,R) (fn A => p(x::A))
    orelse change(n,R) p)
    else change(n,R) p

fun gcd(x,y) = 
    case Int.compare(x,y) of
       LESS => gcd(x,y-x)
     | EQUAL => x
     | GREATER => gcd(x-y,y)