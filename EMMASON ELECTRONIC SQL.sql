-- Create Table
CREATE TABLE AfritechTable(
	CustomerID TEXT,
	CustomerName TEXT,
	Region TEXT,
	Age INT,
	CustomerType TEXT, 
	TransactionDate DATE,
	ProductPurchased TEXT,
	PurchaseAmount NUMERIC(10,2),
	ProductRecalled BOOLEAN, 
	InteractionDate DATE,
	Platform TEXT,
	EngagementLikes INT,
	EngagementShares INT,
	EngagementComments INT,
	BrandMention BOOLEAN,
	CompetitorMention BOOLEAN,
	Sentiment TEXT,
	CrisisEventTIme DATE,
	FirstResponseTime DATE,
	ResolutionStatus BOOLEAN
);

-- Check that the table has been created
-- column rows has been inserted via import
SELECT * FROM AfritechTable;

-- data normalisation
-- customer table
CREATE TABLE CustomerData(
	CustomerID TEXT PRIMARY KEY,
	CustomerName TEXT,
	Region TEXT,
	Age INT,
	CustomerType TEXT
);

-- transaction table
-- transactionID is added, auto generated with Serial
-- customerID is specified as the foreign key and referenced
CREATE TABLE TransactionTable(
	TransactionID SERIAL PRIMARY KEY,
	CustomerID TEXT,
	TransactionDate DATE,
	ProductPurchased TEXT,
	PurchaseAmount NUMERIC(10,2),
	ProductRecalled BOOLEAN, 
	InteractionDate DATE,
	FOREIGN KEY (CustomerID) REFERENCES CustomerData(CustomerID)
);
SELECT * FROM TransactionTable;

-- social media table
CREATE TABLE SocialMediaData(
	PostID SERIAL PRIMARY KEY,
	CustomerID TEXT,
	Platform TEXT,
	EngagementLikes INT,
	EngagementShares INT,
	EngagementComments INT,
	BrandMention BOOLEAN,
	CompetitorMention BOOLEAN,
	Sentiment TEXT,
	CrisisEventTIme DATE,
	FirstResponseTime DATE,
	ResolutionStatus BOOLEAN,
	FOREIGN KEY (CustomerID) REFERENCES CustomerData(CustomerID)
);

ALTER TABLE SocialMediaData
ADD COLUMN InteractionDate DATE;

-- See result of Updated SocialMediaData Table
SELECT * FROM SocialMediaData;

-- Insert data into the CustomerData table
INSERT INTO CustomerData(CustomerID, CustomerName, Region, Age, CustomerType) 
SELECT DISTINCT CustomerID, CustomerName, Region, Age, CustomerType 
FROM AfriTechTable;

-- See the result of the CustomerData
SELECT * FROM CustomerData;

--Insert data into TransactionTable
INSERT INTO TransactionTable (CustomerID, TransactionDate, 
			ProductPurchased, PurchaseAmount, ProductRecalled, InteractionDate)
SELECT CustomerID, TransactionDate, 
		ProductPurchased, PurchaseAmount, ProductRecalled, InteractionDate
FROM AfritechTable
WHERE TransactionDate IS NOT NULL;

-- See result of transactionTable
SELECT * FROM TransactionTable;

-- Insert data into SocialMediaData Table
INSERT INTO SocialMediaData (CustomerID, InteractionDate, Platform, EngagementLikes, 
			EngagementShares, EngagementComments, BrandMention, 
			CompetitorMention, Sentiment, CrisisEventTIme, 
			FirstResponseTime, ResolutionStatus)
SELECT CustomerID, InteractionDate, Platform, EngagementLikes, 
		EngagementShares, EngagementComments, BrandMention, 
		CompetitorMention, Sentiment, CrisisEventTIme, 
		FirstResponseTime, ResolutionStatus
FROM AfriTechTable;

-- See result of SocialMediaData Table
SELECT * FROM SocialMediaData;

-- check for duplicates
SELECT CustomerID, COUNT(*)
FROM CustomerData
GROUP BY CustomerID
HAVING COUNT(*)>1;

-- Check for Nulls
SELECT COUNT(*) AS Null_count FROM SocialMediaData
WHERE CrisisEventTime IS NULL;

-- Exploratory Data Analysis (EDA)
-- Likes across platforms
SELECT Platform, SUM(EngagementLikes) AS total_likes, 
		ROUND(AVG(EngagementLikes),  2) AS Average_likes,
		SUM(EngagementComments) AS total_Comments,
		ROUND(AVG(EngagementComments),  2) AS Average_comments,
		SUM(EngagementShares) AS total_Shares,
		ROUND(AVG(EngagementShares),  2) AS Average_Shares
FROM SocialMediaData
GROUP BY Platform
ORDER BY SUM(EngagementLikes);

-- sentiment counts
SELECT Sentiment, COUNT(*) AS Sentiment_count
FROM SocialMediaData
GROUP BY Sentiment;

-- sentiment distribution across platforms
SELECT Platform, Sentiment, COUNT(*) AS sentiment_count
FROM SocialMediaData
GROUP BY Platform, Sentiment;

