-- INITIAL DATA ANALYSIS

/*
All values are distinct. There are 40 distinct vendors.
*/

-- Checking distinct values
select
count(*),
count (distinct transaction_id) as distinct_ids
from `finance_accounting.fact_transactions`;

select
count(*),
count (distinct payout_id) as distinct_ids
from `finance_accounting.fact_payouts`;

select
count(*),
count (distinct refund_id) as distinct_ids
from `finance_accounting.fact_refunds`;

select
count(*),
count (distinct vendor_id) as distinct_ids
from `finance_accounting.dim_vendors`;


/* 
How many transactions haven't been paid out yet?

So far: 279 haven't been paid out.
*/

select
count(*) as null_values
from `finance_accounting.fact_transactions`
where payout_id is null;



-- What are the date ranges of the payouts, transactions, and refunds?

select
min(purchase_date) as min_date,
max(purchase_date) as max_date
from `finance_accounting.fact_transactions`;

select
min(payout_date) as min_date,
max(payout_date) as max_date
from `finance_accounting.fact_payouts`;

select
min(refund_date) as min_date,
max(refund_date) as max_date
from `finance_accounting.fact_refunds`;

-- Looking at samples of datasets

select
*
from `finance_accounting.fact_transactions`
limit 10;

select
*
from `finance_accounting.fact_payouts`
limit 10;

select
*
from `finance_accounting.fact_refunds`
limit 10;

select
*
from `finance_accounting.dim_vendors`
limit 10;
