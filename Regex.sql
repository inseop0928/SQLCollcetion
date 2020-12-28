--전화번호
SELECT REGEXP_REPLACE('tel_no', '(02|.{3})(.+)(.{4})', '\1-\2-\3') tel_no2 FROM DUAL; 
