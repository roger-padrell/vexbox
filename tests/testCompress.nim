import ../src/compression, unittest

suite "Compression":
  # Setup
  var initial: seq[int] = @[]
  var final: seq[int] = @[]

  test "Sample JSON":
    let sample = """{"web-app":{"servlet":[{"servlet-name":"cofaxCDS","servlet-class":"org.cofax.cds.CDSServlet","init-param":{"configGlossary:installationAt":"Philadelphia,PA","configGlossary:adminEmail":"ksm@pobox.com","configGlossary:poweredBy":"Cofax","configGlossary:poweredByIcon":"/images/cofax.gif","configGlossary:staticPath":"/content/static","templateProcessorClass":"org.cofax.WysiwygTemplate","templateLoaderClass":"org.cofax.FilesTemplateLoader","templatePath":"templates","templateOverridePath":"","defaultListTemplate":"listTemplate.htm","defaultFileTemplate":"articleTemplate.htm","useJSP":false,"jspListTemplate":"listTemplate.jsp","jspFileTemplate":"articleTemplate.jsp","cachePackageTagsTrack":200,"cachePackageTagsStore":200,"cachePackageTagsRefresh":60,"cacheTemplatesTrack":100,"cacheTemplatesStore":50,"cacheTemplatesRefresh":15,"cachePagesTrack":200,"cachePagesStore":100,"cachePagesRefresh":10,"cachePagesDirtyRead":10,"searchEngineListTemplate":"forSearchEnginesList.htm","searchEngineFileTemplate":"forSearchEngines.htm","searchEngineRobotsDb":"WEB-INF/robots.db","useDataStore":true,"dataStoreClass":"org.cofax.SqlDataStore","redirectionClass":"org.cofax.SqlRedirection","dataStoreName":"cofax","dataStoreDriver":"com.microsoft.jdbc.sqlserver.SQLServerDriver","dataStoreUrl":"jdbc:microsoft:sqlserver://LOCALHOST:1433;DatabaseName=goon","dataStoreUser":"sa","dataStorePassword":"dataStoreTestQuery","dataStoreTestQuery":"SETNOCOUNTON;selecttest='test';","dataStoreLogFile":"/usr/local/tomcat/logs/datastore.log","dataStoreInitConns":10,"dataStoreMaxConns":100,"dataStoreConnUsageLimit":100,"dataStoreLogLevel":"debug","maxUrlLength":500}},{"servlet-name":"cofaxEmail","servlet-class":"org.cofax.cds.EmailServlet","init-param":{"mailHost":"mail1","mailHostOverride":"mail2"}},{"servlet-name":"cofaxAdmin","servlet-class":"org.cofax.cds.AdminServlet"},{"servlet-name":"fileServlet","servlet-class":"org.cofax.cds.FileServlet"},{"servlet-name":"cofaxTools","servlet-class":"org.cofax.cms.CofaxToolsServlet","init-param":{"templatePath":"toolstemplates/","log":1,"logLocation":"/usr/local/tomcat/logs/CofaxTools.log","logMaxSize":"","dataLog":1,"dataLogLocation":"/usr/local/tomcat/logs/dataLog.log","dataLogMaxSize":"","removePageCache":"/content/admin/remove?cache=pages&id=","removeTemplateCache":"/content/admin/remove?cache=templates&id=","fileTransferFolder":"/usr/local/tomcat/webapps/content/fileTransferFolder","lookInContext":1,"adminGroupID":4,"betaServer":true}}],"servlet-mapping":{"cofaxCDS":"/","cofaxEmail":"/cofaxutil/aemail/*","cofaxAdmin":"/admin/*","fileServlet":"/static/*","cofaxTools":"/tools/*"},"taglib":{"taglib-uri":"cofax.tld","taglib-location":"/WEB-INF/tlds/cofax.tld"}}}"""
    let compressed = compress(sample)
    let decompressed = decompress(compressed)
    assert sample == decompressed
    assert compressed.len() < sample.len()
    initial.add(sample.len())
    final.add(compressed.len())

  test "Lorepsum ipsum (100)":
    let sample = """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vel ante at erat interdum vestibulum."""
    let compressed = compress(sample)
    let decompressed = decompress(compressed)
    assert sample == decompressed
    assert compressed.len() < sample.len()
    initial.add(sample.len())
    final.add(compressed.len())

  test "Lorepsum ipsum (1000)":
    let sample = """Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer tristique, lorem quis malesuada pulvinar, nulla est dictum mauris, ut ultricies est magna eget tellus. Maecenas sed elementum dui. Donec pulvinar hendrerit vulputate. Nulla nec faucibus nunc, eget malesuada magna. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis magna quam, imperdiet non elit sed, sollicitudin laoreet nunc. Curabitur sodales urna et lobortis dapibus. Nam interdum quam lectus, dignissim feugiat felis placerat ut. Phasellus quis libero velit. Suspendisse potenti. Nullam imperdiet lobortis tincidunt. Nulla placerat neque nunc, nec fermentum tortor dictum quis. Phasellus molestie odio sed finibus condimentum. Sed eget sem placerat, tristique ligula vitae, commodo neque. Nullam dapibus mollis dui sit amet dictum. Vestibulum eu mattis lorem, ut sollicitudin sem. Vivamus sed diam in lorem feugiat sagittis. Maecenas ut nunc ut ipsum suscipit tempor vel non blandit. """
    let compressed = compress(sample)
    let decompressed = decompress(compressed)
    assert sample == decompressed
    assert compressed.len() < sample.len()
    initial.add(sample.len())
    final.add(compressed.len())
  
  # End (average of compression ratios)
  var all: seq[int] = @[];
  var n = 0;
  while n<initial.len():
    all.add(int((initial[n] - final[n])/initial[n] * 100))
    n = n + 1;

  var total = 0;
  for a in all:
    total = total + a;
  
  echo "Average compression ratio: ", (total/all.len()), "%"