-- monthly breakdown of likes, shares and comments
SELECT EXTRACT(MONTH FROM InteractionDate) AS interaction_month,
		SUM(EngagementLikes) AS total_likes, 
		SUM(EngagementShares) AS total_shares,
		SUM(EngagementComments) AS total_comments
FROM SocialMediaData
GROUP BY interaction_month
ORDER BY EXTRACT(MONTH FROM InteractionDate);


-- alternative method: monmthly breakdown of engagement data
-- with the months spelt out (month name)
SELECT TO_CHAR(InteractionDate, 'Month') AS interaction_month,
		SUM(EngagementLikes) AS total_likes, 
		SUM(EngagementShares) AS total_shares,
		SUM(EngagementComments) AS total_comments
FROM SocialMediaData
GROUP BY TO_CHAR(InteractionDate, 'Month')
ORDER BY interaction_month;

-- order by month chronologically using TRIM and TO_CHAR, Order by month 
-- number, not by month name
SELECT EXTRACT(MONTH FROM InteractionDate) AS interaction_month_number,
		(TO_CHAR(InteractionDate, 'Month')) AS interaction_month_name,
		SUM(EngagementLikes) AS total_likes, 
		SUM(EngagementShares) AS total_shares,
		SUM(EngagementComments) AS total_comments
FROM SocialMediaData
GROUP BY EXTRACT(MONTH FROM InteractionDate),
		 (TO_CHAR(InteractionDate, 'Month'))
ORDER BY EXTRACT(MONTH FROM InteractionDate);


-- Brand Mention Vs Competitor Mention
SELECT SUM(CASE
				WHEN BrandMention = 'True'
				THEN 1
				ELSE 0
				END) AS BrandMentionCount,
		SUM(CASE
				WHEN CompetitorMention ='True'
				THEN 1
				ELSE 0
				END) AS CompetitorMentionCount
FROM SocialMediaData;

-- Sentiments and BrandMention Vs CompetitorMention
SELECT Sentiment, SUM(CASE
				WHEN BrandMention = 'True'
				THEN 1
				ELSE 0
				END) AS BrandMentionCount,
		SUM(CASE
				WHEN CompetitorMention ='True'
				THEN 1
				ELSE 0
				END) AS CompetitorMentionCount
FROM SocialMediaData
GROUP BY Sentiment;

-- Breakdown of BrandMention & Competitormention by Month & Year
SELECT EXTRACT(YEAR FROM InteractionDate) AS Year,
		TO_CHAR(InteractionDate, 'Month') AS Month,
		SUM(CASE
				WHEN BrandMention = 'True'
				THEN 1
				ELSE 0
				END) AS BrandMentionCount,
		SUM(CASE
				WHEN CompetitorMention ='True'
				THEN 1
				ELSE 0
				END) AS CompetitorMentionCount
FROM SocialMediaData
GROUP BY EXTRACT(YEAR FROM InteractionDate),
		TO_CHAR(InteractionDate, 'Month'),
		EXTRACT(MONTH FROM InteractionDate)
ORDER BY EXTRACT(YEAR FROM InteractionDate),
		 EXTRACT(MONTH FROM InteractionDate);

-- Platform by BrandMention & CompetiotorMention
SELECT Platform, SUM(CASE
				WHEN BrandMention = 'True'
				THEN 1
				ELSE 0
				END) AS BrandMentionCount,
		SUM(CASE
				WHEN CompetitorMention ='True'
				THEN 1
				ELSE 0
				END) AS CompetitorMentionCount
FROM SocialMediaData
GROUP BY Platform;

-- Response time to crisis
SELECT FirstResponseTime - CrisisEventTime
FROM SocialMediaData;

-- Response time to Crisis when no  nulls
SELECT FirstResponseTime - CrisisEventTime
FROM SocialMediaData
WHERE FirstResponseTime IS NOT NULL AND CrisisEventTime IS NOT NULL;

-- response time (max, min, avg, median)
SELECT  MIN(FirstResponseTime - CrisisEventTime) AS minresponsetime,
		MAX(FirstResponseTime - CrisisEventTime) AS maxresponsetime,
		ROUND(AVG(FirstResponseTime - CrisisEventTime), 0) AS avgresponsetime,
		PERCENTILE_CONT(0.5) WITHIN GROUP 
		(ORDER BY FirstResponseTime - CrisisEventTime) AS medianresponsetime
FROM SocialMediaData;

-- response across platforms
SELECT Platform, MIN(FirstResponseTime - CrisisEventTime) AS minresponsetime,
		MAX(FirstResponseTime - CrisisEventTime) AS maxresponsetime,
		ROUND(AVG(FirstResponseTime - CrisisEventTime), 0) AS avgresponsetime,
		PERCENTILE_CONT(0.5) WITHIN GROUP 
		(ORDER BY FirstResponseTime - CrisisEventTime) AS medianresponsetime
FROM SocialMediaData
GROUP BY Platform;

