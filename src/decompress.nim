import zippy/ziparchives

proc decompressFile*(filepath: string, zippath: string): string = 
    let reader = openZipArchive(zippath)
    try:
        let contents = reader.extractFile(filepath)
        return contents
    finally:
        reader.close()