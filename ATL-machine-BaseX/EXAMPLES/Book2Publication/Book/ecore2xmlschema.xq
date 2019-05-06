declare namespace xmi = "http://www.omg.org/XMI";
declare namespace ecore = "http://www.eclipse.org/emf/2002/Ecore";

 

declare function local:st($type,$base)
{
 <xs:simpleType xmlns:xs="http://www.w3.org/2001/XMLSchema" name="{$type}">
  <xs:restriction base="{$base}">
    <xs:enumeration value="Default"/>
  </xs:restriction>
</xs:simpleType> 
};

declare function local:path($doc,$path)
{
let $type := tokenize($path,'/')
let $content := $doc//xmi:XMI/ecore:EPackage[xs:integer($type[2]) + 1]/eClassifiers[@name=$type[3]]
return $content
};

declare function local:bound($bound)
{
  if (empty($bound)) then 1
  else
  if ($bound=-1) then "unbounded"
  else $bound
};

declare function local:required($bound)
{
  if (empty($bound)) then "required"
  else
  if ($bound= 1) then "required"
  else "optional"
};

declare function local:st($doc)
{
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
(
for $package in 
$doc/xmi:XMI/ecore:EPackage[not(@name="PrimitiveTypes")]
return 
for $classifier in $package/eClassifiers 
for $features in $classifier/eStructuralFeatures[not(@xsi:type="ecore:EReference")]
return local:st(concat($features/@name,"Type"),concat("xs:",lower-case(local:path($doc,$features/@eType)/@name)))
)
};

declare function local:ct_ref($classifier)
{
<xs:sequence>
{
for $item in $classifier/eStructuralFeatures
where $item/@xsi:type="ecore:EReference" (:and $item/@containment="true":)
return 
<xs:element ref="{$item/@name}" minOccurs="{local:bound($item/@lowerBound)}" maxOccurs= "{local:bound($item/@upperBound)}"/>
}
</xs:sequence>
union
(
for $item in $classifier/eStructuralFeatures
where $item/@xsi:type="ecore:EAttribute"
return 
<xs:attribute name="{$item/@name}" type="{concat($item/@name,"Type")}" use="{local:required($item/@lowerBound)}"/>
)
};

declare function local:ct_noref($classifier)
{
(
for $item in $classifier/eStructuralFeatures
where $item/@xsi:type="ecore:EAttribute"
return 
<xs:attribute name="{$item/@name}" type="{concat($item/@name,"Type")}" use="{local:required($item/@lowerBound)}"/>
)
};


declare function local:ref($doc)
{
for $ref in $doc//eStructuralFeatures[@xsi:type="ecore:EReference"]
let $content := local:path($doc,$ref/@eType)
return
<xs:complexType name="{$ref/@name}">
{local:ct_ref($content)} 
</xs:complexType>
};

(: noref :)

declare function local:main($doc)
{
<xs:element name="XMI">
<xs:complexType>
<xs:sequence>
{
for $package in 
$doc/xmi:XMI/ecore:EPackage[not(@name="PrimitiveTypes")]
return 
for $classifier in $package/eClassifiers
return 
<xs:element name="{$classifier/@name}" type="{concat($classifier/@name,"Type")}" minOccurs="0" maxOccurs= "unbounded" >
<xs:complexType>
{local:ct_ref($classifier)}
</xs:complexType>
</xs:element>
}
</xs:sequence>
<xs:attribute name="version" type="xmiversionType" use="required"/>
<xs:attribute name="xmi" type="xmlnsxmiType" use="required"/>
</xs:complexType>
</xs:element>
};


declare function local:ecore2schema($doc){
<xs:schema>
{
(local:st($doc),local:ref($doc),local:main($doc))
}
</xs:schema>
};

local:ecore2schema(doc("/Users/jesusmanuelalmendrosjimenez/Dropbox/research/test_cases/TESTING ATL/EXAMPLES/Book2Publication/Book/Book.ecore"))