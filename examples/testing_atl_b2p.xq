import module namespace atl = "atl_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/tester_atl.xq";
declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";


let $namespaces := (namespace {""} {"http://Book/1.0"}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $imm := "Book.ecore"
let $schema := "Schema.xsd"
let $in := "Book"
let $omm := "Publication.ecore"
let $on := "Publication"
let $f :="/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/Book2Publication/"
let $t := "Book2Publication"
let $pinput := "Book_Properties"
let $poutput := "Publication_Properties"
let $sc := atl:schema_ecore($imm,$f)
return 
atl:tester(concat($f,$schema),concat($f,$imm),$in,concat($f,$omm),$on,$f,$t,$pinput,$poutput,2,$namespaces)

 

