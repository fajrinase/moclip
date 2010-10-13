<%@ Language=JScript %>
<html>
 <head>
   <title>Test Upload</title>
 </head>
 <body>
   <center>
     <div align='left' style='width:400px;padding:10px;border:2px solid gray'>
       <div>
         <div>
           <%
             var  info = simpleUpload();
            
             if( null != info )
               {
                 type      = contentTypeFromHeader( info[2] );
                 filename  = filenameFromHeader( info[2] );

                 Response.write( "<div style='background:lightgray;border:1px dashed black;margin:0 0 10px;padding:3px'>" );
                 Response.write( "<span style='font-weight:bold'>Upload Report</span>" );
                 Response.write( "<pre style='font-family:monospace'>" );
                 Response.write( "length   = " + info[1] + "\n" );
                 Response.write( "type     = " + type + "\n" );
                 Response.write( "filename = " + filename );
                 Response.write( "</pre>" );
                 Response.write( "</div>" );
                
                 var  stream      = Server.CreateObject( "ADODB.Stream" );
                 stream.open();
                 stream.type      = 1;
                 stream.position  = 0;
                
                 stream.write( info[0] );
                 stream.saveToFile( Server.MapPath( "./uploads/" + filename ), 2 );
                 stream.close();

                 if( null != filename )
                   {
                     Response.write( "<div>" );
                     Response.write( "<img src='./uploads/" + filename + "' />" );
                     Response.write( "</div>" );
                   }
               }
           %>
         </div>
       </div>
    
       <div style='clear:both;margin-top:10px'>
         <form style='padding:0;margin:0' method='POST' enctype='multipart/form-data'>
           <div>
             <input type='file' name='source1' />
			  <input type='file' name='source2' />
           </div>
           <div style='margin-top:10px'>
             <input type='submit' value='Upload' />
           </div>
         </form>
       </div>
     </div>
   </center>
 </body>
</html>
<%
function simpleUpload()
{
 if( 0 == Request.totalBytes )
   return null;

 var  blob       = Request.binaryRead( Request.totalBytes );
 var  recordSet  = Server.CreateObject( "ADODB.RecordSet" );

 //' 201 = adLongVarChar
 recordSet.fields.append( "raw", 201, Request.totalBytes );
 recordSet.open();
 recordSet.addNew();
 recordSet.fields(0).appendChunk( blob );

 var  str  = "" + recordSet.fields(0);
 var  eol      = "\r\n";
 var  blank    = "\r\n\r\n";
 var  marker  = str.substr( 0, str.indexOf( eol ) + eol.length );

 var  start    = str.indexOf( blank, marker.length );
 start += blank.length;
 //' the last marker has a "--" at the end of it
 var  end      = str.length - (marker.length + 2); 
 var  length  = end - start;

 var  header  = str.slice( marker.length, start - blank.length ).split( eol );

 var  data  = Server.CreateObject("ADODB.Stream");
 data.open();
 data.type      = 1;
 data.position  = 0;
 data.write( blob );
 data.position = start;

 return new Array( data.read( length ), end-start, header );
}

function findValueForKeyFromHeader( header, key )
{
 key = key.toLowerCase();
 var  i;
 for( i=0; i<header.length; ++i )
   {
     line = header[i].split( ": " );  //' again, weak.
     if( key == line[0].toLowerCase() )
       return line[1];
   }
 return null;
}

function contentTypeFromHeader( header )
{
 return findValueForKeyFromHeader( header, "Content-Type" );
}

function filenameFromHeader( header )
{
 var  params = findValueForKeyFromHeader( header, "Content-Disposition" );
 if( null == params )
   return null;

 var  kvs = params.split( "; " );  //' I know this is weak
 var  i;
 for( i=0; i<kvs.length; ++i )
   {
     kv = kvs[i].split( "=" );
     if( "filename" == kv[0].toLowerCase() )
       {
         var  filename  = kv[1].substr( 1, kv[1].length-2 );  //' remove the quotes
         var  slash      = filename.lastIndexOf( "\\" );  //' only IE eh.
         if( -1 != slash )
           filename = filename.substring( slash + 1, filename.length );
        
         return filename;
       }
   }
 return null;
}
%>