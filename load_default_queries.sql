 -- BANK LOAN DEFAULT ANALYSIS
CREATE DATABASE loan_default_prediction;
USE loan_default_prediction;
SELECT count(*) FROM cs_cleaned;
SELECT * FROM cs_cleaned;
-- Default Rate by Age Group
SELECT   
    CASE   
        WHEN age < 30 THEN 'Young'  
        WHEN age BETWEEN 30 AND 45 THEN 'Middle'  
        WHEN age BETWEEN 46 AND 60 THEN 'Senior'  
        ELSE 'Old'  
    END AS AgeGroup,  
    COUNT(*) AS TotalCustomers,  
    SUM(SeriousDlqin2yrs) AS Defaulters,  
    ROUND(AVG(SeriousDlqin2yrs) * 100, 2) AS DefaultRate  
FROM cs_cleaned  
GROUP BY   
    CASE   
        WHEN age < 30 THEN 'Young'  
        WHEN age BETWEEN 30 AND 45 THEN 'Middle'  
        WHEN age BETWEEN 46 AND 60 THEN 'Senior'  
        ELSE 'Old'  
    END  
ORDER BY DefaultRate DESC;

-- Late Payments vs Default Rate
SELECT 
    TotalLatePayments,
    COUNT(*) AS TotalCustomers,
    SUM(SeriousDlqin2yrs) AS Defaulters,
    ROUND(AVG(SeriousDlqin2yrs) * 100, 2) AS DefaultRate
FROM cs_cleaned
GROUP BY TotalLatePayments
ORDER BY TotalLatePayments ASC
LIMIT 10;

 -- Income & Debt Comparison
SELECT 
    SeriousDlqin2yrs AS Defaulter,
    COUNT(*) AS TotalCustomers,
    ROUND(AVG(MonthlyIncome), 2) AS AvgIncome,
    ROUND(AVG(DebtRatio), 2) AS AvgDebtRatio,
    ROUND(AVG(age), 1) AS AvgAge
FROM cs_cleaned
GROUP BY SeriousDlqin2yrs;

 -- High Risk Customer Segment
SELECT 
    CASE 
        WHEN age < 30 THEN 'Young'
        WHEN age BETWEEN 30 AND 45 THEN 'Middle'
        WHEN age BETWEEN 46 AND 60 THEN 'Senior'
        ELSE 'Old'
    END AS AgeGroup,
    CASE
        WHEN RevolvingUtilizationOfUnsecuredLines > 0.7 THEN 'High Usage'
        WHEN RevolvingUtilizationOfUnsecuredLines BETWEEN 0.4 AND 0.7 THEN 'Medium Usage'
        ELSE 'Low Usage'
    END AS CreditUsage,
    COUNT(*) AS TotalCustomers,
    ROUND(AVG(SeriousDlqin2yrs) * 100, 2) AS DefaultRate
FROM cs_cleaned
GROUP BY 1, 2
ORDER BY DefaultRate DESC
LIMIT 10;


