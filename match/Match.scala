import scala.annotation.tailrec

object Match extends App {

  sealed trait E
  case class EInt(a:Int) extends E
  case class EVar(a:String) extends E
  case class EAdd(e1:E, e2:E) extends E
  case class ESub(e1:E, e2:E) extends E
  case class ELetRec(x:String, e1:E, e2:E) extends E
  case class EAbs(x:String, e2:E) extends E
  case class EIf(e1:E,e2:E,e3:E,e4:E) extends E
  case class ECall(e1:E, e2:E) extends E

  sealed trait V
  case class VInt(a:Int) extends V
  case class VFun(x:String, e:E) extends V
  case class VExp(e:E) extends V

  @tailrec
  def lookup(env:List[(String,V)], a:String):V = {
    env match {
      case (x,v)::xs if x == a => v
      case x::xs => lookup(xs, a)
      case List() => throw new Exception("not found "+a)
    }
  }

  def eval(env:List[(String,V)], e:E):V = {
    e match {
      case EInt(a) => VInt(a)
      case EVar(a) =>
        lookup(env, a) match {
          case VExp(e) => eval(env, e)
          case v => v
        }
      case EAdd(e1,e2) =>
        (eval(env, e1), eval(env, e2)) match {
          case (VInt(v1), VInt(v2)) => VInt(v1+v2)
          case (_, _) => throw new Exception("error")
        }
      case ESub(e1,e2) =>
        (eval(env, e1), eval(env, e2)) match {
          case (VInt(v1), VInt(v2)) => VInt(v1-v2)
          case (_, _) => throw new Exception("error")
        }
      case EIf(e1,e2,e3,e4) =>
        (eval(env, e1), eval(env, e2)) match {
          case (VInt(v1), VInt(v2)) =>
            if(v1 <= v2) eval(env, e3) else eval(env, e4)
          case (_, _) => throw new Exception("error")
        }
      case EAbs(x, e2) => VFun(x, e2)
      case ECall(e1,e2) =>
        eval(env, e1) match {
          case VFun(x,ve) => eval((x->eval(env,e2))::env, ve)
          case _ => throw new Exception("error")
        }
      case ELetRec(x,e1,e2) =>
        val v1 = eval((x -> VExp(e1))::env, e1)
        eval((x->v1)::env, e2)
    }
  }

  val ee = ELetRec("fib",EAbs("x",
    EIf(EVar("x"),EInt(1),
      EVar("x"),
      EAdd(ECall(EVar("fib"), ESub(EVar("x"),EInt(1))),
          ECall(EVar("fib"), ESub(EVar("x"),EInt(2)))))),
    ECall(EVar("fib"), EInt(30)))

  def bench(n:Int)(run: () =>Unit) {
    val start = System.currentTimeMillis()
    for(i <- 0 until n) {
      val start = System.currentTimeMillis()
      run()
      val end = System.currentTimeMillis()
      val interval = end - start
      println(interval + "ms")
    }
    val end = System.currentTimeMillis()
    val interval = end - start
    println("avg "+(interval/n) + "ms")
  }

  bench(5){()=>assert(eval(List(),ee)==VInt(832040))}

}

