load data
append
into table XDBPM.SQLLDR_STAGING_VIEW
(
  RESOURCE_PATH                CHAR(100),
  CREATE_FOLDER                CHAR(1),
  FILLER            FILLER     CHAR(9),
  DUPLICATE_POLICY             CHAR(10),
  SOURCE_FILE       FILLER     CHAR(1024),
  CONTENT                      lobfile(SOURCE_FILE) TERMINATED BY EOF,
  RESULT            EXPRESSION "XDBPM.XDBPM_SQLLDR_INTERFACE.UPLOAD_RESOURCE(:RESOURCE_PATH,:CREATE_FOLDER,:CONTENT,:DUPLICATE_POLICY)"
)

