package org.nexus.udemy

object Functions extends App {

  println("Learning Scala Functions")

  def aFunction(a: String, b: Int): String =
    a + " " + b

  def aRepeatedFunction(a: String, b: Int): String =
    if (b == 1) a
    else
      a + " > " + aRepeatedFunction(a, b - 1)

  println(aRepeatedFunction("Hello", 3))

  // While in normal programming languages we use loops, in scala we use recursive functions
  // Return type of normal functions can be inferred by the compiler, but in case of
  // recursive functions, it's mandatory to specify one

  // Functions with return type of UNIT can also be created. They contain side-effects
  def aFunctionWithSideEffect(a: String): Unit = println(a)

  // Code blocks can be used to define auxillary functions
  def aParentFunction(a: Int): Int = {
    def anAuxillaryFunction(b: Int, c: Int): Int = a + b

    anAuxillaryFunction(a, a - 1)
  }

  //Exercise 1
  def aGreetingFunction(name: String, age: Int): String = "Hi, my name is " + name + " and i am " + age + "yrs old."

  println(aGreetingFunction("Naruto", 21))

  // Exercise 2
  def aFactorialFunction(n: Int): Int = {
    if (n < 1) 1 else n * aFactorialFunction(n - 1)
  }

  println(aFactorialFunction(5))

  // Exercise 3
  def aFibonnaciFunction(n: Int): Int = {
    if (n < 3) 1 else aFibonnaciFunction(n - 1) + aFibonnaciFunction(n - 2)
  }

  println(aFibonnaciFunction(8))

  // Exercise 4
  def aPrimeCheckFunction(num: Int, check: Int): Boolean = {
    def aDivisibilityCheckFunction(dividend: Int, divisor: Int): Boolean = {
      if (divisor == 1 || dividend == divisor) false else dividend % divisor == 0
    }
    // Start checking divisibility with n-1 till n != 1
    // If anywhere in between there is a match on divisibility then we are golden

    if (check == 1 || aDivisibilityCheckFunction(num, check)) !aDivisibilityCheckFunction(num, check) else aPrimeCheckFunction(num, check - 1)
  }

  println(aPrimeCheckFunction(4, 4))


}
