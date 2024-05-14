Create Database myproject;


SELECT DISTINCT SUBSTRING(ActionDate, 1, 4) AS UniqueYear
FROM RegActionDate;


SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    COUNT(DISTINCT p.ProductNo) AS NumberOfDrugsApproved
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
WHERE
    r.DocType = 'N'  -- Consider only Approval documents
GROUP BY
    SUBSTRING(r.ActionDate, 1, 4)
ORDER BY
    NumberOfDrugsApproved DESC, ApprovalYear
LIMIT 3;  -- Top three years with the highest approvals

Select distinct SponsorApplicant from Application;

Select * from Application

use myproject
Select distinct(ActionType) from Application
Select * from DocType_lookup

CREATE TABLE IF NOT EXISTS `ReviewClass_Lookup` (
	`ReviewClassID`	INTEGER,
	`ReviewCode`	VARCHAR(250) UNIQUE,
	`LongDescription`	VARCHAR(250),
	`ShortDescription`	VARCHAR(250),
	PRIMARY KEY(`ReviewClassID`)
);
Select * from ReviewClass_Lookup

Select * from ReviewClass_Lookup

CREATE TABLE IF NOT EXISTS `ChemTypeLookup` (
	`ChemicalTypeID`	INTEGER,
	`ChemicalTypeCode`	INTEGER,
	`ChemicalTypeDescription`	VARCHAR(250),
	PRIMARY KEY(`ChemicalTypeID`),
    INDEX(`ChemicalTypeCode`)
);

CREATE TABLE IF NOT EXISTS `Application` (
	`ApplNo`	INTEGER,
	`ApplType`	VARCHAR(250),
	`SponsorApplicant`	VARCHAR(250),
	`MostRecentLabelAvailableFlag`	VARCHAR(250),
	`CurrentPatentFlag`	VARCHAR(250),
	`ActionType`	VARCHAR(250),
	`Chemical_Type`	INTEGER,
	`Ther_Potential`	VARCHAR(250),
	`Orphan_Code`	VARCHAR(250),
	PRIMARY KEY(`ApplNo`),
    INDEX (`ActionType`),
	FOREIGN KEY(`Orphan_Code`) REFERENCES `ReviewClass_Lookup`(`ReviewCode`),
	FOREIGN KEY(`Chemical_Type`) REFERENCES `ChemTypeLookup`(`ChemicalTypeCode`),
	FOREIGN KEY(`Ther_Potential`) REFERENCES `ReviewClass_Lookup`(`ReviewCode`)
);


