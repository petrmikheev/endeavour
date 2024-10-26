package endeavour

import spinal.core._
import spinal.core.fiber._
import spinal.lib._

class TTT extends Component {
  val io = new Bundle {
    val a = in port Bool()
    val b = out port Bool()
  }

  io.b := ~io.a;

  // Create two empty Handles
  val a, b = Handle[Int]

  // Create a Handle which will be loaded asynchronously by the given body result
  val calculator = Handle {
      a.get + b.get // .get will block until they are loaded
  }

  // Same as above
  val printer = Handle {
      println(s"a + b = ${calculator.get}") // .get is blocking until the calculator body is done
  }

  val xx = fiber.Fiber build new AreaRoot {
    // Synchronously load a and b, this will unblock a.get and b.get
    a.load(3)
    b.load(4)
  }

  val im = misc.InterruptNode.master
  val is = misc.InterruptNode.slave
  is << im
}

object TTT {
  def main(args: Array[String]): Unit = SpinalVerilog(new TTT)
}
