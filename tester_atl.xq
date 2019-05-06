module namespace atl = "atl_testing";
import module namespace m = "tester.ATLmachine";
import module namespace tc = "test_cases" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/test_cases.xq";
import module namespace e2x = "ecore2xmlschema" at "/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/TESTING/ecore2xmlschema.xq";

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace rdf = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";
declare namespace testing="http://testing/1.0";

(: IMPORTANT: ECORE SOURCE AND TARGET METAMODELS HAVE TO 
INCLUDE ECORE DATATYPES AND ROOT ELEMENT PACKAGE :)



declare function atl:schema_ecore($imm,$f)

{
  let $imm2 := concat($f,$imm)
  let $namespaces := (namespace {""} {doc($imm2)/ecore:EPackage/@nsURI}, namespace {"xmi"} {"http://www.omg.org/XMI"}, attribute {"xmi:version"} {"2.0"})
  let $sch := e2x:ecore2schema(doc($imm2))
   
  let $write := file:write(concat($f,"Schema.xsd"),$sch)
  return doc(concat($f,"Schema.xsd"))
};


declare function atl:tester($schema,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$i,$namespaces)
{ 
  
  
  let $dele :=
  (if (file:exists(concat($f,'examples'))) then
  file:delete(concat($f,'examples'),true()) else ())
  let $delti :=
  (if (file:exists(concat($f,'testingI'))) then
  file:delete(concat($f,'testingI'),true()) else ())
  let $delto :=
  (if (file:exists(concat($f,'outputs'))) then
  file:delete(concat($f,'outputs'),true()) else ())
   let $delti :=
  (if (file:exists(concat($f,'testingO'))) then
  file:delete(concat($f,'testingO'),true()) else ())
  
  let $ce := file:create-dir(concat($f,'examples'))
  let $cti := file:create-dir(concat($f,'testingI'))
  let $co := file:create-dir(concat($f,'testingO'))
  let $cto := file:create-dir(concat($f,'outputs'))
  
  
  let $tmm := concat($f,'Testing.ecore')
  let $tn := "Testing"
  
  return
  atl:atester(doc($schema),$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,$i,$namespaces)
};


(: TESTER: MAIN FUNCTION :)

declare function atl:atester($schema as node()*,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,$i,$namespaces)
{
  atl:tester_loop(tc:unfold($schema),$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,0,$i,0,0,$namespaces)
};

(: TESTER_LOOP :)

declare function atl:tester_loop($schema as node()*,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,$k as xs:integer, $i as xs:integer,$tests as xs:integer,$tvalids,$namespaces)
{
if ($k>$i) then
  atl:show_passed($tests,$tvalids)
else 
atl:tester_schema($schema,$schema,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,$k,$i,$tests,
$tvalids,$namespaces)
}; 

 

declare function atl:test_examples($schemas,$all,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,
$k,$i,$tests,$tvalids,$namespaces,$examples,$p,$n)
{
  if ($p > $n) then 
  atl:tester_schema(tail($schemas),$all,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,
                       $tn,$k,$i,$tests,$tvalids,$namespaces)
  else
  let $e := file:write(concat(concat(concat($f,"examples/example"),$tests),".xmi"),$examples[$p])
  let $ti := file:write(concat(concat(concat($f,"testingI/testing_i"),$tests),".xmi"),())
  let $o := file:write(concat(concat(concat($f,"outputs/output"),$tests),".xmi"),())
  let $to := file:write(concat(concat(concat($f,"testingO/testing_o"),$tests),".xmi"),())
  let $atl := m:atl($imm,$in,$tmm,$tn,
                concat(concat(concat($f,"examples/example"),$tests),".xmi"),
                concat(concat(concat($f,"testingI/testing_i"),$tests),".xmi"),$f,$pinput)
                return
                if (some 
                $prop in 
                doc(concat(concat(concat($f,"testingI/testing_i"),$tests),".xmi"))//testing:Property satisfies
                empty($prop/@Value))
                then 
                atl:test_examples($schemas,$all,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,
$k,$i,$tests+1,$tvalids,$namespaces,$examples,$p+1,$n)  
                else 
                let $e := file:write(
                  concat(concat(concat($f,"examples/example"),$tests),".xmi"),$examples[$p])
                let $ti := file:write(
                  concat(concat(concat($f,"outputs/output"),$tests),".xmi"),())
                let $atl := m:atl($imm,$in,$omm,$on,
                        concat(concat(concat($f,"examples/example"),$tests),".xmi"), 
                        concat(concat(concat($f,"outputs/output"),$tests),".xmi"),$f,$t)
                       let $atl2 := 
                       m:atl($omm,$on,$tmm,$tn,
                       concat(concat(concat($f,"outputs/output"),$tests),".xmi"),
                       concat(concat(concat($f,"testingO/testing_o"),$tests),".xmi"),$f,$poutput)
                       return
                       if (some 
                       $prop in 
                       doc(concat(concat(concat($f,"testingO/testing_o"),$tests),".xmi"))//testing:Property satisfies    
                           empty($prop/@Value))
                       then atl:show_falsifiable_output($tests+1,$examples[$p],
                     doc(concat(concat(concat($f,"outputs/output"),$tests),".xmi"))) 
                       else 
                       atl:test_examples($schemas,$all,$imm,$in,$omm,$on,$f,$t,$pinput,
                       $poutput,$tmm,$tn,$k,$i,$tests+1,$tvalids+1,$namespaces,$examples,$p+1,$n)
  
};


