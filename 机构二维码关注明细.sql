USE tune_prod;
SELECT
	b.branch_id AS `机构编号`,
	b.branch_name AS `机构名称`,
	SUM( cs.is_subscribed ) AS `增长数量`,
	DATE( cs.created_at ) AS `日期` 
FROM
	branch AS b
	LEFT JOIN customer_subscribe AS cs ON b.branch_id = cs.branch_id 
WHERE
	cs.branch_id IS NOT NULL 
GROUP BY
	DATE( cs.created_at ),
	b.branch_id 
ORDER BY
	`机构名称` ASC,
	cs.created_at ASC;