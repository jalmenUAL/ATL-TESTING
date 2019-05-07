import module namespace tc = "test_cases" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/test_cases.xq";
import module namespace e2x = "ecore2xmlschema" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/ecore2xmlschema.xq";

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";



let $namespaces := (namespace {""} {"example"}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $tc := tc:test_cases(doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/Schema.xsd"),2,$namespaces)
return $tc




 