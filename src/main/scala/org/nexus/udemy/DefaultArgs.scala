package org.nexus.udemy

object DefaultArgs extends App {

  println("Default Args!")

  // Function without any default value defined
  def sayHelloFunction(name: String): Unit = println("Hello " + name + "!")

  sayHelloFunction("Saurabh")

  def sayHelloFunctionWithDefaults(name: String = "Saurabh"): Unit = println("Hello " + name + "!")

  sayHelloFunctionWithDefaults()

  //Function with defaults out of order
  def greetingsPeople(name1: String = "Saurabh", age1: Int = 29, name2: String = "Naruto", age2: Int = 21): Unit =
    println("Hello " + name1 + ", " + name2)

  greetingsPeople(name1 = "Mishra", age2 = 19)
}
