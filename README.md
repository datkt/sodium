sodium
======

libsodium bindings for Kotlin/Native.

## Installation

The `datkt.sodium` package an be installed with various package managers.

### From NPM

```sh
$ npm install @datkt/sodium
```

## Prerequisites

* [Kotlin/Native](https://github.com/JetBrains/kotlin-native) and the
  `konanc` command line program.
* [make](https://www.gnu.org/software/make/)

## Usage

```sh
## Compile a program in 'main.kt' and link sodium.klib found in `node_modules/`
$ konanc -r node_modules/@datkt -l sodium/sodium main.kt
```

where `main.kt` might be

```kotlin
import datkt.sodium.* // entire libsodium API
import kotlinx.cinterop.* // exposes types needed for interop

fun main(args: Array<String>) {
  if (0 != sodium_init()) {
    throw Error("Failed to initialize libsodium")
  }
}
````

## Example

```kotlin
import kotlinx.cinterop.*
import datkt.sodium.sodium_init
import datkt.sodium.randombytes_buf
import datkt.sodium.randombytes_random
import datkt.sodium.randombytes_uniform

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

val table = "0123456789abcdef".toCharArray()

fun toHexString(bytes: ByteArray): String {
  var output = CharArray(2 * bytes.size)
  for (i in bytes.indices) {
    val j = (bytes[i].toInt() and 0xff).toInt()
    output[2 * i] = table[j ushr 4]
    output[1 + 2 * i] = table[j and 0x0f]
  }
  return String(output)
}
```

## libsodium API

This package binds libsodiums entire API and provides an
[interop](https://github.com/JetBrains/kotlin-native/blob/master/INTEROP.md)
API for Kotlin and can be imported from the `sodium` package. For
example, the `crypto_generichash()` with the following C function
signature:

```c
int crypto_generichash(unsigned char *out,
                       size_t outlen,
                       const unsigned char *in,
                       unsigned long long inlen,
                       const unsigned char *key,
                       size_t keylen);
```

translates to the following Kotlin function signature:

```kotlin
fun crypto_generichash(out: CValuesRef<UByteVar>?,
                       outlen: size_t,
                       `in`: CValuesRef<UByteVar>?,
                       inlen: ULong,
                       key: CValuesRef<UByteVar>?,
                       keylen: size_t): Int;
```

and can be called in Kotlin like:

```kotlin
val buffer = ByteArray(crypto_generichash_BYTES.toInt())
val message = "hello"

buffer.usePinned { pinned ->
  crypto_generichash(
    pinned.addressOf(0) as CValuesRef<UByteVar>,
    buffer.size.convert(),
    message.cstr as CValuesRef<UByteVar>,
    message.length.convert(),
    null, // key
    0 // key size
  )
}
```

## Building

The `sodium` package can be built from source into various targets.

### Kotlin Library

`sodium.klib`, a Kotlin library that can be linked with `konanc` can be
built from source.

```sh
$ make klib
```

which will produce `build/lib/sodium.klib`. The library can be installed
with `klib` by running `make install`

### Static Library

`libsodium.a`, a static library that can be linked with `konanc` can be
built from source.

```sh
$ make static
```

which will produce `build/lib/libsodium.a` and C header files in
`build/include`. The library can be installed into your system by
running `make install`. The path prefix can be set by defining the
`PREFIX` environment or `make` variable. It defaults to
`PREFIX=/usr/local`

## See Also

* https://libsodium.gitbook.io/doc
* https://github.com/jedisct1/libsodium
* https://github.com/sodium-friends/sodium-native

## License

MIT
