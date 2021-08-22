package org.nexus.udemy

/**
  *
  */
object ValuesVariablesTypes extends App {

  // VALs are immutable
  val x: Int = 10
  println(x)

  //Immutable cannot be reassigned

  // Types of VAL are optional
  // Compiler can infer types
  val y = 12
  println(y)

  // Variables

  var a: String = "Saurabh"
  a = "Naruto"  // side effects
}
