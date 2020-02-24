package org.nexus.scala.udemy

object Expressions extends App {

  var aVar = 8
  aVar /= 4
  // also works with -= *= /=  .... side effects

  println(aVar)

  // Instructions (DO) vs Expressions (VALUE)

  // e.g. IF in scala are expressions
  // In general for other programming languages IF is instruction

  val aCondition = true
  val aConditionedValue = if (aCondition) 12 else 5 // IF expression

  // As in, IF expression here is not trying to DO
  // any assignment, but rather being a value by itself

  println(if (aCondition) 34 else 45)

  // Loops are present in scala, but discouraged since they only create side-effects
  // something specific to 'imperative' programming, which is
  // not advised to be written in java

  // Imperative programming is a programming paradigm that uses statements that change a program's state

  // EVERYTHING in scala is an expression!
  // Only definitions like definition of val, var, class etc.
  // are not expressions, rest everything is

  val aWeirdValue = (aVar = 3) //Type of expression here is UNIT  === equivalent to void in other languages
  println(aWeirdValue)

  // Side effects in scala are expressions returning UNIT
  // e.g.
  var i = 0
  val aWhile = while (i < 10) {
    println(i)
    i += 1
  }

  //side-effects : println, while, reassigning of var
  // side effects are reminescent of imperative programming

  // Code Blocks, special type of expressions

  val aCodeBlock = {
    val y = 2
    val z = y + 3

    if (z > 4) "Hello" else "Bye"
  }

  // Value of code block is value of the last expression

}
