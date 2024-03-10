package org.nexus

import org.nexus.hello.Hello
import org.scalatest.Assertions
import org.scalatest.flatspec.AnyFlatSpec

class HelloSpec extends AnyFlatSpec {

  "sample test 1" should "succeed" in {
    val iInt = 10
    val hello1: Hello = new Hello
    hello1.sampleMethod
    assert(iInt != 0)
  }

//  "sample test 2" should "succeed" in {
//    val hello1: Hello = new Hello
//
////    assert(iInt != 0)
//    hello1.sampleMethod
////    assertResult(hello1.)
//  }
}