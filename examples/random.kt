import sodium.sodium_init
import sodium.randombytes_buf
import sodium.randombytes_random
import sodium.randombytes_uniform

import util.toHexString
import kotlinx.cinterop.*

@Suppress("UNRESOLVED_REFERENCE")
fun main(args: Array<String>) {
  val rc = sodium_init()

  if (0 != rc) {
    throw Error("sodium_init() != 0")
  }

  println("${randombytes_random()} = randombytes_random()")
  println("${randombytes_uniform(37)} = randombytes_uniform(37)")

  var buffer = ByteArray(16)

  buffer.usePinned { pinned ->
    randombytes_buf(pinned.addressOf(0), buffer.size.convert())
  }

  println("${toHexString(buffer)} = randombytes_buf(ByteArray(16), 16)")
}
