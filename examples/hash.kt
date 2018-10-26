import sodium.sodium_init
import sodium.crypto_generichash
import sodium.crypto_generichash_BYTES

import util.toHexString
import kotlinx.cinterop.*

@Suppress("UNRESOLVED_REFERENCE")
fun main(args: Array<String>) {
  val rc = sodium_init()

  if (0 != rc) {
    throw Error("sodium_init() != 0")
  }

  val buffer = ByteArray(crypto_generichash_BYTES.toInt())
  val message = "hello"

  buffer.usePinned { pinned ->
    crypto_generichash(
      @Suppress("UNCHECKED_CAST") (pinned.addressOf(0) as CValuesRef<UByteVar>),
      buffer.size.convert(),
      @Suppress("UNCHECKED_CAST") (message.cstr as CValuesRef<UByteVar>),
      message.length.convert(),
      null, // key
      0 // key size
    )
  }

  println("${toHexString(buffer)} = crypto_generichash()")
}
