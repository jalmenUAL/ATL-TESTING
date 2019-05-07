module namespace tc = "test_cases";

declare namespace xmi = "http://www.omg.org/XMI"; (: MODIFIED ATL :)

(: REPETITIONS IN CLASS ATTRIBUTES, WRONG CLASS ATTRIBUTES :)


 

(: DISTINTC-DEEP: FOR REPETITIONS TESTING :)

declare function tc:distinct-deep
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(tc:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;
 
 declare function tc:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;

(: ELEMENTS, SEQUENCES AND ATTRIBUTES :)

declare function tc:elements($schema)
{
  
  
  $schema/xs:schema/xs:element 
  union $schema/xs:schema/xs:element//xs:element
  
};

declare function tc:sequences($schema)
{
  $schema/xs:schema/xs:element//xs:sequence
};

declare function tc:attributes($schema)
{
  $schema/xs:schema/xs:element//xs:attribute
};


declare function tc:elems_or_seqs($schema)
{
  $schema/xs:schema/xs:element union $schema/xs:schema/xs:element//(xs:element|xs:sequence)
};


(: REFS :)

declare function tc:refs($schema)
{
  tc:elements($schema)[@ref]
};



(: LESSOCCURS :)

declare function tc:lessOccurs($min,$max)
{
if ($max=-1) then true()
else $min<$max
};

(: INDEX-OF-NODE :) 
 
declare function tc:index-of-node
  ( $nodes as node()* ,
    $nodeToFind as node() )  as xs:integer* {

  for $seq in (1 to count($nodes))
  return $seq[$nodes[$seq] is $nodeToFind]
 } ;

(: PATH-TO-NODE-WITH-POS :)

declare function tc:path-to-node-with-pos
  ( $node as node()? )  as xs:string {

string-join(
  for $ancestor in $node/ancestor-or-self::*
  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
  return concat(name($ancestor),
   if (count($sibsOfSameName) <= 1)
   then ''
   else concat(
      '[',tc:index-of-node($sibsOfSameName,$ancestor),']'))
 , '/')
 } ;
 
 (: PATH-TO-NODE-ECORE :)
 
 declare function tc:path-to-node-ecore
  ( $node as node()? )  as xs:string {

 
string-join(('/',
  for $ancestor in tail($node/ancestor-or-self::*)
  let $sibsOfSameName := $ancestor/../*[name() = name($ancestor)]
  return concat('/@',name($ancestor),
   concat(
      '.',tc:index-of-node($sibsOfSameName,$ancestor)-1))
 ))
 } ;
 
(: PATH-TO-NODE :)

declare function tc:path-to-node
  ( $nodes as node()* )  as xs:string* {

$nodes/string-join(ancestor-or-self::*/name(.), '/')
 } ;
 
(: GETTYPES :)

declare function tc:getTypes($structure)
{
  for $type in $structure//@type return <type>{tc:path-to-node-with-pos($type)}</type>
};

(: GETTYPESNAME :)

declare function tc:getTypesName($structure)
{
  for $type in $structure//@type return <type>{data($type)}</type>
};

(: GETVALUES :) (: MODIFIED ATL :)

declare function tc:getValues($sk,$schema,$type)
{ 
  (
  for $value in data($schema/xs:simpleType[@name=$type]/xs:restriction/xs:enumeration/@value)
  return
  <value>{$value}</value>
  )
  union
  (
  for $x in $sk/descendant-or-self::*[name(.)=$type]
  return <value>{tc:path-to-node-ecore($x)}</value>
   
  )
};

(: GETVAL :) (: MODIFIED ATL :)

declare function tc:getVal($sk,$schema,$types)
{
 for $type in $types return 
 let $values := tc:getValues($sk,$schema,$type/text())
 return
 if  (empty($values)) then 
 if ($type/text()="xs:string") then <values><value>default</value></values>
 else if ($type/text()="xs:decimal") then <values><value>0</value></values>
 else if ($type/text()="xs:date") then <values><value>2000-01-01</value></values>
 else if ($type/text()="xs:negativeInteger") then <values><value>-1</value></values>
 else if ($type/text()="xs:positiveInteger") then <values><value>1</value></values>
 else <values><value>0</value></values>
 else <values>{$values}</values>
};

(: SIMPLETYPESCHEMA :)

declare function tc:simpleTypeSchema($schema)
{
  $schema/xs:simpleType
};

(: NAMESIMPLETYPE :)

declare function tc:nameSimpleType($simpletype)
{
  $simpletype/@name
};

(: BASESIMPLETYPE :)

declare function tc:baseSimpleType($simpletype)
{
  $simpletype/xs:restriction/@base
};

(: VALUESSIMPLETYPE :)

declare function tc:valuesSimpleType($simpletype)
{
  $simpletype/xs:restriction/xs:enumeration/@value
};

(: ELEMENTSCHEMA :)

declare function tc:elementSchema($schema)
{
  $schema/xs:element
};

(: NAMEELEMENT :)

declare function tc:nameElement($element)
{
  $element/@name
};

(: TYPEELEMENT :)

declare function tc:typeElement($element)
{
  $element/@type
};

(: MINOCCURSELEMENT :)

declare function tc:minOccursElement($element)
{
  if ($element/@minOccurs) then $element/@minOccurs else 1 
};


(: DECREASEMAX :)

declare function tc:decreaseMax($element,$k)
{
if ($element/@maxOccurs="unbounded") then "unbounded"
else $element/@maxOccurs - $k
};

(: MAXOCCURSELEMENT :)

declare function tc:maxOccursElement($element)
{
  
  if ($element/@maxOccurs="unbounded") then -1
  else $element/@maxOccurs
  
};

(: COMPLEXTYPEELEMENT :)

declare function tc:complexTypeElement($element)
{
 $element/xs:complexType
};

(: SEQUENCECOMPLEXTYPE :)

declare function tc:sequenceComplexType($complexType)
{
  $complexType/xs:sequence
};

(: ATTRIBUTECOMPLEXTYPE :)

declare function tc:attributeComplexType($complexType)
{
  $complexType/xs:attribute
};

(: MINOCCURSSEQUENCE :)

declare function tc:minOccursSequence($sequence)
{
  if ($sequence/@minOccurs) then $sequence/@minOccurs else 1
};

(: MAXOCCURSSEQUENCE :)

declare function tc:maxOccursSequence($sequence)
{
  
  
  if ($sequence/@maxOccurs="unbounded") then -1 else $sequence/@maxOccurs
  
};

(: MINOCCURSSEQUENCE :)

declare function tc:minOccursAttribute($attribute)
{
  if ($attribute/@minOccurs) then $attribute/@minOccurs else 1
};

(: MAXOCCURSSEQUENCE :)

declare function tc:maxOccursAttribute($attribute)
{
  
  
  if ($attribute/@maxOccurs="unbounded") then -1 else $attribute/@maxOccurs
  
};

(: ELEMENTSSEQUENCE :)

declare function tc:elementsSequence($sequence)
{
  $sequence/xs:element
};

(: NAMEATTRIBUTE :)

declare function tc:nameAttribute($attribute)
{
  $attribute/@name
};

(: TYPEATTRIBUTE :)

declare function tc:typeAttribute($attribute)
{
  $attribute/@type
};

(: USEATTRIBUTE :)

declare function tc:useAttribute($attribute)
{
  $attribute/@use
};


 

(: SKELETOM :)

declare function tc:skeleton($elements,$root,$namespaces)
{
     
   (for $element in $elements[not(@ref)] 
    
   
   for $i in 1 to tc:minOccursElement($element)  
   return
   if ($element/xs:complexType) then 
     element {tc:nameElement($element)}{
         
         if ($root) then $namespaces else (),
         let $complexType := tc:complexTypeElement($element)
         let $attributes := tc:attributeComplexType($complexType)
         return
         (
         for $attribute in $attributes[not(@use="optional") (: MODIFIED ATL :) 
                       and not(@class="yes")] 
         return element {tc:nameAttribute($attribute)}
         {
          
         attribute {"type"}{tc:typeAttribute($attribute)},
         attribute {"attribute"}{"yes"}}
         )
         (: MODIFIED ATL :)
         union
         (
         for $attribute in $attributes[@class="yes" and @minOccurs>=1]  
         return element {tc:nameAttribute($attribute)}
         {
         attribute {"type"}{tc:typeAttribute($attribute)},
         attribute {"attribute"}{"yes"},
         $attribute/@class,
         tc:minOccursAttribute($attribute),
         tc:maxOccursAttribute($attribute)}  
         )
         
          
         union
         (
         let $sequence := tc:sequenceComplexType($complexType)
         for $j in 1 to tc:minOccursSequence($sequence) 
         return tc:skeleton(tc:elementsSequence($sequence),false(),$namespaces) 
         )
         
        
       }
   else  element{tc:nameElement($element)}{tc:typeElement($element), attribute {"attribute"}{"no"}} 
 )
   

};

 

(: POPULATE :)

declare function tc:populate($structure,$types,$values)
{
for $t in  tc:populate_set($structure,$types,$values) 
return
let $tb :=
(
copy $ta := $t
modify (delete node $ta//*[@attribute="yes"])
return $ta
)
return  


(: MODIFIED ATL :)


copy $tc := $tb
modify (
for $parent in $tc//*
let $node := $parent/*[@attribute="class"]
for $name in distinct-values(for $x in $node return name($x))
let $st := string-join($node[name(.)=$name]/text(),' ')

return
  
  insert node (attribute {$name} {$st}) into $parent, 
  
for $parent in $tc//*
 
return
     
   delete node $parent//*[@attribute="class"]

  )
return 

$tc

};

(: POPULATESET :)

declare function tc:populate_set($trees,$types,$values)
{
  if (empty($types)) then $trees
  else let $strees := (
       for $value in head($values)/value
       return
       tc:populate_trees($trees,head($types)/text(),$value/text()))
       return tc:populate_set($strees,tail($types),tail($values))
};

(: POPULATETREES :)

declare function tc:populate_trees($trees,$type,$value)
{
   for $tree in $trees return tc:populate_tree($tree,$type,$value)
   
};

(: POPULATETREE :)

declare function tc:populate_tree($tree,$type,$value)
{
(: Attributes in the root :)
if ($tree/*[tc:path-to-node-with-pos(.)=$type]/@attribute="yes")
then 
                element {name($tree)} 
                {attribute {name($tree/*[tc:path-to-node-with-pos(.)=$type])} {$value}, 
                $tree/@*, $tree/* }
else

let $pos := $tree//*[tc:path-to-node-with-pos(.)=$type]
return
        if ($pos/@attribute="no")
        then
        copy $new := $tree
        modify(
        replace node 
        $new//*[tc:path-to-node-with-pos(.)=$type] with element {name($pos)} {$value}
        )
        return $new
        else
        (: MODIFIED ATL :)
        
        if ($pos/@minOccurs) then
        copy $new := $tree
        modify(
        replace node 
        $new//*[tc:path-to-node-with-pos(.)=$type] with 
        element {name($pos)} {attribute {"attribute"} {"class"}, $value}
        )
        return $new
        (::)
        
        else
        copy $new := $tree
          modify(
          let $parent := $new//*[tc:path-to-node-with-pos(.)=$type]/..
          return
          replace node $parent  with element {name($parent)} 
          {attribute {name($pos)} {$value}, $parent/@*, $parent/* }
          )
          return $new


};

 
 
declare function tc:unfold($schema)
{
let $ies := 
(
for $i in 1 to count(tc:refs($schema))
where 
tc:minOccursElement(tc:refs($schema)[$i]/parent::*/parent::*/parent::*)>=1 
(:or empty(tc:refs($schema)[$i]/parent::*/parent::*/parent::*):)

return $i
)
return
copy $new := $schema
modify
(
for $k in $ies
return
let $pos := $new/xs:schema/xs:complexType[@name=tc:refs($new)[$k]/@ref] 
return
 replace node tc:refs($new)[$k] with element {"xs:element"} {
  $pos/@name,attribute {"minOccurs"} {tc:minOccursElement(tc:refs($new)[$k])}, 
  attribute {"maxOccurs"} {tc:maxOccursElement(tc:refs($new)[$k]) },
  <xs:complexType>{$pos/*}</xs:complexType>}
)
return $new

};


declare function tc:increase_unfold($sch)
{
  tc:increase_attribute(tc:unfold($sch)) union tc:increase_element(tc:unfold($sch))
};



(: INCREASE :)


declare function tc:increase($sch)
{
 let $schs :=
 tc:increase_attribute($sch) union tc:increase_element($sch) union tc:increase_sequence($sch)
 return 
 (if (empty($schs)) then tc:increase_unfold($sch) else 
 for $s in $schs return tc:unfold($s))
 
};
 
 

 
 

 
 

(: INCREASE ELEMENT :)

declare function tc:increase_element($schema)
{

let $ies :=(
for $i in 1 to count(tc:elements($schema))
let $min := tc:minOccursElement(tc:elements($schema)[$i]) 
let $max := tc:maxOccursElement(tc:elements($schema)[$i])
where tc:lessOccurs($min,$max) and (tc:elements($schema)[$i])[not(@ref)]
return $i)
for $k in $ies
return
copy $new := $schema
modify( 
 insert node element {"xs:element"} {
  tc:elements($new)[$k]/@name,attribute {"minOccurs"} 
  {"1"}, attribute {"maxOccurs"} 
  {"1"},
  tc:elements($new)[$k]/@*[not(name(.)="name") and not(name(.)="minOccurs") 
  and not(name(.)="maxOccurs") ],
  tc:elements($new)[$k]/*} into 
   tc:elements($new)[$k]/..,  
 replace value of node tc:elements($new)[$k]/@maxOccurs with 
             tc:decreaseMax(tc:elements($new)[$k],1)
)
return $new 

};



(: INCREASE_ATTRIBUTE :)

declare function tc:increase_attribute($schema)
{
(
let $ies :=(
for $i in 1 to count(tc:attributes($schema))
where tc:attributes($schema)[$i]/@use="optional"
return $i)
for $k in $ies 
return
copy $new := $schema
modify(
 let $x := tc:attributes($new)[$k]/@use
 return
 replace value of node $x with "required"
)
return $new 
)
(: MODIFIED ATL :)
union 

(
let $ies :=(
for $i in 1 to count(tc:attributes($schema))
let $min := tc:minOccursAttribute(tc:attributes($schema)[$i])
let $max := tc:maxOccursAttribute(tc:attributes($schema)[$i])
where tc:lessOccurs($min,$max) and tc:attributes($schema)[$i]/@class="yes"
return $i)
for $k in $ies 
return
copy $new := $schema
modify( 
 insert node element {"xs:attribute"} {
  tc:attributes($new)[$k]/@name,attribute {"minOccurs"} 
  {"1"}, attribute {"maxOccurs"} 
  {"1"},
  tc:attributes($new)[$k]/@*[not(name(.)="name") and not(name(.)="minOccurs") 
  and not(name(.)="maxOccurs") ],
  tc:attributes($new)[$k]/*} into 
   tc:attributes($new)[$k]/..,  
 replace value of node tc:attributes($new)[$k]/@maxOccurs with 
             tc:decreaseMax(tc:attributes($new)[$k],1)
)
return $new) 
  
};

(: INCREASE_SEQUENCE :)

declare function tc:increase_sequence($schema)
{
let $ies :=(
for $i in 1 to count(tc:sequences($schema))
let $min := tc:minOccursSequence(tc:sequences($schema)[$i])
let $max := tc:maxOccursSequence(tc:sequences($schema)[$i])
where tc:lessOccurs($min,$max)
return $i)
for $k in $ies 
return
copy $new := $schema
modify( 
 insert node element {"xs:sequence"} {
  tc:sequences($new)[$k]/@name,attribute {"minOccurs"} 
  {"1"}, attribute {"maxOccurs"} 
  {"1"},
  tc:sequences($new)[$k]/@*[not(name(.)="name") and not(name(.)="minOccurs") 
  and not(name(.)="maxOccurs") ],
  tc:sequences($new)[$k]/*} into 
   tc:sequences($new)[$k]/..,  
 replace value of node tc:sequences($new)[$k]/@maxOccurs with 
             tc:decreaseMax(tc:sequences($new)[$k],1)
)
return $new
};


 
(: TEST_CASES :)

declare function tc:test_cases($schema,$i,$namespaces)
{

for $sch in tc:generate_schemas(tc:unfold($schema),$i)
return
if (some $i in 1 to count(tc:refs($sch))
satisfies
tc:minOccursElement(tc:refs($sch)[$i]/parent::*/parent::*/parent::*)>=1)
then ()
else 
let $structure := tc:skeleton($sch/xs:schema/xs:element,true(),$namespaces)
let $examples := tc:populate($structure,tc:getTypes($structure),tc:getVal($structure,$sch/xs:schema,tc:getTypesName($structure)))
return $examples
}; 




(: GENERATE_SCHEMAS :)

declare function tc:generate_schemas($schema,$i)
{
if ($i=0) then $schema
          else let $count := count($schema)
          let $new := (for $k in 1 to $count return tc:increase($schema[$k]))
          return $schema union tc:generate_schemas($new,$i - 1)               
};