-- resolution status
SELECT ResolutionStatus, 
		COUNT(*) FROM SocialMediaData
WHERE ResolutionStatus IS NOT NULL
GROUP BY ResolutionStatus;

SELECT ResolutionStatus,
		MIN(FirstResponseTime - CrisisEventTime) AS minresponsetime,
		MAX(FirstResponseTime - CrisisEventTime) AS maxresponsetime,
		ROUND(AVG(FirstResponseTime - CrisisEventTime), 0) AS avgresponsetime,
		PERCENTILE_CONT(0.5) WITHIN GROUP 
		(ORDER BY FirstResponseTime - CrisisEventTime) AS medianresponsetime
FROM SocialMediaData
WHERE ResolutionStatus IS NOT NULL
GROUP BY ResolutionStatus;

-- Platforms and their resolutionstatus
SELECT Platform, ResolutionStatus, COUNT(*)
FROM SocialMediaData
WHERE ResolutionStatus IS NOT NULL
GROUP BY Platform, ResolutionStatus
ORDER BY Platform;


-- Customer Data
--Total Number of Customers
SELECT COUNT(CustomerID) AS TotalCustomers
FROM CustomerData;

-- Customers by Region
SELECT Region, COUNT(*)
FROM CustomerData
GROUP BY Region
ORDER BY COUNT(*) DESC
LIMIT 15;

-- Age (highest, lowest, average)
SELECT MAX(Age) AS max_age, MIN(Age) AS min_age,
		ROUND(AVG(Age), 0) AS Average_age
FROM CustomerData;

-- Using a Common Table Expression (CTE) to define the Customer Age Groups
WITH Age_Group AS
	(SELECT *, CASE 
				WHEN Age <=30 THEN 'Young Adult' 
				WHEN Age <=45 THEN 'Adult'
				WHEN Age <=60 THEN 'Middle Age'
				ELSE 'Senior' 
				END AS Age_Buckets
	FROM CustomerData
	)
SELECT *
FROM Age_Group;

-- customer type breakdown
SELECT Customertype, COUNT(*)
FROM CustomerData
GROUP BY CustomerType;


-- EDA on Transaction Data
-- sum of transactions 
SELECT SUM(PurchaseAmount) FROM TransactionTable;

-- Revenue by Year to see the YoY change
SELECT SUM(PurchaseAmount) AS Total_Revenue,
		EXTRACT(YEAR FROM InteractionDate) AS Year
FROM TransactionTable
WHERE InteractionDate IS NOT NULL
GROUP BY Year;

-- check for the months available for 2022 due 
-- to the large YoY difference from 2023
SELECT SUM(PurchaseAmount) Revenue_2022, 
		TO_CHAR(InteractionDate, 'MONTH') AS Month 
FROM TransactionTable 
WHERE EXTRACT(YEAR FROM InteractionDate) = '2022'
GROUP BY TO_CHAR(InteractionDate, 'MONTH');


SELECT SUM(PurchaseAmount) 
FROM TransactionTable
WHERE ProductRecalled = 'True';

-- Sum Of Transactions by Product Purchased
SELECT ProductPurchased, SUM(PurchaseAmount) 
FROM TransactionTable
GROUP BY ProductPurchased;

-- Check for product recalled or not
SELECT ProductRecalled, COUNT(*) AS Recall_Count
FROM TransactionTable
GROUP BY ProductRecalled;

-- Check the difference in Amount between products recalled and not
SELECT ProductRecalled, COUNT(*) AS Recall_Count, 
		SUM(PurchaseAmount) AS Total_amount
FROM TransactionTable
GROUP BY ProductRecalled;

SELECT * FROM TransactionTable;

-- Product Recalled by Year and Month
-- By month
SELECT EXTRACT(MONTH FROM InteractionDate) AS Recall_month,
		TO_CHAR(InteractionDate, 'MONTH') AS Month,
		COUNT(ProductRecalled) AS Total_recall, SUM(PurchaseAmount)
FROM TransactionTable
WHERE ProductRecalled = 'True'
GROUP BY TO_CHAR(InteractionDate, 'MONTH'), 
		 EXTRACT(MONTH FROM InteractionDate)
ORDER BY Total_recall DESC;

-- By Year
SELECT EXTRACT(YEAR FROM InteractionDate) AS Recall_Year,
		COUNT(ProductRecalled) AS Total_recall, SUM(PurchaseAmount)
FROM TransactionTable
WHERE ProductRecalled = 'True'
GROUP BY EXTRACT(YEAR FROM InteractionDate)
ORDER BY EXTRACT(YEAR FROM InteractionDate);


-- Product Recalls by Region
SELECT * FROM CustomerData ORDER BY CustomerID;
SELECT * FROM TransactionTable;

SELECT Region, COUNT(ProductRecalled) AS Total_Recall 
FROM CustomerData
JOIN TransactionTable
ON CustomerData.CustomerID = TransactionTable.CustomerID
WHERE ProductRecalled ='True'
GROUP BY Region
ORDER BY COUNT(ProductRecalled) DESC;

