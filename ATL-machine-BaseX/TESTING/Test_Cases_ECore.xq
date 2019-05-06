import module namespace tc = "test_cases" at "C:\Users\Admin\workspace-atl\ATL_tester\TESTING\tc5.xq";
import module namespace e2x = "ecore2xmlschema" at "C:\Users\Admin\workspace-atl\ATL_tester\TESTING\ecore2xmlschema.xq";

declare namespace xmi = "http://www.omg.org/XMI";

let $namespaces := (namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
let $sch := e2x:ecore2schema(doc("C:\Users\Admin\workspace-atl\ATL_tester\EXAMPLES\Book2Publication\Book\Book.ecore"))
let $file := file:create-temp-file("Schema","xsd")
let $write := file:write($file,$sch)
let $tc := tc:test_cases(doc($file),3,$namespaces)
return $tc

