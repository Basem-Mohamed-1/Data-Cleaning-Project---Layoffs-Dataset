# 🧹 Data Cleaning Project - World Layoffs Dataset

## 📌 Project Overview
In this project, I performed data cleaning on a real-world layoffs dataset using SQL. The goal was to transform raw, inconsistent data into a clean and structured format suitable for analysis.

---

## 📂 Dataset
The dataset contains information about:
- Company name  
- Location  
- Industry  
- Total laid off employees  
- Percentage laid off  
- Date  
- Stage  
- Country  
- Funds raised  

---

## 🎯 Objectives
- Remove duplicates  
- Standardize data  
- Handle NULL and blank values  
- Convert date format  
- Remove unnecessary columns  

---

## 🛠️ Tools Used
- SQL  
- MySQL  

---

## 🔧 Data Cleaning Steps

### 1. Data Staging
- Created a staging table
- Copied raw data into it

```sql
CREATE TABLE layoffs_staging LIKE layoffs;

INSERT INTO layoffs_staging
SELECT * FROM layoffs;