CREATE TABLE IF NOT EXISTS `Product` (
	`ApplNo`	INTEGER,
	`ProductNo`	INTEGER,
	`Form`	VARCHAR(250),
	`Dosage`	VARCHAR(250),
	`ProductMktStatus`	INTEGER,
	`TECode`	VARCHAR(250),
	`ReferenceDrug`	INTEGER,
	`drugname`	VARCHAR(200),
	`activeingred`	VARCHAR(250),
    INDEX (`TECode`),
    INDEX(`ProductMktStatus`),
    INDEX(`ProductNo`),
	PRIMARY KEY(`ApplNo`,`ProductNo`,`ProductMktStatus`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Application`(`ApplNo`)
);


CREATE TABLE IF NOT EXISTS `AppDocType_Lookup` (
	`AppDocType` VARCHAR(250),
	`SortOrder`	INTEGER,
	PRIMARY KEY(`AppDocType`)
);

Select * from AppDocType_Lookup

CREATE TABLE IF NOT EXISTS `DocType_lookup` (
	`DocType`	VARCHAR(250),
	`DocTypeDesc`	VARCHAR(250),
	PRIMARY KEY(`DocType`)
);


CREATE TABLE IF NOT EXISTS `Product_tecode` (
	`ApplNo`	INTEGER,
	`ProductNo`	INTEGER,
	`TECode`	VARCHAR(250),
	`TESequence`	INTEGER,
	`ProductMktStatus`	INTEGER,
	FOREIGN KEY(`ProductMktStatus`) REFERENCES `Product`(`ProductMktStatus`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Product`(`ApplNo`),
    FOREIGN KEY(`ProductNo`) REFERENCES `Product`(`ProductNo`),
	FOREIGN KEY(`TECode`) REFERENCES `Product`(`TECode`),
	PRIMARY KEY(`TESequence`,`ApplNo`,`ProductNo`,`ProductMktStatus`)
);



CREATE TABLE IF NOT EXISTS `RegActionDate` (
	`ApplNo`	INTEGER,
	`ActionType`	VARCHAR(250),
	`InDocTypeSeqNo`	INTEGER,
	`DuplicateCounter`	INTEGER,
	`ActionDate`	VARCHAR(250),
	`DocType`	VARCHAR(250),
    INDEX(`InDocTypeSeqNo`),
    INDEX(`DuplicateCounter`),
    INDEX(`ActionDate`),
	FOREIGN KEY(`ActionType`) REFERENCES `Application`(`ActionType`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Application`(`ApplNo`),
	FOREIGN KEY(`DocType`) REFERENCES `DocType_lookup`(`DocType`),
	PRIMARY KEY(`ApplNo`,`InDocTypeSeqNo`,`DuplicateCounter`)
);

Select * from RegActionDate


SELECT
    SUBSTRING(ActionDate, 1, 4) AS ApprovalYear,
    COUNT(DISTINCT p.ProductNo) AS NumberOfDrugsApproved
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
GROUP BY
    SUBSTRING(ActionDate, 1, 4)
ORDER BY
    ApprovalYear;


CREATE TABLE IF NOT EXISTS `AppDoc` (
	`AppDocID`	INTEGER,
	`ApplNo`	INTEGER,
	`SeqNo`	INTEGER,
	`DocType`	VARCHAR(250),
	`DocTitle`	VARCHAR(250),
	`DocURL`	VARCHAR(200),
	`DocDate`	VARCHAR(250),
	`ActionType`	VARCHAR(250),
	`DuplicateCounter`	INTEGER,
	PRIMARY KEY(`AppDocID`),
	FOREIGN KEY(`DocType`) REFERENCES `AppDocType_Lookup`(`AppDocType`),
	FOREIGN KEY(`ActionType`) REFERENCES `RegActionDate`(`ActionType`),
	FOREIGN KEY(`SeqNo`) REFERENCES `RegActionDate`(`InDocTypeSeqNo`),
	FOREIGN KEY(`ApplNo`) REFERENCES `RegActionDate`(`ApplNo`),
	FOREIGN KEY(`DuplicateCounter`) REFERENCES `RegActionDate`(`DuplicateCounter`),
	FOREIGN KEY(`DocDate`) REFERENCES `RegActionDate`(`ActionDate`)
);






INSERT INTO `AppDocType_Lookup` (`AppDocType`,`SortOrder`) VALUES ('Consumer Information Sheet',11),
 ('Dear Health Professional Letter',7),
 ('Exclusivity Letter',12),
 ('FDA Press Release',5),
 ('FDA Talk Paper',4),
 ('Healthcare Professional Sheet',16),
 ('Label',2),
 ('Letter',1),
 ('Medication Guide',8),
 ('Other',14),
 ('Other Important Information from FDA',10),
 ('Patient Information Sheet',15),
 ('Patient Package Insert',6),
 ('Pediatric Summary, Clinical Pharmacology Review',18),
 ('Pediatric Summary, Medical Review',17),
 ('Questions and Answers',13),
 ('Review',3),
 ('Summary Review',19),
 ('Withdrawal Notice',9);
 
 Select * from AppDocType_Lookup;
 
 
INSERT INTO `ChemTypeLookup` (`ChemicalTypeID`,`ChemicalTypeCode`,`ChemicalTypeDescription`) VALUES (1,1,'New molecular entity (NME)'),
 (2,2,'New active ingredient'),
 (3,3,'New dosage form'),
 (4,4,'New combination'),
 (5,5,'New formulation  or new manufacturer'),
 (6,6,'New indication [no longer used]'),
 (7,7,'Drug already marketed without an approved NDA'),
 (15,8,'OTC (over-the-counter) switch'),
 (16,10,'New indication submitted as distinct NDA - not consolidated'),
 (17,9,'New indication submitted as distinct NDA, consolidated with original NDA after approval');
 
 INSERT INTO `DocType_lookup` (`DocType`,`DocTypeDesc`) VALUES ('B','Biopharmaceutics'),
 ('M','Presubmission'),
 ('N','Approval'),
 ('P','Periodic Safety Report'),
 ('S','Supplement'),
 ('SB','SBA'),
 ('SC','Chemistry'),
 ('SCA','Packaging Addition'),
 ('SCB','Facility Addition'),
 ('SCC','Supplier Addition'),
 ('SCD','Packager Addition'),
 ('SCE','Expiration Date Change'),
 ('SCF','Formulation Revision'),
 ('SCG','Chemistry Generic'),
 ('SCI','Chemistry in Effect'),
 ('SCM','Manufacturing Change or Addition'),
 ('SCP','Package Change'),
 ('SCQ','Chemistry New Strength'),
 ('SCR','Manufacturing Revision'),
 ('SCS','Control Supplement'),
 ('SCX','Chemistry Expedite'),
 ('SDC',NULL),
 ('SDS','Distributor'),
 ('SE1','New or Modified Indication'),
 ('SE2','New Dosage Regimen'),
 ('SE3','New Route of Administration'),
 ('SE4','Comparative Efficacy Claim'),
 ('SE5','Patient Population Altered'),
 ('SE6','OTC Labeling'),
 ('SE7','Accelerated Approval'),
 ('SE8','Efficacy Supplement with Clinical Data to Support'),
 ('SED','Efficacy (MarkIV)'),
 ('SEF',NULL),
 ('SES','General Efficacy (MarkIV)'),
 ('SF','Final Printed Labeling (MarkIV)'),
 ('SFP','Final Printed Labeling - MarkIV'),
 ('SL','Labeling'),
 ('SLA','Labeling (MarkIV)'),
 ('SLI','Labeling in Effect'),
 ('SLM','Labeling (MarkIV)'),
 ('SLR','Labeling Revision'),
 ('SLS','Labeling (MarkIV)'),
 ('SLX','Labeling Expedite'),
 ('SO','Other'),
 ('SOA','Other Amendment'),
 ('SPD','Practioner Draft Labeling'),
 ('SPF','Practioner Draft Labeling'),
 ('SRC','Resubmission - Chemistry (MarkIV)'),
 ('SRE','Resubmission - Efficacy (MarkIV)'),
 ('SRO','Resubmission - Other (MarkIV)'),
 ('SS','Microbiology'),
 ('SSA','Supplement Amendment (MarkIV)'),
 ('SSP','Supplement Pediatric (MarkIV)'),
 ('SSR','Supplement Resubmission (MarkIV)'),
 ('SSW','Supplement Withdrawal (MarkIV)'),
 ('TA','Tentative Approval'),
 ('Y','Annual Report');
 
 
 
  
INSERT INTO `ReviewClass_Lookup` (`ReviewClassID`,`ReviewCode`,`LongDescription`,`ShortDescription`) VALUES (1,'P','A drug that appears to represent an advance over available therapy','Priority review drug'),
 (2,'S','A drug that appears to have therapeutic qualities similar to those of an already marketed drug','Standard review drug'),
 (3,'V',NULL,'Orphan drug');
 
 
 
 
 
 
 Select count(distinct(p.drugname)) as total_drugs, year(r.actiondate) approved_year 
 from application a inner join product p inner join regactiondate r
 on a.applno = p.applno = r.applno group by approved_year;
 
 Select * from ReviewClass_Lookup
 
Select * from Product
 
 
 
 
 
 
 
 
 /*Task 1 Question1 - No. of Drugs Yearly*/
 
 
 SELECT
    SUBSTRING(ActionDate, 1, 4) AS ApprovalYear,
    COUNT(DISTINCT p.ProductNo) AS NumberOfDrugsApproved
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
GROUP BY
    SUBSTRING(ActionDate, 1, 4)
ORDER BY
    ApprovalYear;
    
 
  /*Task 1 Question2 - highest and lowest approvals, in descending and ascending order*/
 
 
SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    COUNT(DISTINCT p.ProductNo) AS NumberOfDrugsApproved
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
WHERE
    r.DocType = 'N'  -- Consider only Approval documents
GROUP BY
    SUBSTRING(r.ActionDate, 1, 4)
ORDER BY
    NumberOfDrugsApproved DESC, ApprovalYear
LIMIT 3;  -- Top three years with the highest approvals

-- For the lowest approvals
SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    COUNT(DISTINCT p.ProductNo) AS NumberOfDrugsApproved
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
WHERE
    r.DocType = 'N'  -- Consider only Approval documents
GROUP BY
    SUBSTRING(r.ActionDate, 1, 4)
ORDER BY
    NumberOfDrugsApproved, ApprovalYear
LIMIT 3;  -- Top three years with the lowest approvals







  /*Task 1 Question3 - Approval trends over the years based on sponsors.*/

SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    a.SponsorApplicant,
    COUNT(DISTINCT p.ProductNo) AS NumberOfApprovals
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
WHERE
    r.DocType = 'N'  -- Consider only Approval documents
GROUP BY
    ApprovalYear, a.SponsorApplicant
ORDER BY
    ApprovalYear, NumberOfApprovals DESC;
    
    
    
    
    
    
    
 /*Task 1 Question4 - Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.*/   
SELECT
    ApprovalYear,
    SponsorApplicant,
    SUM(NumberOfApprovals) AS TotalApprovals
FROM
    (
        SELECT
            SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
            a.SponsorApplicant,
            COUNT(DISTINCT p.ProductNo) AS NumberOfApprovals
        FROM
            RegActionDate r
        JOIN
            Application a ON r.ApplNo = a.ApplNo
        JOIN
            Product p ON a.ApplNo = p.ApplNo
        WHERE
            r.DocType = 'N'  -- Consider only Approval documents
            AND SUBSTRING(r.ActionDate, 1, 4) BETWEEN '1939' AND '1960'
        GROUP BY
            ApprovalYear, a.SponsorApplicant
    ) AS Subquery
GROUP BY
    ApprovalYear, SponsorApplicant
ORDER BY
    ApprovalYear, TotalApprovals DESC;
    
    
    
/*Task 2 Question1 - Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns*/      
SELECT
    ProductMktStatus,
    COUNT(DISTINCT p.ProductNo) AS NumberOfProducts,
    GROUP_CONCAT(DISTINCT p.drugname ORDER BY p.ProductNo ASC SEPARATOR ', ') AS ProductNames
FROM
    Product p
GROUP BY
    ProductMktStatus
ORDER BY
    NumberOfProducts DESC;
    
    
    
    
    
    
 /*Task 2 Question2 - Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.*/      
SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    p.ProductMktStatus,
    COUNT(DISTINCT a.ApplNo) AS NumberOfApplications
FROM
    RegActionDate r
JOIN
    Application a ON r.ApplNo = a.ApplNo
JOIN
    Product p ON a.ApplNo = p.ApplNo
WHERE
    SUBSTRING(r.ActionDate, 1, 4) > '2010'
GROUP BY
    ApprovalYear, p.ProductMktStatus
ORDER BY
    ApprovalYear, NumberOfApplications DESC;
    
    
    
    
    
    
    
    
    
    
    
    
/*Task 2 Question3 - Identify the top MarketingStatus with the maximum number of applications and analyze its trend over time.*/    
WITH MarketingStatusApplications AS (
    SELECT
        SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
        p.ProductMktStatus,
        COUNT(DISTINCT a.ApplNo) AS NumberOfApplications
    FROM
        RegActionDate r
    JOIN
        Application a ON r.ApplNo = a.ApplNo
    JOIN
        Product p ON a.ApplNo = p.ApplNo
    GROUP BY
        ApprovalYear, p.ProductMktStatus
)
SELECT
    ApprovalYear,
    ProductMktStatus,
    NumberOfApplications
FROM
    MarketingStatusApplications
WHERE
    (ApprovalYear, NumberOfApplications) IN (
        SELECT
            ApprovalYear,
            MAX(NumberOfApplications) AS MaxApplications
        FROM
            MarketingStatusApplications
        GROUP BY
            ApprovalYear
    )
ORDER BY
    ApprovalYear;





/*Task 3 Question1 - Categorize Products by dosage form and analyze their distribution.*/  
SELECT
    Form AS DosageForm,
    COUNT(ProductNo) AS NumberOfProducts
FROM
    Product
GROUP BY
    Form
ORDER BY
    NumberOfProducts DESC;
    
    
    
    
    
    
/*Task 3 Question2 - Calculate the total number of approvals for each dosage form and identify the most successful forms.*/  



SELECT
    p.Form AS DosageForm,
    COUNT(DISTINCT a.ApplNo) AS NumberOfApprovals
FROM
    Product p
JOIN
    Application a ON p.ApplNo = a.ApplNo
JOIN
    RegActionDate r ON a.ApplNo = r.ApplNo
JOIN
    Doctype_lookup d ON r.DocType = d.DocType
WHERE
    d.DocType = 'N'
GROUP BY
    p.Form
ORDER BY
    NumberOfApprovals DESC;
    
    
    
    
    
    
    
/*Task 3 Question3 - Investigate yearly trends related to successful forms.*/  
SELECT
    SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
    p.Form AS DosageForm,
    COUNT(DISTINCT a.ApplNo) AS NumberOfApprovals
FROM
    Product p
JOIN
    Application a ON p.ApplNo = a.ApplNo
JOIN
    RegActionDate r ON a.ApplNo = r.ApplNo
JOIN
    Doctype_lookup d ON r.DocType = d.DocType
WHERE
    d.DocType = 'N'
GROUP BY
    ApprovalYear, p.Form
ORDER BY
    ApprovalYear, NumberOfApprovals DESC;
    
    
    
    
/*Task 4 Question1 - Investigate yearly trends related to successful forms.*/  

SELECT
    pt.TECode,
    p.drugname,
    COUNT(*) AS NumberOfApprovals
FROM
    Product_tecode pt
JOIN
    Product p ON pt.ApplNo = p.ApplNo AND pt.ProductNo = p.ProductNo
JOIN
    Application a ON pt.ApplNo = a.ApplNo
JOIN
    RegActionDate r ON a.ApplNo = r.ApplNo
JOIN
    Doctype_lookup d ON r.DocType = d.DocType
WHERE
    d.DocType = 'N'
GROUP BY
    pt.TECode, p.drugname
ORDER BY
    NumberOfApprovals DESC;
    
    
    
    
    
    
    
    
/*Task 4 Question2 - Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.*/  
WITH TECodeApprovals AS (
    SELECT
        SUBSTRING(r.ActionDate, 1, 4) AS ApprovalYear,
        pt.TECode,
        COUNT(*) AS NumberOfApprovals
    FROM
        Product_tecode pt
    JOIN
        Application a ON pt.ApplNo = a.ApplNo
    JOIN
        RegActionDate r ON a.ApplNo = r.ApplNo
    JOIN
        Doctype_lookup d ON r.DocType = d.DocType
    WHERE
        d.DocType = 'N'
    GROUP BY
        ApprovalYear, pt.TECode
)

SELECT
    ApprovalYear,
    TECode,
    NumberOfApprovals
FROM (
    SELECT
        ApprovalYear,
        TECode,
        NumberOfApprovals,
        ROW_NUMBER() OVER (PARTITION BY ApprovalYear ORDER BY NumberOfApprovals DESC) AS rn
    FROM
        TECodeApprovals
) ranked
WHERE
    rn = 1
ORDER BY
    ApprovalYear;



















