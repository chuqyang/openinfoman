module namespace page = 'http://basex.org/modules/web-page';

import module namespace csr_proc = "https://github.com/his-interop/openinfoman/csr_proc";
import module namespace csd_dm = "https://github.com/his-interop/openinfoman/csd_dm";
import module namespace csd_webconf =  "https://github.com/his-interop/openinfoman/csd_webconf";


declare   namespace   csd = "urn:ihe:iti:csd:2013";
declare default element  namespace   "urn:ihe:iti:csd:2013";

declare variable $page:csd_docs := csd_dm:registered_documents($csd_webconf:db);

declare
  %rest:path("/CSD/csr/{$name}/careServicesRequest")
  %rest:consumes("application/xml", "text/xml", "multipart/form-data")  
  %rest:POST("{$careServicesRequest}")
  function page:csr($name,$careServicesRequest) 
{ 
if (csd_dm:document_source_exists($csd_webconf:db,$name)) then 
 csr_proc:process_CSR($csd_webconf:db,$careServicesRequest/careServicesRequest,$name,$csd_webconf:baseurl)   
else
  (:need appropriate error handling:)
  ()

};


declare updating
  %rest:path("/CSD/csr/{$name}/careServicesRequest/update")
  %rest:consumes("application/xml", "text/xml", "multipart/form-data")  
  %rest:POST("{$careServicesRequest}")
  function page:csr_updating($name,$careServicesRequest) 
{ 
if (csd_dm:document_source_exists($csd_webconf:db,$name)) then 
 csr_proc:process_updating_CSR($csd_webconf:db,$careServicesRequest/careServicesRequest,$name,$csd_webconf:baseurl)   
else
  (:need appropriate error handling:)
  ()

};


declare
  %rest:path("/CSD/csr/{$name}/adhoc")
  %rest:consumes("application/xml", "text/xml", "multipart/form-data")
  %rest:POST
  %rest:form-param("adhoc","{$adhoc}")
  %rest:form-param("content", "{$content}","application/xml")
function page:adhoc($name,$adhoc,$content) {    
if (csd_dm:document_source_exists($csd_webconf:db,$name)) then 
let  $adhoc_doc := csr_proc:create_adhoc_doc(string($adhoc),$content)
  return  csr_proc:process_CSR($csd_webconf:db, $adhoc_doc,$name,$csd_webconf:baseurl)
else
  (:need appropriate error handling:)
  ()

};



declare
  %rest:path("/CSD/csr")
  %rest:GET
  %output:method("xhtml")
  function page:csr_list() 
{ 
let $response := page:endpoints()
return page:wrapper($response)
};


declare function page:wrapper($requests) {
 <html>
  <head>

    <link href="{$csd_webconf:baseurl}static/bootstrap/css/bootstrap.css" rel="stylesheet"/>
    <link href="{$csd_webconf:baseurl}static/bootstrap/css/bootstrap-theme.css" rel="stylesheet"/>
    

    <script src="https://code.jquery.com/jquery.js"/>
    <script src="{$csd_webconf:baseurl}static/bootstrap/js/bootstrap.min.js"/>

    <script src="https://code.jquery.com/jquery.js"/>
    <script src="{$csd_webconf:baseurl}static/bootstrap/js/bootstrap.min.js"/>

  </head>
  <body>  
    <div class="navbar navbar-inverse navbar-static-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="{$csd_webconf:baseurl}CSD">OpenInfoMan</a>
        </div>
      </div>
    </div>
    <div class='container'>
      {$requests}
    </div>
  </body>
 </html>
};


declare function page:endpoints() {
<span>
    <h2>Care Services Request - Endpoints</h2>
    <ul>
      {
	for $name in $page:csd_docs
	return 
	<li>
	  Submit Care Services Request for {$name} at:
	  <pre>{$csd_webconf:baseurl}CSD/csr/{$name}/careServicesRequest</pre> 
	  <br/>
	  Submit ad-hoc query:
	  <form method='post' action="/CSD/csr/{$name}/adhoc"  enctype="multipart/form-data">
	    <label for="adhoc">Ad-Hoc Query</label><textarea  rows="10" cols="80" name="adhoc" >{$page:sample}</textarea>
	    <br/>
	    <label for="content">Content Type</label><input    cols="80" name="content" value="text/html"/>
	    <br/>
	    <input type="submit" value="submit"/>
	  </form>
	</li>
      }
    </ul>
  </span>
};






declare variable $page:sample := 
"<html xmlns:csd='urn:ihe:iti:csd:2013'>
<body>
<ul>
  <li>You have {count(/csd:CSD/csd:providerDirectory/*)} providers.</li>
  <li>You have {count(/csd:CSD/csd:facilityDirectory/*)} facilities.</li>
<li>You have {count(/csd:CSD/csd:organizationDirectory/*)} organizations.</li>
<li>You have {count(/csd:CSD/csd:serviceDirectory/*)} services.</li>
</ul>
</body>
</html>";




