package org.nexus

import com.typesafe.scalalogging.LazyLogging
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should
import org.scalatest.{BeforeAndAfterAll, Inside, Inspectors, OptionValues}

/**
 * Create a base class and extending it in your other classes, avoids need for duplicating code, imports
 * in your test classes.
 */
abstract class BaseSpec extends AnyFlatSpec with should.Matchers with OptionValues with Inside with Inspectors with BeforeAndAfterAll with LazyLogging

