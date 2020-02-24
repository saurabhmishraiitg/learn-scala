package org.nexus.scala.general

import java.sql.Timestamp

/**
  * Investigation on how to lookup class type and tag type for variable in Scala
  * https://stackoverflow.com/questions/19386964/i-want-to-get-the-type-of-a-variable-at-runtime
  */
object VariableType extends App {

  //This returns the value of the variable
  val x = 5

  def f[T](v: T) = v

  println(s"Type is ${f(x)}") // T is Int, the type of x


  val y: Any = "2018-10-10T21:26:37Z"

  def g[T](v: T) = v match {
    case _: Int => "Int"
    case _: String => "String"
    case _: Timestamp => "Timestamp"
    case _ => "Unknown"
  }

  println(s"Type is ${g(y)}") // T is Int, the type of y

  //Get Class for value
  println(s"Class for y ${y.getClass}")


  val z: Any = 5
  import scala.reflect.ClassTag
  def h[T](v: T)(implicit ev: ClassTag[T]) = ev.toString
  println(s"Get Type of a variable : ${h(z)}") // returns the string "Any"
}
