package util

private val table = "0123456789abcdef".toCharArray()

fun toHexString(bytes: ByteArray): String {
  var output = CharArray(2 * bytes.size)
  for (i in bytes.indices) {
    val j = (bytes[i].toInt() and 0xff).toInt()
    output[2 * i] = table[j ushr 4]
    output[1 + 2 * i] = table[j and 0x0f]
  }
  return String(output)
}
