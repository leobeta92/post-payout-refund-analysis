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