(: TESTER_SCHEMA :)

declare function atl:tester_schema($schemas as node()*,$all as node()*,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,$tmm,$tn,$k as xs:integer,$i as xs:integer,$tests as xs:integer,$tvalids,$namespaces)
{
  if (empty($schemas)) then let $new := atl:new_schemas($all)
                        return
                        atl:tester_loop($new,$imm,$in,$omm,$on,$f,$t,$pinput,$poutput,
                        $tmm,$tn,$k + 1,$i,$tests,$tvalids,$namespaces)
                       else 
                       let $sc := head($schemas)
                       return
                       let $examples := 
                       (if (some $i in 1 to count(tc:refs($sc))
                          satisfies
                            tc:minOccursElement(tc:refs($sc)[$i]/parent::*/parent::*/parent::*)>=1)
                              then 
                               ()
                       else 
                       let $structure := 
                       tc:skeleton($sc/xs:schema/xs:element,true(),$namespaces)
                       return
                       tc:populate($structure,tc:getTypes($structure),
                       tc:getVal($structure,$sc/xs:schema,tc:getTypesName($structure))))
                       return
                  
                    atl:test_examples($schemas,$all,$imm,$in,$omm,$on,$f,$t,$pinput,
                    $poutput,$tmm,$tn,$k,$i,$tests,$tvalids,$namespaces,$examples,1,count($examples))
                       
                       
                       
             
};


declare function atl:show_fail_pre()
{
<Text>
Input property cannot be satisfied.
</Text>/text()
};


(: SHOW_PASSED :)

 

declare function atl:show_passed($tests,$tvalids)
{
if ($tests=0) then
<Text>
Unable to check the property.
</Text>/text() 
else
<Text>
Ok: passed {$tests} tests, {$tvalids} valid.
</Text>/text() 
};

(: SHOW_UNABLE :)

declare function atl:show_unable()
{
<Text>
Unable to test the property.
</Text>/text() 
};

(: SHOW_FALSIFIABLE :)

declare function atl:show_falsifiable_output($tests,$counter,$result)
{
<Text>
Output Property Falsifiable after {$tests} tests.
Counterexample:
{$counter}
Result:
{$result}
</Text>/(text() | *) 
};

declare function atl:show_falsifiable_input_output($tests,$counter)
{
<Text>
Input-Output Property Falsifiable after {$tests} tests.
Counterexamples:
{$counter}
</Text>/(text() | *) 
};

(: SHOW_FAIL_PROPERTY:)

declare function atl:show_fail_property($property)
{
<Text>
The property: {$property} does not exists.
</Text> 
};

(: NEW_SCHEMAS :)

declare function atl:new_schemas($schema)
{
let $count := count($schema)
let $new := (for $k in 1 to $count return tc:increase($schema[$k]))
return $new              
};




