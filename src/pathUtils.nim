
import strutils

proc getFileName*(filePath: string, includeExtension: bool = true): string = 
    var addDot = ""
    var bybars = filePath.split("/")
    var file = bybars[bybars.len()-1];
    if file.startsWith("."):
        addDot = "."
        file.removePrefix(".")
    if includeExtension:
        return addDot & file
    else:
        var bydots = file.split(".")
        return addDot & bydots[0];

proc getDirName*(dirPath: string): string = 
    var bybars = dirPath.split("/")
    if dirPath.endsWith("/"):
        return bybars[bybars.len()-2]
    else:
        return bybars[bybars.len()-1]