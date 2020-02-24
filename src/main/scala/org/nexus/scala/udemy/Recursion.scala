package org.nexus.scala.udemy

import scala.annotation.tailrec

object Recursion extends App {

  println("Recursing My Way Away!")

  def factorial(n: Int): Int =
    if (n <= 1) 1
    else {
      // println("Computing factorial of " + n + " - I first need factorial of " + (n - 1))
      val result = n * factorial(n - 1)
      // println("Computed factorial of " + n)

      result
    }

  println(factorial(10))
  //  println(factorial(5000))

  def anotherFactorial(n: Int): BigInt = {
    @tailrec
    def factHelper(x: Int, accumulator: BigInt): BigInt =
      if (x <= 1) accumulator
      else factHelper(x - 1, x * accumulator) // TAIL RECURSION = use recursive call as the LAST expression

    factHelper(n, 1)
  }

  /*
    anotherFactorial(10) = factHelper(10, 1)
    = factHelper(9, 10 * 1)
    = factHelper(8, 9 * 10 * 1)
    = factHelper(7, 8 * 9 * 10 * 1)
    = ...
    = factHelper(2, 3 * 4 * ... * 10 * 1)
    = factHelper(1, 1 * 2 * 3 * 4 * ... * 10)
    = 1 * 2 * 3 * 4 * ... * 10
   */
  val factorialOf = 20
  println("Factorial of " + factorialOf + " is " + anotherFactorial(factorialOf))

  // WHEN YOU NEED LOOPS, USE _TAIL_ RECURSION.

  // Exercise 1
  // Non TAIL Recursive version
  def concatenationFunction(str: String, cnt: Int): String = {
    if (cnt == 1) str else str + " " + concatenationFunction(str, cnt - 1)
  }

  @tailrec
  def anotherConcatenationFunction(str: String, accum: String, cnt: Int): String = {
    if (cnt == 1) accum + " " + str else anotherConcatenationFunction(str, accum + " " + str, cnt - 1)
  }

  //println(concatenationFunction("Om", 7000))

  println(anotherConcatenationFunction("Om", "", 10))

  // Exercise 2
  def anotherPrimeCheckFunction(number: Double): Boolean = {
    @tailrec
    def primeCheckForNumber(primeNumber: Double, checkFor: Double, maxCheck: Double): Boolean = {
      if (checkFor > maxCheck) true else if (checkFor != 1 && primeNumber % checkFor == 0) {
        println("divisible by " + checkFor);
        false
      } else primeCheckForNumber(primeNumber, checkFor + 1, maxCheck)
    }

    primeCheckForNumber(number, 2, math.floor(math.sqrt(number)))
  }

  val checkNum = anotherFactorial(21).toDouble - 1
  println("Checking for " + checkNum)
  //println(anotherPrimeCheckFunction(1000000000100011d))
  println(anotherPrimeCheckFunction(23))

  // Exercise 3
  def anotherFibonacciFunction(num: Int): BigInt = {
    @tailrec
    def nextFibonacciSequence(firstNum: BigInt, secondNum: BigInt, currentIndex: Int, finalIndex: Int): BigInt = {
      if (currentIndex == finalIndex) {
        print(" " + (firstNum + secondNum));
        firstNum + secondNum
      } else {
        print(" " + (firstNum + secondNum));
        nextFibonacciSequence(secondNum, firstNum + secondNum, currentIndex + 1, finalIndex)
      }
    }

    if (num < 3) 1 else {
      print("1 1");
      nextFibonacciSequence(1, 1, 3, num)
    }
  }

  val fibonacciSequenceNumber = 13
  println("\nFibonacci Number is " + anotherFibonacciFunction(fibonacciSequenceNumber))
}
