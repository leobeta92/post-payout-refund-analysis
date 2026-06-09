# post-payout-refund-analysis

This analysis is in response to a request by Accounting to investigate a problem involving customer refunds that are occurring after money has already been paid out to the vendor. This is resulting in negative cash flows as money now needs to be recovered through future payouts to existing vendors. The accounting team asked: "What percentage of our refund volume is happening after the money has already left our bank account?"

Provided were fact tables of refunds, payouts, and transactions. A dimensions table was provided with vendor information. Source data not included in this repository. SQL models were developed against fact and dimension tables provided as part of the assignment. Since source files were provided as fact and dim tables, staging was omitted from folder structure since no standardization or cleaning needed to be done for downstream analysis.

## Project Structure

```
post_payout_refund_analysis/
├── models/
│   └── marts/
│       ├── fct_post_payout_refund_exposure.sql
│       └── fct_ppre_recommendations.sql
└── analysis/
    └── eda.sql
```

## Report
A full executive summary prepared for the stakeholder is available [here](https://drive.google.com/file/d/1XydEj3ZqQq5acLPnAKf_2PokZJY9EPG9/view?usp=drive_link).

Key findings include:
- 68% of total refunds to customers are requested after the payout was already paid to the vendor (PPRR = post-payout refund rate).
  - This amounted to $1,173 USD in unrecoverable bank fees, and $34,456 USD in cash that needs to be credited from future payouts to corresponding vendors.
- Refund requests from email orders had a 93% chance of occurring after payout was made to the vendor.
- This behavior is concentrated among certain vendors. The PPRR ranges from 38% to 90% among vendors. The 15 vendors with the highest PPRR show an average of 80%, while the remaining 25 have an average of 59%.


## Dashboard
An interactive dashboard that shows post-payout refund rate by vendor and marketing channel is available [here](https://datastudio.google.com/reporting/0e15439f-6fce-4626-8735-cd9371416df5).
