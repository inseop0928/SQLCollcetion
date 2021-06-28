--session 확인
SELECT SQL.SQL_ID, SQL.VERSION_COUNT, SQL.SQL_TEXT
  FROM V$SQLAREA SQL, V$SESSION SES
  WHERE SES.STATUS='INACTIVE'
    AND SES.LAST_CALL_ET > 100 -- SESSION 이 INACTIVE 된지 100초 이상 된 것
    AND SES.PREV_SQL_ID = SQL.SQL_ID
    AND LOGON_TIME > SYSDATE -1 -- SESSION이 생성된지 하루 이상 된 것