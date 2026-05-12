
# 📊 Superstore EDA Analysis

## 🧠 Project Overview
This project performs Exploratory Data Analysis (EDA) on a retail Superstore dataset to uncover insights related to sales, profit, discounts, shipping duration, and overall business performance.

The goal is to identify key patterns, trends and anomalies that influence profitability and operational efficiency.

---

## 📂 Dataset Description
The dataset contains transactional retail data including:

- Sales  
- Profit  
- Discount  
- Quantity  
- Shipping Duration  
- Profit Margin  
- Customer and Order information (cleaned where necessary)

---

## 🎯 Objectives
- Understand sales and profit distribution  
- Identify loss-making transactions  
- Analyse the impact of discounts on profitability  
- Explore variability in unit price and shipping duration  
- Detect outliers and extreme values  
- Generate actionable business insights  

---

## 🧹 Data Cleaning Steps
- Removed irrelevant identifier columns (e.g. Row ID, Customer Name)  
- Converted Discount into percentage format for readability  
- Created derived feature: Profit Margin (%)  
- Checked for missing values and data inconsistencies  

---

## 📊 Key Insights
- Sales are highly skewed, with a few high-value transactions driving overall revenue  
- Profit shows large variability, including both significant losses and gains  
- High discounts (up to 80%) are strongly associated with negative profit margins  
- Shipping duration is relatively stable and not a major driver of profitability  
- The dataset contains extreme outliers affecting profit and profit margin  

---

## 🛠️ Technologies Used
- Python  
- Pandas   
- Jupyter Notebook  

---

## ⚙️ Setup Instructions

### 1. Clone the repository
```bash
git clone https://github.com/ZoDesign/superstore-analysis.git
cd superstore-analysis
````

---

### 2. Create a virtual environment

```bash
python -m venv .venv
```

---

### 3. Activate virtual environment

**Windows:**

```bash
.venv\Scripts\activate
```

**Mac/Linux:**

```bash
source .venv/bin/activate
```

---

### 4. Install dependencies

```bash
pip install -r requirements.txt
```

---

### 5. Run the notebook

Open:

```
notebooks/cleaning.ipynb
```

---

## 🚫 Important Notes

* The `.venv/` folder is excluded
---

## 📌 Future Improvements

* Customer segmentation analysis
* Predictive modeling for profit forecasting
* Interactive dashboard (Streamlit)
* Deeper analysis of discount strategies by category

---

## 👤 Author

Zolile M

---

## 📄 License

This project is for educational and portfolio purposes.

```
