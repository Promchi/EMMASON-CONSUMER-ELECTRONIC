# 📊 Emmason Consumer Electronics — Data-Driven Brand Reputation Analysis

## Project Overview
Emmason Consumer Electronics needed a systematic way to monitor brand reputation, understand customer behaviour, and track revenue performance. This project builds a full analytical framework using social media intelligence and transactional data — translating 73,587 rows of raw data into structured business insights and an executive-ready Power BI dashboard.

---

## Business Questions Answered
- How is the brand perceived across social media platforms?
- Which platforms drive the most engagement — and where is sentiment most negative?
- How quickly does the business respond to crisis events, and are they being resolved?
- What are the revenue trends, and what is driving year-over-year change?
- Which customer segments and products are most valuable?
- How do product recalls impact revenue?

---

## Key Findings

### 💰 Revenue & Transactions
- **Total revenue for the period: $57.53 million** across 73,590 transactions and 4 products sold in 49 US regions
- **50.23% of total revenue ($28.9M) was lost due to product recalls** — the single largest business risk identified
- Laptops and Smartphones were the top revenue-generating products at **42.72% and 24.87%** of total revenue respectively
- West Virginia and Nebraska were the top two performing regions — while high-population states like New York and California underperformed expectations, suggesting an untapped conversion opportunity
- A headline YoY revenue increase was found to be a **data coverage artefact** (incomplete 2022 baseline), not genuine growth — SQL cross-validation caught this before it reached the executive report
  
![Transaction Dashboard](/assets/Transaction-Dashboard.png)
  

### 👥 Customer Segmentation
- The **56–69 age group drives the highest revenue** and accounts for 27.5% of total customers, reflecting a positive age-value correlation
- Age groups 36–55 drove strong revenue but also had **higher product recall rates**, generating disproportionate losses
- VIP and Returning Customers (33.5% and 31% of base) convert better than New Customers (35.5%), despite New Customers having the highest engagement

![Customer Dashboard](/assets/Customer-Dashboard.png)

### 📱 Social Media & Brand Reputation
- **13,380+ crisis events** reported across all platforms with a crisis resolution rate of only **47.59%** — over half of reported crises went unresolved
- Median response time to a crisis report was **141 days** — a critical operational gap
- Brand mentions matched competitor mentions across all platforms, signalling **brand complacency**
- Total engagement: **181M likes, 74M shares, 37M comments**
- TikTok and Instagram drove the highest engagement
- Sentiment breakdown: Positive 40.01%, Neutral 40.08%, Negative 19.91% — the high neutral rate signals customer indifference rather than loyalty
- Peak engagement months: **December, March, May, July, and October** — indicating clear seasonality

  ![Social Media Dashboard](/assets/Social-Media-Dashboard.png)

---

## A Key Analytical Insight
> A headline YoY revenue increase appeared to show strong business growth — but deeper SQL investigation revealed the 2022 baseline only covered partial months, making the growth rate misleading. This was flagged and corrected before reaching the executive report, demonstrating the importance of contextual data validation.

---

## Tools & Technologies
| Tool | Purpose |
|------|---------|
| PostgreSQL | Data normalisation, EDA, SQL querying |
| Power BI + DAX | Data modelling, semantic analysis, interactive dashboards |
| Excel | Preliminary data inspection |
| PowerPoint | Executive presentation |

---

## Data & Structure
- **Dataset:** 73,587 rows, 20 columns (loaded as CSV into PostgreSQL)
- **Normalised into 3 tables:** `CustomerData`, `TransactionTable`, `SocialMediaData`
- Foreign key relationships enforced before loading into Power BI

> *Note: Age group segmentation was defined in SQL for data validation. Business logic and segment-level analysis are applied via DAX measures in Power BI — a deliberate design choice to keep semantic logic in the BI layer.*

---

## Repository Structure
```
EMMASON-CONSUMER-ELECTRONIC/
│
├── README.md
├── sql/
│   └── EMMASON_ELECTRONIC_SQL.sql      ← Full SQL scripts (normalisation + EDA)
└── assets/
    └── dashboard_screenshot.png        ← Power BI dashboard preview
```

📁 **Full project files** (Power BI .pbix, PDF report, PowerPoint presentation):
[Google Drive Folder →](https://drive.google.com/drive/folders/1kJ4gbhDWuFMkgtPlU_qtr4_lL0PCIiAr)

---

## Deliverables
- ✅ Interactive Power BI dashboard for executive reporting
- ✅ Normalised PostgreSQL database with full EDA scripts
- ✅ Executive PowerPoint presentation
- ✅ Full project documentation (PDF)

---

*Project completed February 2026 | Data Analytics Consultant at AMDARI*
