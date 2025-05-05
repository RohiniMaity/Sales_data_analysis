
# 📊 Walmart Sales Data Analysis

This project performs data cleaning in **Python** and then conducts a comprehensive **SQL analysis** using **PostgreSQL**. It uncovers insights into sales performance, customer behavior, and store-level metrics from Walmart’s transactional data.

---

## 📁 Project Structure

- `project.ipynb`: Jupyter Notebook with:
  - Data loading and cleaning in **Pandas**
  - Data export to PostgreSQL (optional)
  - Analytical SQL queries using `psycopg2` or `sqlalchemy`
- `Walmart.csv`: Raw transactional dataset (must be present in the same directory)
- `README.md`: Documentation and explanation

---

## 🧼 Data Cleaning Steps (Python)

Using **Pandas**, the dataset is prepared by:
- Loading `Walmart.csv` with `pd.read_csv`
- Checking for duplicates and nulls
- Removing duplicates and missing entries
- Performing initial data profiling with `describe()`, `info()`

Example:
```python
df = pd.read_csv("Walmart.csv")
df.drop_duplicates(inplace=True)
df.dropna(inplace=True)
```

---

## 🛠️ Database Setup (PostgreSQL)

1. Create a database (e.g., `walmart_db`) in PostgreSQL.
2. Import the cleaned data into a table called `walmart`.
3. If using Python to connect:
```python
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

load_dotenv()
engine = create_engine(
    f"postgresql+psycopg2://{os.getenv('POSTGRES_USER')}:{os.getenv('POSTGRES_PASSWORD')}@localhost:{os.getenv('POSTGRES_PORT')}/{os.getenv('POSTGRES_DB')}"
)
```

---

## 🔍 Key Analysis Questions (SQL)

1. **Payment Methods**  
   ➤ How many transactions and items were sold via each method?

2. **Top-Rated Categories**  
   ➤ Which category had the highest average rating per branch?

3. **Busiest Day per Branch**  
   ➤ What’s the most active day of the week for each branch?

4. **Quantity Sold by Payment Type**  
   ➤ How many items were sold using each payment method?

5. **Category Ratings by City**  
   ➤ What are the average, min, and max ratings for each category by city?

6. **Category Profitability**  
   ➤ Which categories bring in the most profit?

7. **Popular Payment Methods by Branch**  
   ➤ What’s the most frequently used payment method at each branch?

8. **Sales by Time of Day**  
   ➤ How does transaction volume vary across shifts (Morning, Afternoon, Evening)?

9. **Revenue Decline YoY**  
   ➤ Which branches had the steepest revenue decline year-over-year?

---

## 📌 Highlights

- Used `RANK() OVER (...)` and `GROUP BY` extensively for aggregations and rankings.
- Converted date strings with `TO_DATE` and extracted week days using `TO_CHAR`.
- Time of day classification using `EXTRACT(HOUR FROM time)`.

---

## 📚 Dependencies

- Python 3.x
- pandas
- sqlalchemy
- psycopg2
- dotenv
- PostgreSQL 12+

Install with:
```bash
pip install pandas sqlalchemy psycopg2-binary python-dotenv
```

---

## 🧠 Learnings

- Handling PostgreSQL’s case sensitivity (e.g., using `"Branch"` vs `branch`)
- Optimizing SQL queries with window functions
- Using Python for efficient pre-processing before SQL analysis

---

## 📄 License

This project is intended for educational and analytical purposes. Feel free to fork, reuse, and expand upon it.
