module namespace e2x = "ecore2xmlschema";

declare namespace xmi = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";

declare function e2x:distinct-deep
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(e2x:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;
 
 declare function e2x:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;
 

declare function e2x:st($type,$base)
{
 <xs:simpleType xmlns:xs="http://www.w3.org/2001/XMLSchema" name="{$type}">
  <xs:restriction base="{$base}">
    <xs:enumeration value="Default"/>
  </xs:restriction>
</xs:simpleType> 
};

declare function e2x:path($doc,$path)
{
 
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EString")
then <eClassifiers xsi:type="ecore:EDataType" name="String"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EBoolean")
then <eClassifiers xsi:type="ecore:EDataType" name="Boolean"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EByte")
then <eClassifiers xsi:type="ecore:EDataType" name="Byte"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EChar")
then <eClassifiers xsi:type="ecore:EDataType" name="Char"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EDouble")
then <eClassifiers xsi:type="ecore:EDataType" name="Double"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EFloat")
then <eClassifiers xsi:type="ecore:EDataType" name="Float"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//EInt")
then <eClassifiers xsi:type="ecore:EDataType" name="Integer"/>  
else
if ($path="ecore:EDataType http://www.eclipse.org/emf/2002/Ecore#//ELong")
then <eClassifiers xsi:type="ecore:EDataType" name="Long"/>  
else

if (substring-after($path,"#//")="")
then 

let $type := tokenize($path,'/')
let $content := $doc//ecore:EPackage[xs:integer($type[2]) + 1]/eClassifiers[@name=$type[3]]
return $content

else $doc//eClassifiers[@name=substring-after($path,"#//")]

};

declare function e2x:bound($bound)
{
  if (empty($bound)) then 1
  else
  if ($bound=-1) then "unbounded"
  else $bound
};

declare function e2x:required($bound)
{
  if (empty($bound)) then "required"
  else
  if ($bound= 1) then "required"
  else "optional"
};

declare function e2x:st($doc)
{
(:  
 <xs:simpleType name="xmiversionType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="2.0"/>
  </xs:restriction>
</xs:simpleType> 
union
<xs:simpleType name="xmlnsxmiType">
  <xs:restriction base="xs:string">
    <xs:enumeration value="http://www.omg.org/XMI"/>
  </xs:restriction>
</xs:simpleType> 

union
:)
(
for $package in 
$doc//ecore:EPackage[not(@name="PrimitiveTypes")]
return 
for $classifier in $package/eClassifiers 
for $features in $classifier/eStructuralFeatures[not(@xsi:type="ecore:EReference")]
return e2x:st(concat($features/@name,"Type"),concat("xs:",lower-case(e2x:path($doc,$features/@eType)/@name)))
)
};

declare function e2x:ct($doc,$classifier)
{
  if ($classifier/@eSuperTypes) then
                
                let $cts_st := e2x:ct($doc,e2x:path($doc,$classifier/@eSuperTypes))
                let $cts_ref := e2x:ct_ref($doc,$classifier)
                let $els := $cts_st[name(.)="xs:sequence"] union $cts_ref[name(.)="xs:sequence"]
                let $atts := $cts_st[name(.)="xs:attribute"] union $cts_ref[name(.)="xs:attribute"]
                return 
                if (empty($els)) then $atts 
                else <xs:sequence>{$els/*}</xs:sequence> union $atts      
                else e2x:ct_ref($doc,$classifier)   
};


declare function e2x:ct_ref($doc,$classifier)
{
let $els := e2x:ct_ref_element($doc,$classifier)
return
(if (empty($els[name(.)="xs:element"])) then ()
else 
<xs:sequence>{$els[name(.)="xs:element"]}</xs:sequence>
)
union
$els[name(.)="xs:attribute"]
union
e2x:ct_ref_attribute($doc,$classifier)

};

 

 

declare function e2x:ct_ref_element($doc,$classifier)
{
for $item in $classifier/eStructuralFeatures
where $item/@xsi:type="ecore:EReference" 
and (not(e2x:contains($doc,$classifier,e2x:path($doc,$item/@eType)))
or not ($item/@eOpposite)) (: OPPOSITE CAN BE NOT ANNOTATED :)
return 
if ($item/@containment="true") then
<xs:element ref="{$item/@name}" minOccurs="{e2x:bound($item/@lowerBound)}" maxOccurs= "{e2x:bound($item/@upperBound)}"/>
else
<xs:attribute name="{$item/@name}" type="{e2x:path($doc,$item/@eType)/@name}" class="yes" 
minOccurs="{e2x:bound($item/@lowerBound)}" maxOccurs="{e2x:bound($item/@upperBound)}" />
};

declare function e2x:ct_ref_attribute($doc,$classifier)
{

for $item in $classifier/eStructuralFeatures
where $item/@xsi:type="ecore:EAttribute"
return 
<xs:attribute name="{$item/@name}" type="{concat($item/@name,"Type")}" use="{e2x:required($item/@lowerBound)}"/>

};



declare function e2x:ref($doc)
{
for $ref in $doc//eStructuralFeatures[@xsi:type="ecore:EReference"]  
let $content := e2x:path($doc,$ref/@eType) 
where $ref/@containment="true"
return
let $cts := e2x:ct($doc,$content)
return
if (empty($cts)) then ()
else
<xs:complexType name="{$ref/@name}">
{$cts} 
</xs:complexType>
};


declare function e2x:elements_classifier($doc)
{
for $package in 
$doc//ecore:EPackage[not(@name="PrimitiveTypes")]
return 
for $classifier in $package/eClassifiers
where not(e2x:contained($doc,$classifier)) and not($classifier/@abstract="true")
return 
<xs:element name="{$classifier/@name}" type="{concat($classifier/@name,"Type")}" minOccurs="0" maxOccurs= "unbounded" >
{
let $cts := e2x:ct($doc,$classifier)
return 
if (empty($cts)) then ()
else
<xs:complexType>
{$cts}
</xs:complexType>
}
</xs:element>  
};

declare function e2x:main($doc)
{
let $els := e2x:elements_classifier($doc)
return
<xs:element name="XMI">
<xs:complexType>
{
if (empty($els)) then ()
else
<xs:sequence>
{
$els
}
</xs:sequence>
}

</xs:complexType>
</xs:element>
};

(:
<xs:attribute name="xmiversion" type="xmiversionType" use="required"/>
<xs:attribute name="xmlnsxmi" type="xmlnsxmiType" use="required"/>:)


declare function e2x:contained($doc,$classifier)
{
  some $s in $classifier/eStructuralFeatures
  satisfies $s/@xsi:type="ecore:EReference" and 
  (some $c in e2x:path($doc,$s/@eOpposite)/eStructuralFeatures
  satisfies e2x:path($doc,$c/@eOpposite)=$classifier and $c/@containment="true")
};

declare function e2x:contains($doc,$classifier1,$classifier2)
{
   
  some $s in $classifier1/eStructuralFeatures
  satisfies $s/@xsi:type="ecore:EReference" and 
  
    (some $c in e2x:path($doc,$s/@eOpposite)/eStructuralFeatures
  satisfies e2x:path($doc,$c/@eOpposite)=$classifier2 and $c/@containment="true")
};


declare function e2x:ecore2schema($doc){
<xs:schema>
{
(e2x:distinct-deep(e2x:st($doc)),e2x:ref($doc),e2x:main($doc))
}
</xs:schema>
};






 