import module namespace atl = "atl_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/tester_atl.xq";

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";

let $imm := "ER.ecore"
let $namespaces := (namespace {""} {"http://er/1.0"}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $schema := "Schema.xsd"
let $in := "ER"
let $omm := "REL.ecore"
let $on := "REL"
let $f :="/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/ER2RL/"
let $t := "ER2RL"
let $pinput := "ER_Properties"
let $poutput := "RL_Properties"
(:let $sc := atl:schema_ecore($imm,$f):)
return 
atl:tester(concat($f,$schema),concat($f,$imm),$in,concat($f,$omm),$on,$f,$t,$pinput,$poutput,5,$namespaces)

 

