fun append (xs : string list, ys : int list) =
    if null xs
    then []
    else ((hd xs),(hd ys)) :: append(tl xs, tl ys);
fun zip (xs : string list, ys : int list):(string*int)list =
    if null xs
        then []
    else if null ys
        then []
        else  ((hd xs),(hd ys)) :: zip(tl xs, tl ys);

//空的list -> [] ,null->bool
fun unzip(x: (string*int) list):string list * int list =
    if null x
        then ([],[])
    else let 
        val (a,b) = hd x
        val (l1,l2) = unzip(tl x)
        in (a::l1,b::l2) end;


fun unzip1 l = 
    case l of
       nil => (nil,nil)
     | (a,b)::tl =>
        let val (l1,l2) = unzip1 tl
        in (a::l1,b::l2)end