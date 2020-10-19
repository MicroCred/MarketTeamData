USE tune_prod;

SET @endDate := DATE_ADD( CURDATE( ), INTERVAL - DAY ( CURDATE( ) ) + 1 DAY );

SET @startDate := date_add( CURDATE( ) - DAY ( CURDATE( ) ) + 1, INTERVAL - 1 MONTH );

SET @lastMonth := MONTH ( curdate( ) ) - 1;

SET @strsql := concat( 'SELECT
b.branch_id AS `机构编号`,
b.branch_name AS `机构名称`,
IFNULL( csa.total, 0 ) AS `总关注`,
IFNULL( cs10.increment, 0 ) AS `', @lastMonth, '月增长` 
FROM
	branch AS b
	LEFT JOIN (
	SELECT
		COUNT( cs.platform_user_id ) AS total,
		cs.branch_id AS branch_id 
	FROM
		customer_subscribe AS cs 
	WHERE
		cs.branch_id IS NOT NULL 
		AND cs.is_subscribed = 1
		
	GROUP BY
		cs.branch_id 
	) AS csa ON b.branch_id = csa.branch_id
	LEFT JOIN (
	SELECT
		COUNT( cs.platform_user_id ) AS increment,
		cs.branch_id AS branch_id 
	FROM
		customer_subscribe AS cs 
	WHERE
		cs.branch_id IS NOT NULL 
		AND cs.is_subscribed = 1 
		AND cs.created_at < \'', @endDate, '\' AND cs.created_at > \'', @startDate, '\' 
		GROUP BY
		cs.branch_id 
		) AS cs10 ON b.branch_id = cs10.branch_id
		
		ORDER BY
	`', @lastMonth, '月增长` DESC;' );
PREPARE stmt 
FROM
	@strsql;
EXECUTE stmt;