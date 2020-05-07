datatype tree = Empty | Node of tree * int * tree ;


fun map f [] = [] 
| map f (x::R) = (f x)::(map f R) ;

fun mapList f [] = [] 
| mapList f (x::R) = (f x)::(mapList f R);

fun filter f [] = [] 
| filter f (x::R) = if (f x) then x::(filter f R)
else filter f R ;

map map ;
map (map (fn x=> x*2)) [[1,2],[3,4,5],[6,7,8,9]];

map (filter(fn a => size a = 4))[
    ["hello","world"],
    ["one","two","three","four","five"],
    ["year","month","day"]
    ]
fun nrev [] = [] 
| nrev(x::L) = nrev(L)@[x];

fun revAppend([],acc) = acc 
| revAppend(x::L,acc) = revAppend(L,x::acc);

fun take([],i) = [] 
| take(x::xs,i) = if i> 0 then x::take(xs,i-1)
                            else [];
fun rtake([],_,taken) = taken 
| rtake(x::xs,i,taken) = 
if i> 0 then rtake(xs,i-1,x::taken)
else taken;

fun treeFilter f a  = fn () => case (f a) of
   false => NONE
 | true => SOME  a;
 
 fun treeFilter f = fn t:tree => case f(t)of
   false => NONE
 | true => SOME t;

fun split [] : (int list * int * int list) = raise Fail "cannot split empty list"
    | split(l: int list) =
      let
        val mid = (length l) div 2
        val L = (List.take (l,mid))
        val x :: R = (List.drop (l,mid))
      in
        (L, x, R)
end;
fun partition([],a :int list,b :int list):int list = a@b
| partition(x::R,a,b) = if Int.compare(x, (List.last a)) = GREATER
    then 
        partition(R,a,x::b)
    else
        partition(R,x::a,b);


fun quickSort [] = []
| quickSort x::R = 
 partition(R,[x],[]);
datatype tree = Empty | Node of tree * int * tree ;

fun trav(Empty) = [[]]
| trav(Node(l,x,r)) = 
let 
    val left =  trav(l);
    val right =  trav(r);
    val lr = map (fn R => 0::R) left;
    val rr = map (fn R => 1::R) right;
in [[]]@lr@rr
end ;
fun trav(Empty) = [[]]
| trav(Node(l,x,r)) = 
let 
    val left =  trav(l);
    val right =  trav(r);
    val lr = map (fn R => 0::R) left;
    val rr = map (fn R => 1::R) right;
in [[]]@lr@rr
end ;

fun append(xs, ys) =
if null xs
then ys
else (hd xs) :: append(tl xs, ys)

fun splitAt(xs : int list, x : int) =
let
    fun partition(ys : int list, more : int list, less : int list) =
        if null ys
        then (more, less)
        else
            if hd ys < x
            then partition(tl ys, more, append(less, [hd ys]))
            else partition(tl ys, append(more, [hd ys]), less)
in
    partition(xs, [], [])
end

fun qsort(xs : int list) = 
  if length xs <= 1
  then xs
  else 
    let
        val s = splitAt(xs, hd xs)
    in
        qsort(append(#2 s, #1 s))
    end