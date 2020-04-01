datatype tree = Empty | Node of tree * int * tree ;
type order = LESS | EQUAL | GREATER

fun reverse [] = [] 
| reverse (x::L) = (reverse L) @([x]);

fun reversehelp'(L :int list ,A: int list): int list = 
case L of
   [] => A
 | x::R => reversehelp'(R,x::A);
fun reverse'(L:int list) :int list = 
    reversehelp'(L,[]);


fun interleave([],B) = B
| interleave(A,[]) = A
| interleave(x::L1,y::L2) = x::y::interleave(L1,L2);


fun split [] : (int list * int * int list) = raise Fail "cannot split empty list"
    | split(l: int list) =
      let
        val mid = (length l) div 2
        val L = (List.take (l,mid))
        val x :: R = (List.drop (l,mid))
      in
        (L, x, R)
end;

fun listToTree([]:int list): tree = Empty
| listToTree(L) =
let 
        val (L,x,R) = split(L)
    in 
        Node(listToTree(L),x,listToTree(R))
end;

fun trav(Empty) = []
| trav(Node(l,x,r)) = trav(l)@(x::trav(r));

fun revT(Empty) = Empty 
| revT(Node(l,x,r)) = Node(revT(r),x,revT(l));

fun binarySearch(Empty:tree, x:int ):bool= false
| binarySearch(Node(l,y,r),x) = 
    case Int.compare(y,x) of
         GREATER => binarySearch(l,x)
        | LESS => binarySearch(r,x)
        | EQUAL => true;

