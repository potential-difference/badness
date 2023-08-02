import zippy
import std/[xmlparser,xmltree,memfiles,tables,options,macros]

proc property(x:XMLNode,s:string):Option[XMLNode] =
  for p in x.child("properties").findAll("property"):
    if p.child("key")[0].text == s:
      return some(p)
  return none(XMLNode)
proc `[]`(x:Option[XMLNode],idx:int):Option[XMLNode] =
  if x.isSome and idx < x.get.len:
    some(x.get[idx])
  else:
    none(XMLNode)
proc text(x:Option[XMLNode]):Option[string] =
  if x.isSome:
    some(x.get.text)
  else:
    none(string)
template `.`(x:Option[XMLNode],meth:untyped,args:varargs[typed]):Option[XMLNode] =
  if x.isSome:
    let res = unpackVarargs(x.get.meth,args)
    if not res.isNil:
      some(res)
    else:
      none(XMLNode)
  else:
    none(XMLNode)
#proc child(x:Option[XMLNode],s:string):Option[XMLNode] =
#  if x.isSome:
#    let res = x.get.child(s)
#    if not res.isNil:
#      result = some(res)


const filename = "untitled.tosc"
when isMainModule:
  #let len = filename.stat.st_size
  var file = "untitled.tosc".open(fmReadWrite,allowRemap=true)
  #echo "len: ",len,"size: ",file.size
  var xmldata = uncompress(file.mem,file.size).parseXml#newStringStream
  var xs = xmldata.findAll("node")
  for i in xs:
    echo i.attr("type"),' ',i.property("name").child("value")[0].text

  let output = compress($xmldata,dataFormat=dfZlib)
  file.resize(output.len)
  copyMem(file.mem,output.cstring,output.len)
  file.close
