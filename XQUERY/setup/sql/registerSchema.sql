
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
declare
  V_XML_SCHEMA xmlType := xdburitype('%DEMOCOMMON%/xsd/purchaseOrder.xsd').getXML();
begin

  DBMS_XMLSCHEMA.registerSchema
  (
    SCHEMAURL        => '%SCHEMAURL%', 
    SCHEMADOC        => V_XML_SCHEMA,
    LOCAL            => TRUE,
    GENBEAN          => FALSE,
    GENTYPES         => FALSE,
    GENTABLES        => FALSE,
    ENABLEHIERARCHY  => DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE,
    OPTIONS          => DBMS_XMLSCHEMA.REGISTER_BINARYXML
  );
end;
/   
create table %TABLE1%
          of XMLType
             XMLTYPE STORE AS SECUREFILE BINARY XML
             XMLSCHEMA "%SCHEMAURL%" Element "PurchaseOrder"
/
insert /*+ APPEND */ into %TABLE1%
select OBJECT_VALUE
  from %DATA_STAGING_TABLE%
/
commit
/
select count(*)
  from %TABLE1%
/
create index PURCHASEORDER_IDX
          on %TABLE1% (OBJECT_VALUE)
             indexType is xdb.XMLINDEX
/
call DBMS_STATS.GATHER_SCHEMA_STATS(USER)
/
--
