package org.nexus

/**
 * Extending the Base Spec class.
 */
class ImportBaseSpec extends BaseSpec {

  override def beforeAll {
    logger.info("Before Method of ImportBaseSpec")
  }

  "random test" should "pass" in {
    logger.info("Running the Spec method")
    assert(Set.empty.isEmpty)
  }

  it should "execute without error1" in {
    assertResult({}) {
      (new Hello()).sampleMethod
    }
  }

  it should "execute without error2" in {
    assertResult({}) {
      (new Hello()).sampleMethod
    }
  }

  override def afterAll {
    logger.info("After Method of ImportBaseSpec")
  }

}
