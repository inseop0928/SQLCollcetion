--전화번호
SELECT REGEXP_REPLACE('tel_no', '(02|.{3})(.+)(.{4})', '\1-\2-\3') tel_no2 FROM DUAL; 

--사업자번호
SELECT REGEXP_REPLACE('BIZ_NO', '(.{3})(.{2})(.{5})', '\1-\2-\3') BIZ_NO FROM DUAL;
