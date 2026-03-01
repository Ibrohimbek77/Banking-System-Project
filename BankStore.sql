CREATE DATABASE [Banking System Project];
GO
USE [Banking System Project]


--Prewording: Not all the tables are filled up condifering when the project is finished (deadline being literally 10 minutes)
--Main dificulty was handling data generation and insertion


/*
1 customers - done
 branches - done
 Accounts - done
 Transactions - done
 Employees - done
salaries - done
Empl Atte - done
Credit -done
CredTrans - done
Merchants - done
MerT - done
Loan - done
LonaPayments
detectionfraud - done (manually)
*/



CREATE TABLE Customers(
    CustomerID INT IDENTITY(1,1) ,
    FullName VARCHAR(60) NOT NULL,
    DOB DATE NOT NULL, 
    Email VARCHAR(50) DEFAULT 'No email',
    PhoneNumber VARCHAR(20) NOT NULL,
    Address VARCHAR(100) DEFAULT 'No info provided',
    NationalID VARCHAR(14) NOT NULL,
    TaxID VARCHAR(9) NULL,
    EmploymentStatus VARCHAR(20) DEFAULT 'No info provided',
    AnnualIncome DECIMAL(10, 2),
    CreatedAT DATETIME DEFAULT GETDATE(),
    UpdatedAT DATETIME

    CONSTRAINT PK_Customers_CustomerID PRIMARY KEY(CustomerID),
    CONSTRAINT UQ_Customers_NationalID UNIQUE(NationalID),
    CONSTRAINT UQ_Customers_TaxID UNIQUE(TaxID)
    )
    




CREATE TABLE Accounts(
    AccountID INT IDENTITY(1,1),
    CustomerID INT,
    AccountType VARCHAR(30) DEFAULT 'Savings',
    Balance DECIMAL(10,2) NOT NULL,
    Currency VARCHAR(15) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    BranchID INT,
    CreatedDate DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_Accounts_AccountID PRIMARY KEY (AccountID),
    CONSTRAINT FK_Accounts_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Accounts_BranchID FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
)
--here insert code
SELECT * FROM AccountsTemp

INSERT INTO Accounts(CustomerID, AccountType, Balance, Currency, [Status], BranchID, CreatedDate)
SELECT * FROM AccountTemp
--here insert code ends


