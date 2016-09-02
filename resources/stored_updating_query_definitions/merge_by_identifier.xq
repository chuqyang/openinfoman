import module namespace csd_lsc = "https://github.com/openhie/openinfoman/csd_lsc";
import module namespace csd_dm = "https://github.com/openhie/openinfoman/csd_dm";
import module namespace csd_webconf =  "https://github.com/openhie/openinfoman/csd_webconf";
import module namespace functx = "http://www.functx.com";
declare default element  namespace   "urn:ihe:iti:csd:2013";
declare namespace csd  =  "urn:ihe:iti:csd:2013";

declare variable $careServicesRequest as item() external;



let $dest_doc := /.
let $dest := $careServicesRequest/@resource
for $doc in $careServicesRequest/documents/document
  let $insertNew := 
    if (exists($doc/insertNew/@value))
    then ($doc/insertNew/@value = 1)
    else true()

  let $name := string($doc/@resource)
  let $src_doc :=
    if (not (functx:all-whitespace($name)))
    then if (not ($name = $dest)) then csd_dm:open_document( $name) else ()
    else $doc
  return 
    (
    let $src_dir := $src_doc/csd:CSD/csd:organizationDirectory
    let $dest_dir := $dest_doc/csd:CSD/csd:organizationDirectory
    return
      for $e in $src_dir/csd:organization 
      let $existing := $dest_dir/csd:organization[@entityID = $e/@entityID]
      return 
	if (exists($existing)) 
        then
          let $new := 
	    <csd:organization entityID="{$e/@entityID}">
	      {$existing/csd:otherID}  
	      {$e/*}
	    </csd:organization>
	  return replace node $existing with $new 
        else if ($insertNew) then insert node $e into $dest_dir else ()
    ,
    let $src_dir := $src_doc/csd:CSD/csd:providerDirectory
    let $dest_dir := $dest_doc/csd:CSD/csd:providerDirectory
    return
      for $e in $src_dir/csd:provider 
      let $existing := $dest_dir/csd:provider[@entityID = $e/@entityID]
      return 
	if (exists($existing)) 
	then
          let $new := 
	    <csd:provider entityID="{$e/@entityID}">
	      {$existing/csd:otherID}  
	      {$e/*}
	    </csd:provider>
	  return replace node $existing with $new 
        else if ($insertNew) then insert node $e into $dest_dir else ()
    ,
    let $src_dir := $src_doc/csd:CSD/csd:serviceDirectory
    let $dest_dir := $dest_doc/csd:CSD/csd:serviceDirectory
    return
      for $e in $src_dir/csd:service 
      let $existing := $dest_dir/csd:service[@entityID = $e/@entityID]
      return 
	if (exists($existing)) 
	then
          let $new := 
	    <csd:service entityID="{$e/@entityID}">
	      {$existing/csd:otherID}  
	      {$e/*}
	    </csd:service>
	  return replace node $existing with $new 
        else if ($insertNew) then insert node $e into $dest_dir else ()
    ,
    let $src_dir := $src_doc/csd:CSD/csd:facilityDirectory
    let $dest_dir := $dest_doc/csd:CSD/csd:facilityDirectory
    return
      for $e in $src_dir/csd:facility 
      let $existing := $dest_dir/csd:facility[@entityID = $e/@entityID]
      return 
	if (exists($existing)) 
	then
          let $new := 
	    <csd:facility entityID="{$e/@entityID}">
	      {$existing/csd:otherID}  
	      {$e/*}
	    </csd:facility>
	  return replace node $existing with $new 
        else if ($insertNew) then insert node $e into $dest_dir else ()

    )




