# optimizing-inventory-management
EOQ modeling and inventory cost optimization using R and Excel. Includes simulations, Solver validation, and decision support for order quantity strategy.
Optimizing Inventory Management: A Data-Driven Approach

This project focuses on optimizing inventory management for a manufacturing company using Economic Order Quantity (EOQ) modeling and simulation. Implemented in both **R** and **Excel**, it aims to minimize total inventory cost by determining the ideal order quantity and frequency.

---

##  Project Objectives
- Calculate the optimal **EOQ** and number of orders to minimize cost
- Model **total inventory cost** as the sum of ordering and holding costs
- Validate EOQ using Excel Solver
- Run simulations to assess the impact of demand variability

---

##  Techniques Used

### � Part 1: EOQ & Total Cost Modeling
- Defined cost functions using order cost, holding rate, unit price, and demand
- Implemented cost curves and EOQ calculations in both R and Excel
- Verified optimal order quantity using **Excel Solver**

###  Part 2: Monte Carlo Simulation in R
- Simulated demand using **triangular distribution**
- Assessed expected EOQ, total cost, and number of orders across 3000 simulations
- Constructed histograms and confidence intervals (90%–95%)

---

##  Key Insights
- **Optimal EOQ:** ~604 units  
- **Total Cost at EOQ:** ~$10,016  
- Simulation showed **high stability** under fluctuating demand  
- What-if analysis helped visualize cost sensitivity under different cost scenarios

---

## 🛠 Tools Used
- R (`ggplot2`, `dplyr`, `MASS`)
- Microsoft Excel (`Solver`, data tables)
- Statistical modeling & simulation techniques

---

##  Files Included
- `OptimizingInventoryManagement.R` – R script for EOQ modeling and simulation
- `Inventory_Data.xlsx` – Excel-based EOQ calculator and Solver verification
- `Inventory_Management_Report.docx` – Final report with insights and visuals
- `README.md` – Project overview and methodology

---

##  Summary
This project delivers a robust framework for inventory optimization using both deterministic and simulation methods. By integrating R and Excel, it offers flexible, scalable tools for cost-effective inventory decisions in real-world operations.
