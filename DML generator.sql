--merge select ����
SELECT 'SELECT #{'|| LOWER(COLUMN_NAME) || '} AS '|| COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = 'TABLE_NAME' AND COLUMN_ID = 0
UNION ALL 
SELECT '  , #{'|| LOWER(COLUMN_NAME) || '} AS '|| COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = 'TABLE_NAME' AND COLUMN_ID <> 0
UNION ALL
SELECT ' FROM DUAL' FROM DUAL;

--INSERT ���� ������
WITH T AS(
	SELECT TABLE_NAME , COLUMN_NAME,COLUMN_ID FROM ALL_TAB_COLUMNS WHERE OWNER ='OWNER'  AND TABLE_NAME ='TABLE_NAME'
)
SELECT 'INSERT INTO ' || TABLE_NAME || ' ( '|| CHR(10) ||'  ' || COLUMN_NAME FROM T WHERE COLUMN_ID ='0'
UNION ALL 
SELECT  ' , ' ||  COLUMN_NAME FROM T WHERE COLUMN_ID <>'0' 
UNION ALL
SELECT ') VALUES(' FROM DUAL
 UNION ALL
SELECT  ' #{' ||  LOWER(COLUMN_NAME) || '}' FROM T WHERE COLUMN_ID = '0'
UNION ALL
SELECT  ', #{' ||  LOWER(COLUMN_NAME) || '}' FROM T WHERE COLUMN_ID <>'0'
UNION ALL
SELECT ')' FROM DUAL;

--DELETE ���� ������
WITH T AS(
	SELECT TABLE_NAME , COLUMN_NAME,COLUMN_ID FROM ALL_TAB_COLUMNS WHERE OWNER ='OWNER'  AND TABLE_NAME ='TABLE_NAME'
)
SELECT 'DELETE FROM ' || TABLE_NAME || CHR(10) ||' WHERE ' || COLUMN_NAME || ' = #{'  || LOWER(COLUMN_NAME)  || '}' FROM T WHERE COLUMN_ID ='0'
UNION ALL 
SELECT  ' AND ' || COLUMN_NAME || ' = #{'  || LOWER(COLUMN_NAME)  || '}'  FROM T WHERE COLUMN_ID <>'0'; 
				
--SELECT ���� ������ SELECT ���� WHERE �� PK ����
WITH T AS (-- ���̺� ���
	SELECT 'TABLE_NAME' AS TABLE_NAME FROM DUAL
)
, T2 AS(--�÷���, �ڸ�Ʈ
	SELECT
	Z.COLUMN_NAME,
	CASE WHEN Z.COMMENTS IS NOT NULL AND INSTR(Z.COMMENTS,'?') < 1 THEN  --�ڸ�Ʈ ���� ������ ����
		'/* ' || Z.COMMENTS || ' */'
	END COMMNETS,
	COLUMN_ID,
	ROWNUM AS RN
FROM
	ALL_COL_COMMENTS Z,
	ALL_TAB_COLUMNS Z1,
	T
WHERE
	Z.TABLE_NAME = Z1.TABLE_NAME
	AND Z.COLUMN_NAME = Z1.COLUMN_NAME
	AND Z.TABLE_NAME = T.TABLE_NAME
ORDER BY COLUMN_ID ASC
), T3 AS(--PK�˻�
	SELECT UCC.COLUMN_NAME,ROWNUM AS RN FROM USER_CONS_COLUMNS UCC INNER JOIN USER_CONSTRAINTS UC
		ON UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
		INNER JOIN T ON  UCC.TABLE_NAME = T.TABLE_NAME
		WHERE UC.CONSTRAINT_TYPE = 'P'		  
)
SELECT RPAD('SELECT '||COLUMN_NAME,45,' ') || COMMNETS FROM T2 WHERE RN =1
UNION ALL 
SELECT '    , '||RPAD(COLUMN_NAME,50,' ') || COMMNETS FROM T2 WHERE RN > 1
UNION ALL 
SELECT 'FROM ' || TABLE_NAME FROM T
UNION ALL 
SELECT 'WHERE ' || COLUMN_NAME || ' = #{'||LOWER(COLUMN_NAME) ||'}'FROM T3 WHERE RN = 1
UNION ALL 
SELECT '  AND ' || COLUMN_NAME || ' = #{'||LOWER(COLUMN_NAME) ||'}'FROM T3 WHERE RN > 1


