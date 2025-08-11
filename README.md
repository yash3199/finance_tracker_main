# machine_test

A new Flutter project.

## Getting Started

## Idea Prompt 

Create Flutter data models for a personal finance tracker app with hardcoded sample data. The app includes the following features:
1.User authentication model with fields:
id (String)
name (String)
email (String)
password (String)
languagePreference (String)
currencyPreference (String)
onboardingCompleted (bool)
2.Income and expense transaction model with fields:
id (String)
type (String: "income" or "expense")
amount (double)
category (String)
date (DateTime)
description (String, optional)
3.Category model with fields:
id (String)
name (String)
icon (String or IconData)
4.Budget model with fields:
id (String)
categoryId (String)
limit (double)
spent (double)
alertThreshold (double, percentage)
5.Reports data model to represent monthly and yearly spending for charts:
month (String)
totalIncome (double)
totalExpense (double)
categoryBreakdown (List<categorybreakdownitem>) where CategoryBreakdownItem contains:
categoryName (String)
totalAmount (double)
</categorybreakdownitem>
6.Include hardcoded sample data for:
One user profile
At least 5 categories (Food, Rent, Salary, Bills, Shopping)
8-10 transactions spread across categories
3 budgets with spent amounts
Monthly and yearly report examples
All models should have toJson() and fromJson() methods. Make sure the sample data is realistic for testing charts and UI

## prompt 2 
i need charts when i click on monthly and yearly reports with all categorize section and amount

## prompt 3 
use responsive ui for mobile  as well as web and make it look more creative and user friendly with proper theme and color combination.

## prompt 4
getting a render flex overflowed error at main dashboard make it scrollable to avoid that error..

## prompt 5
there is only recent transactions and monthly reports and charts to show expenses are there there is no option to user to add the expenses and search field to search any particular month expenses so create a add button from where the user can add the new expense along with the month selected category and amnount spent and adda serach field at the top of dashboard to search any particular month expenses

## prompt 6
ok i added the transaction by clicking on add button but its not showing in recent transaction on dashboard screen apart from that in monthly report it must show for which particular month this report is for and when user put the month in search field it must filterv the reports or show that reports for particular month user has searched so do the required changes for the same


## screenshots

### Dashboard
![Dashboard](screenshots/dashboard1.png)
![Dashboard](screenshots/dashboard2.png)
![Dashboard](screenshots/dashboard3.png)

### reports
![Reports](screenshots/reportChart.png)

### searchResults
![Search Results](screenshots/searchResult.png)



