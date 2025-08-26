Fiftyville

Project: CS50x Project – SQL Mystery
Author: Davi Teodoro

Overview

The town of Fiftyville has reported a stolen duck! Your mission is to solve the mystery using only the provided database fiftyville.db.

The goal is to identify:

Who the thief is
The city the thief escaped to
The thief’s accomplice who helped them escape
This project focuses on practicing SQL queries, data analysis, and logical reasoning to uncover the truth.

What it Does

Queries a SQLite database (fiftyville.db) containing tables about:
People, bank accounts, phone calls, and flights
Crime scene reports and bakery security logs
Uses nested queries and common table expressions (CTEs) to piece together the sequence of events.
Logs all queries and reasoning steps in log.sql as evidence of the investigation.
Outputs the final solution in answers.txt.

How to Use

Open the terminal and navigate to the project directory:
cd fiftyville

Test queries directly with SQLite:
sqlite3 fiftyville.db

Execute your SQL scripts to inspect the database and verify results:
cat log.sql | sqlite3 fiftyville.db


Fill in answers.txt with the correct:

Thief’s name
Escape city
Accomplice’s name
Implementation Details
The investigation involves linking multiple tables with joins, subqueries, and CTEs.

Key SQL concepts used:

JOIN, IN, EXISTS
Aggregating and filtering data with WHERE, DISTINCT
Using comments (--) to document the reasoning process in log.sql
The project simulates a real-world data analysis workflow by combining crime reports, financial transactions, phone logs, and flight data.

Learning Outcomes

By completing this project, you will:
Learn to analyze and combine multiple tables in a relational database.
Practice solving a complex real-world problem using SQL.
Develop a logical and systematic approach to data investigation.
Understand the importance of documenting queries and reasoning for reproducibility.

About

This project is part of CS50x — Introduction to Computer Science by Harvard University.

Project by Davi Teodoro
