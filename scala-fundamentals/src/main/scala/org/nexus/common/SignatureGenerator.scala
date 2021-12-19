package com.walmart.dsi.gg.components.extractors

import java.security.{KeyRep, PrivateKey, Signature}
import java.util.Base64
import scala.collection.mutable

/**
 * ServiceNow Signature Generate
 */
object SignatureGenerator {


  /*
   * WM_SVC.ENV=[stg]
 WM_SEC.AUTH_SIGNATURE=[PW/hpjBprkp6NcybAnJlrI4gXztr3DeScZobic5ny4SN5GmHZcPgNsiLMzXyNwxArok+yHEFsV10X6W0FNenphBCHRjLZepIeBv6241g8yvNIzWTWe+GVDBvQ1n5GiAJB8RpsN2lb+bBcboNsAC20Nk/IbMastCPO9BwnjP+YsU=]
 WM_CONSUMER.ID=[34395f1b-600c-4e84-ac37-d1d004fc65bd]
 WM_SEC.KEY_VERSION=[1]
 WM_SVC.VERSION=[1.0.0]
 WM_QOS.CORRELATION_ID=[request-id-1]
 WM_SVC.NAME=[abc-demo]
 WM_CONSUMER.INTIMESTAMP=[1510054360551]}
   */
  def main(args: Array[String]): Unit = {
//    val generator = new SignatureGenerator
    val consumerId = "e07b76c0-be48-4582-b9fd-d4738a723b29"
    val privateKeyVersion = "3"
    val privateKey = "xxx"
    val inTimestamp = System.currentTimeMillis
    val map = new mutable.HashMap[String, String]()
    map.put("WM_CONSUMER.ID", consumerId)
    map.put("WM_CONSUMER.INTIMESTAMP", inTimestamp.toString)
    map.put("WM_SEC.KEY_VERSION", privateKeyVersion)
    val array = canonicalize(map)
    val data = generateSignature(privateKey, array.toSeq(1))
    System.out.println("inTimestamp: " + inTimestamp)
    System.out.println("Signature: " + data)
  }

  def generateSignature(key: String, stringToSign: String): String = {
    System.out.println("stringToSign -> " + stringToSign.toString)
    val signatureInstance = Signature.getInstance("SHA256WithRSA")
    val keyRep = new ServiceKeyRep(KeyRep.Type.PRIVATE, "RSA", "PKCS#8", Base64.getDecoder.decode(key))
    val resolvedPrivateKey = keyRep.readResolve1.asInstanceOf[PrivateKey]
    signatureInstance.initSign(resolvedPrivateKey)
    val bytesToSign = stringToSign.getBytes("UTF-8")
    signatureInstance.update(bytesToSign)
    val signatureBytes = signatureInstance.sign
    val signatureString = Base64.getEncoder.encodeToString(signatureBytes)
    signatureString
  }

  def canonicalize(headersToSign: mutable.HashMap[String, String]): Array[String] = {
    val canonicalizedStrBuffer = new StringBuffer
    val parameterNamesBuffer = new StringBuffer
    val keySet : scala.collection.Set[String]  = headersToSign.keySet
    // Create sorted key set to enforce order on the key names
//    val sortedKeySet = keySet.asInstanceOf[mutable.SortedSet[String]]
    val sortedKeySet = keySet.toSeq.sorted
//    val sortedKeySet = new mutable.TreeSet[String](keySet).asInstanceOf[mutable.SortedSet[String]]
    for (key <- sortedKeySet) {
      val header = headersToSign(key)
      parameterNamesBuffer.append(key.trim).append(";")
      canonicalizedStrBuffer.append(header.toString.trim).append("\n")
    }
    Array[String](parameterNamesBuffer.toString, canonicalizedStrBuffer.toString)
  }

  @SerialVersionUID(-7213340660431987616L)
  class ServiceKeyRep(val `type`: KeyRep.Type, val algorithm: String, val format: String, val encoded: Array[Byte]) extends KeyRep(`type`, algorithm, format, encoded) {
    override protected def readResolve: Object = super.readResolve

    def readResolve1: Any = readResolve
  }
}
