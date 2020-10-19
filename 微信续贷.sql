USE tune_prod;
SELECT
	b.branch_id AS `机构编号`,
	b.branch_name AS `机构名称`,
IF
	( company.region = 'Nanchong', '南充', '成都' ) AS `地区`,
	c.`日期`,
	c.`月增长数量`,
	d.`总数量` 
FROM
	branch AS b
	LEFT JOIN company ON b.company_code = company.company_code
	LEFT JOIN (
SELECT
	SUBSTRING( dao, 1, 2 ) AS branch_id,
	DATE_FORMAT( updated_at, "%Y年%m月" ) AS `日期`,
	COUNT( DISTINCT id ) AS `月增长数量` 
FROM
	loan_renewal_application 
WHERE
	state = 3 
	AND dao <> "" 
	AND dao IS NOT NULL 
GROUP BY
	branch_id,
	`日期` 
ORDER BY
	branch_id 
	) AS c ON b.branch_id = c.branch_id
	LEFT JOIN (
SELECT
	SUBSTRING( dao, 1, 2 ) AS branch_id,
	COUNT( DISTINCT id ) AS `总数量` 
FROM
	loan_renewal_application 
WHERE
	state = 3 
	AND dao <> "" 
	AND dao IS NOT NULL 
GROUP BY
	branch_id 
	) AS d ON b.branch_id = d.branch_id;