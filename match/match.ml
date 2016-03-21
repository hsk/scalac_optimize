type e =
  | EInt of int
  | EVar of string
  | EAdd of e * e
  | ESub of e * e
  | ELetRec of string * e * e
  | EAbs of string * e
  | EIf of e * e * e * e
  | ECall of e * e

type v =
  | VInt of int
  | VFun of string * e
  | VExp of e

let rec lookup env a =
  match env with
  | (x,v)::xs when x = a -> v
  | x::xs -> lookup xs a
  | [] -> failwith ("not found " ^ a)

let rec eval env e =
  match e with
  | EInt(a) -> VInt(a)
  | EVar(a) ->
    (match lookup env a with
      | VExp(e) -> eval env e
      | v -> v
    )
  | EAdd(e1,e2) ->
    (match eval env e1, eval env e2 with
      | (VInt(v1), VInt(v2)) -> VInt(v1+v2)
      | (_, _) -> failwith "error"
    )
  | ESub(e1,e2) ->
    (match eval env e1, eval env e2 with
      | (VInt(v1), VInt(v2)) -> VInt(v1-v2)
      | (_, _) -> failwith "error"
    )
  | EIf(e1,e2,e3,e4) ->
    (match eval env e1, eval env e2 with
      | (VInt(v1), VInt(v2)) ->
        if(v1 <= v2) then eval env e3 else eval env e4
      | (_, _) -> failwith "error"
    )
  | EAbs(x, e2) -> VFun(x, e2)
  | ECall(e1,e2) ->
    (match eval env e1 with
      | VFun(x,ve) -> eval ((x, eval env e2)::env) ve
      | _ -> failwith "error"
    )
  | ELetRec(x,e1,e2) ->
    let v1 = eval ((x,VExp(e1))::env) e1 in
    eval ((x,v1)::env) e2

let ee = ELetRec("fib",EAbs("x",
  EIf(EVar("x"),EInt(1),
    EVar("x"),
    EAdd(ECall(EVar("fib"), ESub(EVar("x"),EInt(1))),
        ECall(EVar("fib"), ESub(EVar("x"),EInt(2)))))),
  ECall(EVar("fib"), EInt(30)))

let time() = int_of_float(Sys.time() *. 1000.)


let bench n run =
  let start = time() in
  for i = 0 to n-1 do
    let start = time() in
    run();
    let end1 = time() in
    let interval = end1 - start in
    Printf.printf "%d ms\n" interval
  done;
  let end1 = time() in
  let interval = end1 - start in
  Printf.printf "avg %d ms\n" (interval/n)


let () =
  bench 5 (fun () ->
    eval [] ee
  )
