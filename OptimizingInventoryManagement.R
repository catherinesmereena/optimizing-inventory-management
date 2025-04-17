# To clear the environment
cat("\014") # Clear the console
rm(list = ls()) # Clear the global environment
try(dev.off(dev.list()["RStudioGD"]), silent = TRUE) # Clear plots
try(p_unload(p_loaded(), character.only = TRUE), silent = TRUE) # Clear packages
options(scipen = 100) # Disable scientific notation for the entire R session

library(ggplot2)
library(dplyr)
library(MASS)

############### Part 1 #######################

# Define data and parameters
annual_demand <- 19000 # Define annual demand in units
cost_per_unit <- 123 # Define cost per unit in dollars
holding_rate <- 0.135 # Define holding rate as a decimal (13.5%)
ordering_cost <- 159 # Define ordering cost in dollars per order

# Calculate the holding cost per unit
holding_cost_per_unit <- holding_rate * cost_per_unit

# EOQ Calculation function
calculate_EOQ <- function(annual_demand, ordering_cost, holding_cost_per_unit) {
  sqrt((2 * annual_demand * ordering_cost) / holding_cost_per_unit)
}

# Initial EOQ Calculation
EOQ <- calculate_EOQ(annual_demand, ordering_cost, holding_cost_per_unit)
EOQ <- ceiling(EOQ) # Round EOQ to the nearest whole number

# Cost calculation functions
total_ordering_cost <- function(Q) (annual_demand / Q) * ordering_cost
total_holding_cost <- function(Q) (Q / 2) * holding_cost_per_unit
total_inventory_cost <- function(Q) total_ordering_cost(Q) + total_holding_cost(Q)

# Calculate costs for the EOQ
TOC <- total_ordering_cost(EOQ)
THC <- total_holding_cost(EOQ)
TIC <- total_inventory_cost(EOQ)

# Print the calculated EOQ and total costs
print(paste("Economic Order Quantity (EOQ):", EOQ))
print(paste("Total Ordering Cost:", TOC))
print(paste("Total Holding Cost:", THC))
print(paste("Total Inventory Cost:", TIC))

# Define a range of order quantities for plotting
order_quantities <- seq(100, 2 * EOQ, by = 100)

# Create a data frame with calculated costs for each order quantity
cost_data <- data.frame(Order_Quantity = order_quantities,
                        Total_Cost = sapply(order_quantities, total_inventory_cost))

# Plot Total Cost versus Order Quantity
ggplot(cost_data, aes(x = Order_Quantity, y = Total_Cost)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  labs(title = "Total cost vs Order Quantity",
       x = "Order Quantity (Q)",
       y = "Total Inventory Cost") +
  theme(plot.title = element_text(hjust = 0.5))

############### Part 2 #######################

# Custom function to simulate the triangular distribution
simulate_triangular <- function(n, min, mode, max) {
  u <- runif(n)
  c <- (mode - min) / (max - min)
  q <- u < c
  y <- ifelse(q,
              min + sqrt(u * (max - min) * (mode - min)),
              max - sqrt((1 - u) * (max - min) * (max - mode)))
  return(y)
}

# Simulation parameters
min_demand <- 15000
mode_demand <- 19000
max_demand <- 23000
num_simulations <- 3000

# Simulate demands
simulated_demands <- simulate_triangular(num_simulations, min_demand, mode_demand, max_demand)

simulated_EOQs <- numeric(num_simulations)
simulated_costs <- numeric(num_simulations)
simulated_order_counts <- numeric(num_simulations)

# Function to calculate total inventory cost with order quantity Q and demand D as arguments
total_inventory_cost1 <- function(Q,D) {
  annual_ordering_cost <- (D / Q) * ordering_cost
  annual_holding_cost <- (Q / 2) * holding_cost_per_unit
  TIC <- annual_ordering_cost + annual_holding_cost
  return(TIC)
}

for (i in 1:num_simulations) {
  D_simulated <- simulated_demands[i]
  EOQ_simulated <- calculate_EOQ(D_simulated, ordering_cost, holding_cost_per_unit)
  EOQ_simulated <- ceiling(EOQ_simulated)
  TIC_simulated <- total_inventory_cost1(EOQ_simulated, D_simulated)
  simulated_EOQs[i] <- EOQ_simulated
  simulated_costs[i] <- TIC_simulated
  simulated_order_counts[i] <- D_simulated / EOQ_simulated
}

# Calculate expected values and confidence intervals
expected_min_cost <- mean(simulated_costs)
cost_ci <- t.test(simulated_costs, conf.level = 0.90)$conf.int

expected_EOQ <- mean(simulated_EOQs)
EOQ_ci <- t.test(simulated_EOQs, conf.level = 0.90)$conf.int

expected_annual_orders <- mean(simulated_order_counts)
order_count_ci <- t.test(simulated_order_counts, conf.level = 0.90)$conf.int

cat("Expected Minimum Total Cost:", expected_min_cost, "\n")
cat("90% Confidence Interval for Minimum Total Cost:", paste(round(cost_ci, 2), collapse = " to "), "\n\n")

cat("Expected EOQ:", round(expected_EOQ), "\n")
cat("95% Confidence Interval for EOQ:", paste(round(EOQ_ci, 2), collapse = " to "), "\n\n")

cat("Expected Annual Number of Orders:", round(expected_annual_orders, 2), "\n")
cat("95% Confidence Interval for Annual Number of Orders:", paste(round(order_count_ci, 2), collapse = " to "), "\n")

# Plotting the histogram of the total costs from the simulation
ggplot(data.frame(Total_Costs = simulated_costs), aes(x = Total_Costs)) +
  geom_histogram(binwidth = (max(simulated_costs) - min(simulated_costs)) / 30, fill = "red", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Simulated Total Costs",
       x = "Total Inventory Cost",
       y = "Frequency") +
  theme(plot.title = element_text(hjust = 0.5))

# Plotting the histogram of the EOQs from the simulation
ggplot(data.frame(EOQs = simulated_EOQs), aes(x = EOQs)) +
  geom_histogram(binwidth = (max(simulated_EOQs) - min(simulated_EOQs)) / 30, fill = "violet", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Simulated EOQs",
       x = "Economic Order Quantity (EOQ)",
       y = "Frequency") +
  theme(plot.title = element_text(hjust = 0.5))
# Plotting the histogram of the annual order counts from the simulation
ggplot(data.frame(Order_Counts = simulated_order_counts), aes(x = Order_Counts)) +
  geom_histogram(binwidth = (max(simulated_order_counts) - min(simulated_order_counts)) / 30, fill = "yellow", color = "black") +
  theme_minimal() +
  labs(title = "Histogram of Simulated Annual Order Counts",
       x = "Annual Number of Orders",
       y = "Frequency") +
  theme(plot.title = element_text(hjust = 0.5))
                                                               
