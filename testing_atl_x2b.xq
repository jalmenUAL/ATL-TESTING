import module namespace atl = "atl_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/tester_atl.xq";

(: NO FUNCIONA: SUPERTYPE ABSTRACTO :)

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";


let $namespaces := (namespace {""} {"http://XML/1.0"}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $imm := "XML.ecore"
let $schema := "Schema.xsd"
let $in := "XML"
let $omm := "Book.ecore"
let $on := "Book"
let $f :="/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/Book2Publication/"
let $t := "XML2Book"
let $pinput := "XML_Properties"
let $poutput := "Book_Properties"
let $sc := atl:schema_ecore($imm,$f)
return 
atl:tester(concat($f,$schema),concat($f,$imm),$in,concat($f,$omm),$on,$f,$t,$pinput,$poutput,2,$namespaces)

 

