USE tune_prod;

SET @endDate := DATE_ADD( CURDATE( ), INTERVAL - DAY ( CURDATE( ) ) + 1 DAY );

SET @startDate := date_add( CURDATE( ) - DAY ( CURDATE( ) ) + 1, INTERVAL - 1 MONTH );

SET @lastMonth := MONTH ( curdate( ) ) - 1;

SET @strsql := concat( 'SELECT
b.branch_id AS `机构编号`,
b.branch_name AS `机构名称`,
Count( DISTINCT c.t24_contract_record_id ) AS `合同数量`,
Count( DISTINCT c10.t24_contract_record_id ) AS `', @lastMonth, '合同数量` 
FROM
	branch AS b
	LEFT JOIN (
	SELECT
		t24_contract_record_id,
		SUBSTRING( dao, 1, 2 ) AS branch_id 
	FROM
		contract 
	WHERE
		contract_id LIKE "LA%" 
		AND state = 1 
		AND dao <> "" 
		AND dao IS NOT NULL 
	) AS c ON b.branch_id = c.branch_id
	LEFT JOIN (
	SELECT
		t24_contract_record_id,
		SUBSTRING( dao, 1, 2 ) AS branch_id 
	FROM
		contract 
	WHERE
		contract_id LIKE "LA%" 
		AND state = 1 
		AND dao <> "" 
		AND dao IS NOT NULL 
		AND sign_end_at < \'', @endDate, '\' AND sign_end_at > \'', @startDate, '\' 
		) AS c10 ON c10.branch_id = c.branch_id 
		GROUP BY
	b.branch_id;' );
PREPARE stmt 
FROM
	@strsql;
EXECUTE stmt;