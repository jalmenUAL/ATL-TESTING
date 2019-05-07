import module namespace at = "atl_testing" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/tester_atl.xq";
import module namespace e2x = "ecore2xmlschema" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/ecore2xmlschema.xq";

 
let $imm := "Book.ecore"
let $f :="/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/wp-drop-atl/ATL-Testing/Book2Publication/"
return
at:schema_ecore($imm,$f)