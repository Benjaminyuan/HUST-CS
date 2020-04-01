datatype tree = Empty | Node of tree * int * tree ;
type order = LESS | EQUAL | GREATER
fun compare(x:int,y:int):order = 
if x < y then LESS else
if y < x then GREATER else EQUAL;

fun size Empty = 0 
| size(Node(t1,_,t2)) = sizet2 + sizet1 +1;

fun depth Empty = 0 
| depth(Node(t1,_,t2)) = max(depth t1,depth t2) +1;

fun trav Empty = [] 
| trav(Node(t1,x,t2)) = trav t1 @(x::trav t2);

fun Ins(x,Empty) = Node(Empty,x,Empty)
| Ins(x,Node(t1,y,t2)) = 
    case compare(x,y) of
    GREATER => Node(t1,y,Ins(x,t2))
    | _  => Node(Ins(x,t1),y,t2);

fun SplitAt(y,Empty) = (Empty,Empty)
| SplitAt(y,Node(t1,x,t2)) = 
    case compare(x,y) of
        GREATER => let 
                        val (l1,r1) = SplitAt(y,t1)
                    in (l1,Node(r1,x,t2))
                    end
        | _ => let 
                    val (l2,r2) = SplitAt(y,t2)
                    in  (Node(t1,x,l2),r2)
                    end

fun Merge(Empty,t2) = t2
| Merge(Node(l1,x,r1),t2) = 
    let 
        val(l2,r2) = SplitAt(x,t2)
    in
        Node(Merge(l1,l2),x,Merge(r1,r2))
    end 

