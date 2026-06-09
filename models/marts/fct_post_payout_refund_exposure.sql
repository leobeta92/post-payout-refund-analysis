-- This CTE identifies the vendors with the highest post-payout refund rates and is to be used in the downstream query.
with cte_refunds_gt_75pct as (
with cte_refunds_joined as (
  select
    v.vendor_name,
    -- Creating a case statement for just post-payout refunds. The query that references this CTE will calculate a proportion of the non-null values of this column versus the overall number of refunds.
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
    -- Only looking at Q3 information.
  where extract(quarter from date(purchase_date)) = 3
)
select
  vendor_name,
  -- This calculates the post-payout refund rate, and the HAVING statement will only include the vendors with a value over 75%.
  round(count(refund_after_payout) / count(*),2) as refund_after_payout_pct
from cte_refunds_joined
group by 1
having refund_after_payout_pct >= 0.75
order by refund_after_payout_pct desc
)
-- For dashboard, will add more dimensions than needed for the question. However, this dashboard is meant to include marketing channel, vendor, gateway information, refund reason, and more. Additional visualizations can be made on top of what has been created in Data Studio. 
   select
    r.refund_id as refund_id,
    case
      when payout_date is null then "Not Yet Paid"
    END as not_yet_paid,
    -- The calculation for the post-payout refund rate will occur in Data Studio.
    case
      when datetime_diff(payout_date,refund_date,minute) < 0 then "Refunded After Payout"
    END as refund_after_payout,
    case
      when datetime_diff(payout_date,refund_date,minute) > 0 then "Refunded Before Payout"
    END as refund_before_payout,
    r.transaction_id as transaction_id,
    t.purchase_date as order_date,
    r.refund_date,
    p.payout_date,
    case
      when pct75.refund_after_payout_pct is not null then "Top 15 PPRE Vendor"
      Else "Others"
    END as top_post_payout_vendor,
    r.refund_reason,
    r.amount as refund_amount,
    t.payment_gateway,
    v.vendor_name,
    v.risk_score,
    t.marketing_channel,
    p.status as payout_status,
    p.bank_fee as payout_bank_fee,
  from `finance_accounting.fact_refunds` r
  left join `finance_accounting.fact_transactions` t
    on r.transaction_id = t.transaction_id
  left join `finance_accounting.dim_vendors` v
    on v.vendor_id = t.vendor_id
  left join `finance_accounting.fact_payouts` p
    on p.payout_id = t.payout_id
  left join cte_refunds_gt_75pct pct75
    on pct75.vendor_name = v.vendor_name
    -- Only looking at Q3 information.
  where extract(quarter from date(purchase_date)) = 3