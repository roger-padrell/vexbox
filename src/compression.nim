import brotli

# Compress JSON string
proc compress*(str: string): string =
    return compressBrotli(str, quality = 11)

# Decompress
proc decompress*(compressed: string): string =
    return decompressBrotli(compressed)