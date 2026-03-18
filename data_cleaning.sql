USE world_layoffs;


SELECT* 
FROM layoffs;

SELECT COUNT(*)
FROM layoffs;


--     OUR GOALS 
-- 1. Remove duplicates
-- 2. Standarize the data
-- 3.Null values or blank values
-- 4. Remove any columns

-- Copying the data to the staging phase 


CREATE TABLE layoffs_staging
LIKE layoffs;


INSERT INTO layoffs_staging
SELECT * 
FROM layoffs;


SELECT *
FROM layoffs_staging;

-- Remove duplicates


WITH duplicates_cte AS(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates_cte
WHERE row_num > 1;

-- check duplicates
SELECT *
FROM layoffs_staging 
WHERE company = 'casper';


-- Creating staging 2 table to delete data from it 

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2 ;


-- Disable safe updates
SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;


-- Standardizing data

SELECT company , TRIM(company)
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET company = TRIM(company);


SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;


-- Checking the Distinct industry names

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

-- Correcting the industry filed to be distinct

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



SELECT DISTINCT location
FROM layoffs_staging2;



SELECT country
FROM layoffs_staging2
WHERE country LIKE 'United States%';


SELECT DISTINCT country , TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;


UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT DISTINCT country 
FROM layoffs_staging2;

-- Changing the date column to date data type

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');


SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- Check the change of the type  
DESCRIBE layoffs_staging2;



-- Deleting missing values


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';


UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;



UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL)
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';



SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL ;


ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;


SELECT *
FROM layoffs_staging2;
