CREATE TABLE Transactions(
    TransactionID INT IDENTITY(1, 1),
    AccountID INT,
    TransactionType VARCHAR(20) NOT NULL,
    Amount DECIMAL(10, 2),
    Currency VARCHAR(10) NOT NULL,
    [Date] DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Completed',
    ReferenceNo VARCHAR(50),

    CONSTRAINT PK_Transactions_TransactionID PRIMARY KEY(TransactionID),
    CONSTRAINT FK_Transactions_AccountID FOREIGN KEY(AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT UQ_Transactions_ReferenceNo UNIQUE(ReferenceNo),
    CONSTRAINT CK_Transactions_Amount CHECK(Amount >= 0.0)
)

--insert code

SELECT * FROM Accounts

ALTER TABLE Transactions
ALTER COLUMN ReferenceNo VARCHAR(100) 

insert into Transactions(AccountID, TransactionType, Amount, Currency, [Date], [Status], ReferenceNo)
SELECT  AccountID, TransactionType, Amount, Currency, [Date], [Status], ReferenceNo from TransactionsTemp1
UNION ALL
SELECT AccountID, TransactionType, Amount, Currency, [Date], [Status], ReferenceNo from TransactionsTemp2
--imsert code end



CREATE TABLE Branches(
    BranchID INT IDENTITY(1, 1),
    BranchName VARCHAR(80) NOT NULL,
    Address VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    ManagerID INT DEFAULT NULL,
    ContactNumber VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Branches_BranchID PRIMARY KEY(BranchID),
    CONSTRAINT UQ_Branches_BranchName UNIQUE(BranchName)
)


--some uselles coding; now i realize even a generated data needs id even if not used in insertion
SELECT * FROM Branches

ALTER TABLE Branches
DROP CONSTRAINT UQ_Branches_BranchName

SELECT * FROM Branches

INSERT INTO Branches(BranchName, Address, City, [State], Country, ManagerID, ContactNumber)
SELECT * FROM BranchesTemp
--uselles code ends here - well not so useless


CREATE TABLE Employees(
    EmployeeID INT IDENTITY(1, 1),
    BranchID INT,
    FullName VARCHAR(60) NOT NULL,
    Position VARCHAR(30) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    HireDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'On service',

    CONSTRAINT PK_Employees_EmployeeID PRIMARY KEY(EmployeeID),
    CONSTRAINT FK_Employees_BranchID FOREIGN KEY(BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT CK_Employees_Salary CHECK(Salary >= 0.0)
)

--insert 

SELECT * FROM Branches

SELECT * FROM EmployeesTemp1

SELECT * INTO TempShit FROM EmployeesTemp1

ALTER TABLE EmployeesTemp1
DROP COLUMN EmployeeIdTemp

INSERT INTO Employees(BranchID, FullName, [Position], Department, Salary, HireDate,[Status])
SELECT * FROM EmployeesTemp1

SELECT * FROM Employees

--end





CREATE TABLE CreditCards (-- Customer credit card details.
    CardID INT IDENTITY(1, 1),
    CustomerID INT,
    CardNumber VARCHAR(20) NOT NULL, 
    CardType VARCHAR(15) NOT NULL, 
    CVV VARCHAR(4) NOT NULL,
    ExpiryDate VARCHAR(5) NOT NULL,
    Limit DECIMAL(10, 2) NOT NULL, 
    Status VARCHAR(20) DEFAULT 'Active',

    CONSTRAINT PK_CreditCards_CardID PRIMARY KEY(CardID),
    CONSTRAINT UQ_CreditCards_CardNumber UNIQUE(CardNumber),
    CONSTRAINT FK_CreditCards_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)


--s
INSert into CreditCards(CustomerID, CardNumber, CardType, CVV, ExpiryDate, Limit, [Status])
SELECT * FROM CreditCardsTemp

SELECT * FROM CreditCards
--e



CREATE TABLE CreditCardTransactions(-- Logs credit card transactions.
    TransactionID INT IDENTITY(1, 1), 
    CardID INT,
    Merchant VARCHAR(60) NULL, 
    Amount DECIMAL(10, 2) NOT NULL, 
    Currency VARCHAR(15) NOT NULL, 
    [Date] DATETIME DEFAULT GETDATE(), 
    Status VARCHAR(20) DEFAULT 'Completed',

    CONSTRAINT PK_CreditCardTransactions_TransactionID PRIMARY KEY(TransactionID),
    CONSTRAINT FK_CreditCardTransactions_CardID FOREIGN KEY(CardID) REFERENCES CreditCards(CardID)
)

--s

SELECT * FROM CreditCardTransactions

INSERT INTO CreditCardTransactions
SELECT * FROM CreditTrTEmp

--e

CREATE TABLE OnlineBankingUsers(--Customers registered for internet banking.
    UserID INT IDENTITY(1, 1), 
    CustomerID INT,
    Username VARCHAR(60) NOT NULL, 
    PasswordHash VARCHAR(255) NOT NULL, 
    LastLogin DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_OnlineBankingUsers_UserID PRIMARY KEY(UserID),
    CONSTRAINT FK_OnlineBankingUsers_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE BillPayments( --Tracks utility bill payments.
    PaymentID INT IDENTITY(1, 1), 
    CustomerID INT,
    BillerName VARCHAR(60) NOT NULL, 
    Amount DECIMAL(10, 2), 
    [Date] DATETIME DEFAULT GETDATE(), 
    Status VARCHAR(20) DEFAULT 'Completed',

    CONSTRAINT PK_BillPayments_PaymentID PRIMARY KEY(PaymentID),
    CONSTRAINT FK_BillPayments_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_BillPayments_Amount CHECK(Amount >= 0.0)
)

CREATE TABLE MobileBankingTransactions( --Tracks mobile banking activity.
    TransactionID INT IDENTITY(1, 1), 
    CustomerID INT,
    DeviceID VARCHAR(100) NOT NULL, 
    AppVersion VARCHAR(30) NOT NULL, 
    TransactionType VARCHAR(15) NOT NULL, 
    Amount DECIMAL(10, 2), 
    [Date] DATETIME DEFAULT GETDATE(),

    CONSTRAINT PK_MobileBankingTransactions_TransactionID PRIMARY KEY(TransactionID),
    CONSTRAINT FK_MobileBankingTransactions_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_MobileBankingTransactions_Amount CHECK(Amount >= 0.0)
)

CREATE TABLE Loans(-- Stores loan details.
    LoanID INT IDENTITY(1, 1), 
    CustomerID INT,
    LoanType VARCHAR(20) NOT NULL,
    Amount DECIMAL(10, 2), 
    InterestRate DECIMAL(5, 2), 
    StartDate DATE NOT NULL, 
    EndDate DATE NOT NULL, 
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Loans_LoanID PRIMARY KEY(LoanID),
    CONSTRAINT FK_Loans_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_Loans_Amount CHECK(Amount >= 0.0)
)


--s
SELECT * FROM Loans

INSERT INTO Loans(CustomerID, LoanType, Amount, InterestRate, StartDate, EndDate, [Status])
SELECT 725, 'Adjustable', 50067, 7, '2024-02-10', '2028-03-19', 'Active'

--e

CREATE TABLE LoanPayments(
    PaymentID INT IDENTITY(1, 1),
    LoanID INT,
    AmountPaid DECIMAL(10, 2) NOT NULL,
    PaymentDate DATETIME DEFAULT GETDATE(),
    RemainingBalance DECIMAL(10, 2) NOT NULL

    CONSTRAINT PK_LoanPayments_PaymentID PRIMARY KEY(PaymentID),
    CONSTRAINT FK_LoanPayments_LoanID FOREIGN KEY(LoanID) REFERENCES Loans(LoanID),
    CONSTRAINT CK_LoanPayments_AmountPaid CHECK(AmountPaid >= 0.0)
)

CREATE TABLE CreditScores (
    CustomerID INT,
    CreditScore INT,
    UpdatedAt DATETIME 

    CONSTRAINT FK_CreditScores_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE DebtCollection(
    DebtID INT IDENTITY(1, 1),
    CustomerID INT,
    AmountDue DECIMAL(10, 2) NOT NULL,
    DueDate DATETIME DEFAULT GETDATE(),
    CollectorAssigned VARCHAR(60)

    CONSTRAINT PK_DebtCollection_DebtID PRIMARY KEY(DebtID),
    CONSTRAINT FK_DebtCollection_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_DebtCollection_AmountDue CHECK(AmountDue >= 0.0) 
)

CREATE TABLE KYC(
    KYCID INT IDENTITY(1, 1),
    CustomerID INT,
    DocumentType VARCHAR(20) NOT NULL,
    DocumentNumber VARCHAR(30) NOT NULL,--AA1672344
    VerifiedBy VARCHAR(60) NOT NULL

    CONSTRAINT PK_KYC_KYCID PRIMARY KEY(KYCID), 
    CONSTRAINT FK_KYC_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE FraudDetection(
    FraudID INT IDENTITY(1, 1),
    CustomerID INT,
    TransactionID INT NOT NULL,
    RiskLevel VARCHAR(10) NOT NULL,
    ReportedDate DATETIME DEFAULT GETDATE()

    CONSTRAINT PK_FraudDetection_FraudID PRIMARY KEY(FraudID), 
    CONSTRAINT FK_FraudDetection_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE AML_Cases(
    CaseID INT IDENTITY(1, 1),
    CustomerID INT,
    CaseType VARCHAR(40) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    InvestigatorID INT NOT NULL

    CONSTRAINT PK_AML_Cases_CaseID PRIMARY KEY(CaseID)
    CONSTRAINT FK_AML_Cases_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

CREATE TABLE RegulatoryReports(
    ReportID INT IDENTITY(1, 1),
    ReportType VARCHAR(20) NOT NULL,
    SubmissionDate DATE DEFAULT GETDATE()

    CONSTRAINT PK_RegulatoryReports_ReportID PRIMARY KEY(ReportID)
)

CREATE TABLE Departments(
    DepartmentID INT IDENTITY(1, 1),
    DepartmentName VARCHAR(60) NOT NULL,
    ManagerID INT

    CONSTRAINT PK_Departments_DepartmentID PRIMARY KEY(DepartmentID)
)

CREATE TABLE Salaries(
    SalaryID INT IDENTITY(1, 1),
    EmployeeID INT,
    BaseSalary DECIMAL(10, 2) NOT NULL,--check
    Bonus DECIMAL(10, 2) DEFAULT 0.0,
    Deductions DECIMAL(10, 2) DEFAULT 0.0,
    PaymentDate DATE NOT NULL

    CONSTRAINT PK_Salaries_SalaryID PRIMARY KEY(SalaryID),
    CONSTRAINT FK_Salaries_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT CK_Salaries_BaseSalary CHECK(BaseSalary >= 0.0)
)

--start
SELECT * FROM Salaries



insert into Salaries(EmployeeID, BaseSalary, Bonus, Deductions, PaymentDate)
SELECT * FROM SalariesTemp
--end




CREATE TABLE EmployeeAttendance(
    AttendanceID INT IDENTITY(1, 1),
    EmployeeID INT,
    CheckInTime DATETIME NOT NULL,
    CheckOutTime DATETIME NOT NULL,
    TotalHours DECIMAL(5, 2) NOT NULL

    CONSTRAINT PK_EmployeeAttendance_AttendanceID PRIMARY KEY(AttendanceID),
    CONSTRAINT FK_EmployeeAttendance_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT CK_EmployeeAttendance_TotalHours CHECK(TotalHours >= 0.0)
)

--start
INSERT INTO EmployeeAttendance(EmployeeID, CheckInTime, CheckOutTime, TotalHours)
SELECT * FROM AttendTemp

DROP TABLE AttendanceTemp

SELECT * FROM EmployeeAttendance

--end

CREATE TABLE Investments(
    InvestmentID INT IDENTITY(1, 1),
    CustomerID INT,
    InvestmentType VARCHAR(20) NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    ROI DECIMAL(5, 2) NOT NULL,
    MaturityDate DATE NOT NULL

    CONSTRAINT PK_Investments_InvestmentID PRIMARY KEY(InvestmentID),
    CONSTRAINT FK_Investments_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_Investments_Amount CHECK(Amount >= 0.0)
)

CREATE TABLE StockTradingAccounts(
    AccountID INT IDENTITY(1, 1),
    CustomerID INT,
    BrokerageFirm VARCHAR(60) NOT NULL,
    TotalInvested DECIMAL(10, 2) NOT NULL,
    CurrentValue DECIMAL(10, 2) NOT NULL

    CONSTRAINT PK_StockTradingAccounts_AccountID PRIMARY KEY(AccountID),
    CONSTRAINT FK_StockTradingAccounts_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_StockTradingAccounts_TotalInvested CHECK(TotalInvested >= 0.0)
)

CREATE TABLE ForeignExchange(
    FXID INT IDENTITY(1, 1),
    CustomerID INT NOT NULL,
    CurrencyPair VARCHAR(15) NOT NULL,
    ExchangeRate DECIMAL(10, 4) NOT NULL,
    AmountExchanged DECIMAL(10, 2) NOT NULL

    CONSTRAINT PK_ForeignExchange_FXID PRIMARY KEY(FXID),
    CONSTRAINT FK_ForeignExchange_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_ForeignExchange_ExchangeRate CHECK(ExchangeRate >= 0.0),
    CONSTRAINT CK_ForeignExchange_AmountExchanged CHECK(AmountExchanged >= 0.0)
)

CREATE TABLE InsurancePolicies(
    PolicyID INT IDENTITY(1, 1),
    CustomerID INT NOT NULL,
    InsuranceType VARCHAR(40) NOT NULL,
    PremiumAmount DECIMAL(10, 2) NOT NULL,
    CoverageAmount DECIMAL(10, 2) NOT NULL

    CONSTRAINT PK_InsurancePolicies_PolicyID PRIMARY KEY(PolicyID),
    CONSTRAINT FK_InsurancePolicies_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_InsurancePolicies_PremiumAmount CHECK(PremiumAmount >= 0.0),
    CONSTRAINT CK_InsurancePolicies_CoverageAmount CHECK(CoverageAmount >= 0.0)
)

CREATE TABLE Claims(
    ClaimID INT IDENTITY(1, 1),
    PolicyID INT NOT NULL,
    ClaimAmount DECIMAL(10, 2) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FiledDate DATE NOT NULL

    CONSTRAINT PK_Claims_ClaimID PRIMARY KEY(ClaimID),
    CONSTRAINT FK_Claims_PolicyID FOREIGN KEY(PolicyID) REFERENCES InsurancePolicies(PolicyID),
    CONSTRAINT CK_Claims_ClaimAmount CHECK(ClaimAmount >= 0.0)
)

CREATE TABLE UserAccessLogs(
    LogID INT IDENTITY(1, 1),
    UserID INT,
    ActionType VARCHAR(100) NOT NULL,
    Timestamp DATETIME NOT NULL

    CONSTRAINT PK_UserAccessLogs_LogID PRIMARY KEY(LogID)
)

CREATE TABLE CyberSecurityIncidents(
    IncidentID INT IDENTITY(1, 1),
    AffectedSystem VARCHAR(100) NOT NULL,
    ReportedDate DATETIME NOT NULL,
    ResolutionStatus VARCHAR(30) NOT NULL

    CONSTRAINT PK_CyberSecurityIncidents_IncidentID PRIMARY KEY(IncidentID)
)

CREATE TABLE Merchants(
    MerchantID INT IDENTITY(1, 1),
    MerchantName VARCHAR(80) NOT NULL,
    Industry VARCHAR(40) NOT NULL,
    Location VARCHAR(120) NOT NULL,
    CustomerID INT NOT NULL

    CONSTRAINT PK_Merchants_MerchantID PRIMARY KEY(MerchantID),
    CONSTRAINT FK_Merchants_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customers(CustomerID)
)

--s

SELECT * FROM Merchants

INSERT INTO Merchants(MerchantName, Industry, [Location], CustomerID)
SELECT * FROM MercT1

--e

CREATE TABLE MerchantTransactions(
    TransactionID INT IDENTITY(1, 1),
    MerchantID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PaymentMethod VARCHAR(20) NOT NULL,
    Date DATETIME NOT NULL

    CONSTRAINT PK_MerchantTransactions_TransactionID PRIMARY KEY(TransactionID),
    CONSTRAINT FK_MerchantTransactions_MerchantID FOREIGN KEY(MerchantID) REFERENCES Merchants(MerchantID),
    CONSTRAINT CK_MerchantTransactions_Amount CHECK(Amount >= 0.0)
);
--s
SELECT * FROM MerchantTransactions

INSERT INTO MerchantTransactions(MerchantID, Amount, PaymentMethod, [Date])
SELECT * FROM MTT

--e

--KPI-1

SELECT TOP 3 c.CustomerID, c.FullName, SUM(a.Balance) AS TotalBalance
FROM Accounts a
JOIN Customers c ON a.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FullName
ORDER BY TotalBalance DESC

--KPI-2
SELECT c.CustomerID, c.FullName, COUNT(*) AS ActiveLoanCount
FROM Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
WHERE l.Status = 'Active'
GROUP BY c.CustomerID, c.FullName
HAVING COUNT(*) > 1;


--KPI-3


SELECT 
    t.TransactionID,
    t.AccountID,
    a.CustomerID,
    c.FullName,
    t.TransactionType,
    t.Amount,
    t.Currency,
    t.Date        AS TransactionDate,
    t.Status      AS TransactionStatus,
    t.ReferenceNo,
    f.RiskLevel,
    f.ReportedDate
FROM FraudDetection AS f
JOIN Transactions AS t
    ON f.TransactionID = t.TransactionID
JOIN Accounts AS a
    ON t.AccountID = a.AccountID
LEFT JOIN Customers AS c
    ON a.CustomerID = c.CustomerID
ORDER BY f.ReportedDate DESC;

--KPI-4

WITH primary_account AS (
  SELECT CustomerID, BranchID,
         ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY CreatedDate) AS rn
  FROM Accounts
)
SELECT b.BranchID, b.BranchName, SUM(l.Amount) AS TotalLoanAmount
FROM Loans l
JOIN (SELECT CustomerID, BranchID FROM primary_account WHERE rn = 1) pa ON l.CustomerID = pa.CustomerID
JOIN Branches b ON pa.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName
ORDER BY TotalLoanAmount DESC;

--KPI-5

WITH LargeTransactions AS (
    SELECT
        t.TransactionID,
        t.AccountID,
        a.CustomerID,
        t.Amount,
        t.Date AS TransactionDate,
        LAG(t.Date) OVER (
            PARTITION BY a.CustomerID
            ORDER BY t.Date
        ) AS PrevTransactionDate
    FROM Transactions t
    JOIN Accounts a ON t.AccountID = a.AccountID
    WHERE t.Amount > 10000
)
SELECT
    LT.CustomerID,
    c.FullName,
    LT.TransactionID,
    LT.Amount,
    LT.TransactionDate,
    LT.PrevTransactionDate,
    DATEDIFF(MINUTE, LT.PrevTransactionDate, LT.TransactionDate) AS MinutesBetween
FROM LargeTransactions LT
JOIN Customers c ON lt.CustomerID = c.CustomerID
WHERE LT.PrevTransactionDate IS NOT NULL
  AND DATEDIFF(MINUTE, LT.PrevTransactionDate, LT.TransactionDate) <= 60
ORDER BY LT.CustomerID, LT.TransactionDate;



--KPI-6

SELECT
    a.AccountID,
    c.CustomerID,
    c.FullName,
    MAX(t.Date) AS LastTransactionDate
FROM Accounts a
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
GROUP BY a.AccountID, c.CustomerID, c.FullName
HAVING MAX(t.Date) IS NULL            -- never had a transaction
    OR MAX(t.Date) < DATEADD(MONTH, -6, GETDATE())    -- last transaction > 6 months ago
ORDER BY LastTransactionDate;






