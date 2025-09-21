import pandas as pd
from sqlalchemy import create_engine

def create_segment(df, group_col, target_col, agg_func, new_column_name, q=4, label=None):
    """
    Create quantile-based segments for a column and map to original DataFrame.
    """
    grouped = df.groupby(group_col)[target_col].agg(agg_func)
    bucket = pd.qcut(grouped, q=q, labels=label)
    df[new_column_name] = df[group_col].map(bucket)

def main():
    # -------------------------
    # Load raw data
    # -------------------------
    file = "/Users/ramilojr.subiate/Documents/FILES/etl-to-dashboard/kaggle_data/sales_transaction.csv"
    df = pd.read_csv(file)
    
    # -------------------------
    # Rename columns for consistency
    # -------------------------
    df.rename(columns={
        "TransactionNo": "transaction_num",
        "Date": "date",
        "ProductNo": "product_num",
        "ProductName": "product_name",
        "Price": "price",
        "Quantity": "quantity",
        "CustomerNo": "customer_num",
        "Country": "country"
    }, inplace=True)
    
    # -------------------------
    # Clean data
    # -------------------------
    df.drop_duplicates(inplace=True)
    df.dropna(inplace=True)
    df["date"] = pd.to_datetime(df["date"])
    df["customer_num"] = df["customer_num"].astype("Int64")
    df["product_name"] = df["product_name"].str.lower().str.strip()
    df["price"] = df["price"].astype(float).round(2)
    
    # -------------------------
    # Handle cancelled transactions
    # -------------------------
    df["no_C_transaction_num"] = df["transaction_num"].str.replace("C", "", regex=False)
    df["abs_quantity"] = df["quantity"].abs()
    
    columns_to_identify_cancel_pairs = ["product_name", "price", "customer_num", "abs_quantity", "no_C_transaction_num"]
    dup_mask = df.duplicated(subset=columns_to_identify_cancel_pairs, keep=False)
    df_cleaned = df[~dup_mask].copy()
    
    # Drop helper columns
    df_cleaned = df_cleaned.drop(columns=["abs_quantity", "no_C_transaction_num"])
    df_cleaned = df_cleaned[df_cleaned["quantity"] > 0].copy()
    
    # -------------------------
    # Feature engineering
    # -------------------------
    # Revenue
    df_cleaned["revenue"] = df_cleaned["price"] * df_cleaned["quantity"]
    
    # Customer frequency segmentation
    create_segment(
        df_cleaned,
        group_col="customer_num",
        target_col="customer_num",
        agg_func="count",
        new_column_name="customer_frequency",
        label=["least_frequent", "less_frequent", "more_frequent", "most_frequent"]
    )
    
    # Customer contribution segmentation
    create_segment(
        df_cleaned,
        group_col="customer_num",
        target_col="revenue",
        agg_func="sum",
        new_column_name="customer_contribution",
        label=["least_contributor", "less_contributor", "more_contributor", "most_contributor"]
    )
    
    # -------------------------
    # Connect to PostgreSQL / Azure SQL
    # -------------------------
    PGHOST = "rammyserver.postgres.database.azure.com"
    PGUSER = "rammysubiate"
    PGPASSWORD = "data11212*" 
    PGPORT = 5432
    PGDATABASE = "postgres"
    
    engine = create_engine(
        f"postgresql+psycopg2://{PGUSER}:{PGPASSWORD}@{PGHOST}:{PGPORT}/{PGDATABASE}"
    )
    
    # -------------------------
    # Prepare data for SQL export
    # -------------------------
    columns_to_export = [
        "transaction_num",
        "date",
        "product_num",
        "product_name",
        "price",
        "quantity",
        "revenue",
        "customer_num",
        "country",
        "customer_frequency",
        "customer_contribution"
    ]
    df_export = df_cleaned[columns_to_export].copy()
    
    # -------------------------
    # Incremental insert: only new transactions
    # -------------------------
    existing_txn = pd.read_sql("SELECT transaction_num FROM flat_sales", con=engine)
    df_new = df_export[~df_export["transaction_num"].isin(existing_txn["transaction_num"])]
    
    # Insert new rows into SQL
    df_new.to_sql("flat_sales", con=engine, if_exists="append", index=False)
    
    print(f"Export completed! {len(df_new)} new rows added.")

if __name__ == "__main__":
    main()
