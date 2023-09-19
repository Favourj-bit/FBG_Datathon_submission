# FBG_Datathon

This Readme Contains details about Data Science Project and the Data Engineering project.

## Outline

- [FBG\_Datathon](#fbg_datathon)
  - [Outline](#outline)
  - [Data Science Project](#data-science-project)
    - [Introduction](#introduction)
    - [Objectives](#objectives)
    - [Exploratory Data Analysis](#exploratory-data-analysis)
    - [Data Visualization](#data-visualization)
    - [Data Cleaning and Preprocessing](#data-cleaning-and-preprocessing)
    - [Feature Engineering](#feature-engineering)
    - [Data Modelling](#data-modelling)
    - [Evaluation and Conclusion](#evaluation-and-conclusion)
  - [Data Engineering Section](#data-engineering-section)
    - [Overview](#overview)
    - [Data Ingestion](#data-ingestion)
    - [Data Transformation (Data Cleaning):](#data-transformation-data-cleaning)
    - [Data Loading into Facts and Dimension Tables](#data-loading-into-facts-and-dimension-tables)

## Data Science Project

### Introduction

The Fraud Detection dataset is essential for improving the security of our online payment platform by developing a predictive model to detect fraudulent transactions using transaction and user data collected over time.

### Objectives

The objectives and goals of the Fraud Detection project include building an advanced machine learning model to predict fraudulent transactions for real-time decision-making, enhancing platform security to protect customers and the business, building user trust through accurate fraud detection, and improving operational efficiency by automating fraud detection processes.

### Exploratory Data Analysis

In this step, the dataset was loaded using pandas, revealing it had 6 million rows and 30 columns. The team checked for missing values (none were found) and examined dataset statistics for feature distribution. Information on data types and potential empty strings in categorical data was reviewed. Despite the absence of errors, longer processing times were noted due to the dataset's size, especially during loading in Google Colab.

### Data Visualization

In the subsequent steps of exploratory data analysis (EDA), the team examined the original dataset to understand its structure. They began by checking the distribution of the target variable, finding it to be balanced. Following that, they analyzed the distribution of various features in the dataset.

### Data Cleaning and Preprocessing

In this stage, the main steps that were carried out is encoding of the dataset. Label encoding and frequency encoding was used in this step. Frequency encoding was used in order to get the occurrence of the categories present in the columns, this was also a way of creating new features for the dataset. Next, the columns were encoded using label encoding. One Hot encoding was not used because the columns had a lot of distinct categories which allowed the process to take a lot of time in running. Also, on google colab, it kept running out of memory while using pd.get_dummies so we decided to just stick to label encoding which is better because it does not increase the dimensionality of the dataset. Also, one hot encoding created a sparse dataset which had many zeroes when it finally ran on an M1 laptop. These are the errors we faced that allowed us to stick to frequency encoding and label encoding.

### Feature Engineering

In the initial steps of data preprocessing and feature engineering, the team focused on creating meaningful features to enhance fraud detection capabilities. They began by extracting transaction day and hour from the transaction date and time, acknowledging the significance of these time-related features in fraud detection.

To further improve the model, they conducted research and identified key factors affecting fraud detection, including transaction amount, user credit score, IP address, transaction time, and user location. Based on this research, several new features were engineered:

- Unique IP Counts per User: This feature tracks the number of distinct IP addresses associated with each user, aiding in the detection of unusual IP address patterns indicative of fraud.

- Email Domain Frequency: It encodes the frequency of unique email domains in the dataset, offering insights into commonly used email providers for transactions and potential patterns related to specific domains.

- Transaction Velocity: This feature calculates the rate at which a user conducts transactions, identifying high-frequency or rapid transactions that may signal suspicious activity.

- User Fraud History: It represents the cumulative count of fraudulent transactions associated with each user up to a given point, providing a historical perspective on a user's involvement in fraudulent activities.

- User's Credit Score vs. User Income: This feature computes the ratio of a user's credit score to their reported income, highlighting significant discrepancies that could indicate fraudulent behavior.

- Transaction Frequency with Specific Merchants: This feature captures transaction frequency between users and specific merchants, allowing detection of sudden spikes in transactions with new or infrequently visited merchants, which may be suspicious.

These engineered features aim to provide valuable insights and patterns that can enhance the fraud detection model's accuracy and effectiveness.

### Data Modelling

To facilitate model training and evaluation, the dataset was divided into two subsets: a training set, which encompassed 70% of the data, and a test set containing the remaining 30%. This partitioning strategy is a common practice for large datasets like the one in question, which consisted of 6,000,000 samples with 30 features.

In terms of modeling, ensemble methods were employed, specifically focusing on gradient boosting techniques using LightGBM and CatBoost. These powerful algorithms were utilized to develop predictive models for fraud detection.

### Evaluation and Conclusion


In summary, we evaluated our models using F1 and accuracy scores, focusing on the CatBoost model, which achieved an accuracy score of 0.514. However, all models displayed relatively low accuracy. Challenges arose due to the large dataset, leading to manual hyperparameter tuning and recurrent neural network training issues. Downsizing the dataset yielded worse results.

We leveraged feature importance analyses to inform feature selection and iteratively fine-tuned our models. Despite difficulties, this approach aimed to create the best-performing model.


## Data Engineering Section

### Overview

The Data Engineering ETL (Extract, Transform, Load) process for the agricultural monitoring system was designed to convert raw sensor data into structured fact and dimension tables within our Snowflake data warehouse. This transformation aimed to generate organized and actionable information. The ETL process consisted of three key stages: Data Ingestion, Data Transformation (including Data Cleaning), and Data Loading into Facts and Dimension Tables.

### Data Ingestion

In this initial stage, raw sensor data from various sources were collected and ingested into the ETL pipeline. These sources could include sensors placed in fields, weather stations, or other monitoring devices.
Data connectors and pipelines were established to extract data in various formats (e.g., CSV, JSON, IoT protocols) and from different sources.

### Data Transformation (Data Cleaning):

This stage involved cleaning and transforming the raw data to make it suitable for analysis and storage.
Data cleaning processes included handling missing or inconsistent data, removing duplicates, and addressing data quality issues.
Data from different sources were harmonized and standardized to ensure consistency.
Aggregations and calculations might have been performed to derive new metrics or features.
Timestamps and geospatial data could be normalized for uniformity.

### Data Loading into Facts and Dimension Tables

Once the data was transformed and cleaned, it was loaded into structured tables within the Snowflake data warehouse.
The schema typically included Fact tables, which contained the core data for analysis (e.g., sensor readings, crop yields), and Dimension tables that provided context (e.g., location, crop types, weather information).
Proper indexing and partitioning strategies were applied to optimize query performance.
Historical data might be appended to existing tables or stored separately for archival purposes.
The end goal of this ETL process was to provide a structured and organized data repository that enables efficient querying and analysis. This structured data could then be used to generate insights, make informed decisions, and support various applications in the agricultural monitoring system, such as crop management, irrigation optimization, and yield prediction.