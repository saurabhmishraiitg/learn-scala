package org.nexus

import org.scalatest.flatspec.AnyFlatSpec

class BasicSpec extends AnyFlatSpec {

  "An empty Set" should "have size 0" in {
    assert(Set.empty.isEmpty)
  }

  it should "return non empty" in {
    assert(Set.empty.isEmpty)
  }

  "set" must "be empty" in {
    assert(Set.empty.isEmpty)
  }
}
