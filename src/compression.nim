import brotli

# Compress JSON string
proc compress*(jsonStr: string): string =
    return compressBrotli(jsonStr, quality = 11)

# Decompress
proc decompress*(compressed: string): string =
    return decompressBrotli(compressed)