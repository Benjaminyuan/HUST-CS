type order = LESS | EQUAL | GREATER

fun compare(x:int,y:int):order = 
if x < y then LESS else
if y < x then GREATER else EQUAL;

fun sorted [] = true
| sorted [x] = true
| sorted x::y::L = 
    (compare(x,y) <> GREATER ) andalso sorted(y::L);
(* 插入排序 *)
fun ins(x,[]) = [x] 
| ins(x,y::L) = case compare(x,y) of 
    GREATER => y::ins(x,L)
| _ => x::y::L

fun isort [] = [] 
| isort(x::L) = ins(x,isort L);

fun isort'[] = [] 
| isort'[x] = [x] 
| isort'[x::L] = ins(x isort'L);
(* 归并排序 *)

fun split [] = ([],[])
| split [x] = ([x],[])
| split (x::y::L) = 
    let val (A,B) = split L 
    in (x::A,y::B)
    end

fun merge(A,[]) = A 
| merge([],B) = B
| merge(x::A,y::B) = case compare(x,y) of
    LESS => x::merge(A,y::B)
    | EQUAL => x::y::merge(A,B)
    | GREATER => y::merge(x::A,B);

fun msort [] = [] 
    | msort [x] = [x]
    | msort L = let
                    val (A,B) = split L 
                in 
                    merge(msort A, msort B)
                end

