package org.nexus.scala.udemy

import scala.annotation.tailrec

object LearningScala extends App {

  //Exercise 1
  val pi: Double = math.Pi

  println("Value of pi is " + pi)
  println(f"Value of pi is $pi%.3f")

  //Exercise 2
  @tailrec
  def aFibonacciFunction(num: Int, first: Int = 0, second: Int = 1, index: Int = 1): Unit = {
    if (index <= num && num > 0 && index > 0)
      if (index == 1) {
        print(1 + " ")
        aFibonacciFunction(num = num, first = 0, second = 1, index = index + 1)
      }
      else {
        print((first + second) + " ")
        aFibonacciFunction(num = num, first = second, second = first + second, index = index + 1)
      }
  }

  aFibonacciFunction(12)

  //Exercise 3
  def aStringReverseFunction(string: String): String = {
    string.reverse
  }

  def passingAFunctionSimple(string: String, func: String => String): String = {
    func(string)
  }

  println("\n" + passingAFunctionSimple("anagram", aStringReverseFunction))
  println(passingAFunctionSimple("anagram", x => x.toUpperCase))

  // Data Structures
  // Tuple
  val aTuple = ("Saurabh", "Naruto", "Luffy")

  // Tuple indexing is 1 based/starts at 1
  println("Access tuple element -> " + aTuple._1)

  // Tuple with key, value connotation
  val aKeyValueTuple = "Saurabh" -> "Mishra"
  println("Access to a key-value based Tuple is same as any other tuple -> " + aKeyValueTuple._2)

  // Tuple can contain different data types
  val aVarietyDataTypeTuple = ("Saurabh", 29, "Naruto", 21)
  println("Access a variety data-type tuple -> " + aVarietyDataTypeTuple._2)

  // List
  // List is like a tuple, but with more features and more flexibility
  // List needs all the elements to be of the same type
  val aList = List("Naruto", "Luffy", "Ichigo")

  // A List is 0 index based unlike a tuple
  println("Access elements from a list -> " + aList(0))

  // List elements are singly linked i.e. you can access them as head/tail fashion
  // Head gives the first element
  println("Access head of the list -> " + aList.head)

  // Tail gives the remaining elements of the list after the head i.e. it returns a sublist
  println("Access tail (sub-list) of the list -> " + aList.tail)

  // Iterating through a list
  for (name <- aList) {
    println("Iterating over list elements -> " + name)
  }

  // Apply a function to all the elements of a list and return a new list can be done using 'map'
  val aUpperList = aList.map((name: String) => name.toUpperCase)

  for (name <- aUpperList) {
    println("Iterating over list elements -> " + name)
  }

  // Using reduce on a list
  val aNumList = List(1, 2, 3, 4, 5, 6, 7)
  val reducedList = aNumList.reduce((x: Int, y: Int) => x + y)
  println("Value of the reduced list -> " + reducedList)

  // Using filter on a list
  val filtered5List = aNumList.filter((x: Int) => x != 5)
  println("Filtered List looks how -> " + filtered5List)

  // A compact syntax for filtering, using wildcard
  val anotherFilteredList = aNumList.filter(_ != 6)
  println("Another filtered list -> " + anotherFilteredList)

  // More List operators
  // Combine 2 lists
  val anotherNumList = List(1, 2, 3, 4, 5)

  val combinedList = aNumList ++ anotherNumList
  println("Combined List -> " + combinedList)

  // Reverse a list
  println("Reversed List -> " + aNumList.reverse)

  // Sort a List
  println("Sorted List -> " + aNumList.sorted)

  // Deduplicate list
  println("Deduplicated List -> " + combinedList.distinct)

  // Max value from a list
  println("Max value from a list -> " + combinedList.max)

  // Sum of a list of numbers
  println("Sum of list of Numbers -> " + combinedList.sum)

  // Check for element in list
  println("Check if list contains 4 -> " + combinedList.contains(4))


  // Maps
  val aMap = Map("Saurabh" -> "Mishra", "Uzumaki" -> "Naruto", "Monkey D" -> "Luffy", "Kurosaki" -> "Ichigo")

  println("Get element from the map -> " + aMap.get("Uzumaki"))
  println("Get element from the map -> " + aMap("Monkey D"))

  // Try catch operation to handle error in Scala
  val getIfAvailable = util.Try(aMap("Jyu Viole")) getOrElse ("You Don't Know him?")
  println("Did we get the person -> " + getIfAvailable)


  // Exercise 4
  // Check which numbers are divisible by 3 and print the remaining
  for (x <- 1 to 20) {
    if (x % 3 == 0) print(" " + x)
  }
  println("\n")

  // Approach 2
  val aListOfNumbers = List.range(20, 41)
  for (num <- aListOfNumbers) {
    if (num % 3 == 0) print(" " + num)
  }
  println("\n")

  // Approach 3
  val anotherListOfNumbers = List.range(234, 298)
  anotherListOfNumbers.filter(_ % 3 == 0).map(" " + _).foreach(print)

}
