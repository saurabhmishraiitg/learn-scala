package org.nexus.udemy

object Strings extends App {

  println("Strings!")

  // General String operators
  val str: String = "Hello World, I Love One Piece"
  println(str.reverse)

  // Scala specific interpolator

  //S-Interpolators
  val name: String = "Naruto"
  val age: Int = 21
  val profession: String = "Pirate"

  println(s"Hi, my name is $name. I'm ${age - 2} years old and my job is $profession")

  //F-Interpolators
  // For formatted strings in printf like fashion

  val speed: Float = 1.287f
  println(f"$name can eat pizza at the rate of $speed%2.1f pizza per hour. His profession is $profession%s")
  // F-Interpolator also enforces type check based upon what required format you define

  //raw-interpolator
  // Can print characters literally e.g. characters like \n, \t are not escaped but printed as is
  println(s"Do you see a \t tab here")
  println(raw"Do you see a \t tab here")
}

