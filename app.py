import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sns

# ── Page Config ───────────────────────────────────────────────────────────────
st.set_page_config(page_title="Superstore Analysis", layout="wide")
sns.set_theme(style="whitegrid")

# ── Load Data ─────────────────────────────────────────────────────────────────
@st.cache_data
def load_data():
    return pd.read_csv('data/superstore_cleaned.csv')

store = load_data()

# ── Sidebar Filters ───────────────────────────────────────────────────────────
st.sidebar.header("🔍 Filters")

regions = st.sidebar.multiselect(
    "Region",
    options=store['Region'].unique(),
    default=store['Region'].unique()
)

segments = st.sidebar.multiselect(
    "Segment",
    options=store['Segment'].unique(),
    default=store['Segment'].unique()
)

categories = st.sidebar.multiselect(
    "Category",
    options=store['Category'].unique(),
    default=store['Category'].unique()
)

# ── Apply Filters ─────────────────────────────────────────────────────────────
filtered_df = store[
    (store['Region'].isin(regions)) &
    (store['Segment'].isin(segments)) &
    (store['Category'].isin(categories))
]

# ── Page Title ────────────────────────────────────────────────────────────────
st.title("🛒 Superstore Profitability Analysis")
st.markdown("*Diagnosing why strong sales aren't translating to strong profit*")
st.divider()

# ── Pie Charts ────────────────────────────────────────────────────────────────
st.subheader("Sales Distribution by Category & Sub-Category")

fig, axes = plt.subplots(1, 2, figsize=(16, 7))

category_sales = filtered_df.groupby('Category')['Sales'].sum()
axes[0].pie(category_sales, labels=category_sales.index,
            autopct='%1.1f%%', startangle=90,
            colors=sns.color_palette('Set2', len(category_sales)))
axes[0].set_title('Sales by Category', fontsize=14, fontweight='bold')

subcat_sales = filtered_df.groupby('Sub-Category')['Sales'].sum().sort_values(ascending=False)
axes[1].pie(subcat_sales, labels=subcat_sales.index,
            autopct='%1.1f%%', startangle=90,
            colors=sns.color_palette('tab20', len(subcat_sales)))
axes[1].set_title('Sales by Sub-Category', fontsize=14, fontweight='bold')

plt.tight_layout()
st.pyplot(fig)
plt.close()

# ── Insight ───────────────────────────────────────────────────────────────────
st.info("💡 **Insight:** Technology drives the highest sales share but examine \
whether that translates to proportional profit in the regional analysis below.")