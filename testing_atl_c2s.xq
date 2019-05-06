import module namespace atl = "atl_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/tester_atl.xq";

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";


let $namespaces := (namespace {""} {"http://ualberta.edu.cs.ssrg.student"}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $imm := "Composed.ecore"
let $schema := "Schema.xsd"
let $in := "Composed"
let $omm := "Simple.ecore"
let $on := "Simple"
let $f :="/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/Composed2Simple/"
let $t := "Composed2Simple"
let $pinput := "Composed_Properties"
let $poutput := "Simple_Properties"
let $sc := atl:schema_ecore($imm,$f)
return 
atl:tester(concat($f,$schema),concat($f,$imm),$in,concat($f,$omm),$on,$f,$t,$pinput,$poutput,1,$namespaces)



