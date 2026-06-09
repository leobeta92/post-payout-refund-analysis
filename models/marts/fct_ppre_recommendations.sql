-- This CTE identifies the vendors with the highest post-payout refund rates and is to be used in the downstream query.
with cte_refunds_gt_75pct as (
with cte_joined as (
  select
    v.vendor_name,
    case
      when datetime_diff(payout_date,refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout,
  from `finance_accounting.fact_refunds` r
  left join `finance_accounting.fact_transactions` t
    on r.transaction_id = t.transaction_id
  left join `finance_accounting.dim_vendors` v
    on v.vendor_id = t.vendor_id
  left join `finance_accounting.fact_payouts` p
    on p.payout_id = t.payout_id
  where extract(quarter from date(purchase_date)) = 3
)
select
  vendor_name,
  round(count(refund_after_payout) / count(*),2) as refund_after_payout_pct
from cte_joined
group by 1
having refund_after_payout_pct >= 0.75
order by refund_after_payout_pct desc
),
-- Adding different scenarios to payout dates if we were to extend payout by 1, 5, and 7 days.
cte_refunds_joined as (
   select
    vendor_name,
    r.transaction_id as transaction_id,
    t.purchase_date as order_date,
    r.refund_date,
    r.amount as refund_amount,
    p.payout_date,
    bank_fee,
    case
      when datetime_diff(payout_date,refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout,
    case
      when datetime_diff(datetime_add(p.payout_date, INTERVAL 1 DAY),refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout_plus_1,    
    case
      when datetime_diff(datetime_add(p.payout_date, INTERVAL 5 DAY),refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout_plus_5,
    case
      when datetime_diff(datetime_add(p.payout_date, INTERVAL 7 DAY),refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout_plus_7,
  from `finance_accounting.fact_refunds` r
  left join `finance_accounting.fact_transactions` t
    on r.transaction_id = t.transaction_id
  left join `finance_accounting.dim_vendors` v
    on v.vendor_id = t.vendor_id
  left join `finance_accounting.fact_payouts` p
    on p.payout_id = t.payout_id
  where extract(quarter from date(purchase_date)) = 3
)


select
  case
    when pct75.refund_after_payout_pct is not null then "Top 15 PPRE Vendor"
    else "Other"
  END as top_15_ppre_vendor,
  -- These calculations will feed into a bar chart graphic that compares current (baseline) post-payout refund rate with projections.
  round(count(refund_after_payout) / count(*),2) as refund_after_payout_pct_current,
  round(count(refund_after_payout_plus_1) / count(*),2) as refund_after_payout_pct_delay_1d,
  round(count(refund_after_payout_plus_5) / count(*),2) as refund_after_payout_pct_delay_5d,
  round(count(refund_after_payout_plus_7) / count(*),2) as refund_after_payout_pct_delay_7d,
from cte_refunds_joined j
left join cte_refunds_gt_75pct pct75
  on j.vendor_name = pct75.vendor_name
group by 1