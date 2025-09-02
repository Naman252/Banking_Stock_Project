select * from axis_bank;
select * from hdfc_bank;
select * from icici_bank;
select * from kotak_bank;
select * from sbi_bank;

---  # KPI's ----

-- # Compare closing prices of Axis and HDFC on the same date? --

select a.date, a.close, h.close
from axis_bank as a
join hdfc_bank as h on h.date = a.date
order by a.date;

-- # Find days when SBI outperformed ICICI in closing price? 

SELECT s.date, s.close AS sbi_close, i.close AS icici_close
FROM sbi_bank s
JOIN icici_bank i ON s.date = i.date
WHERE s.close > i.close;


 -- # Daily total trades across all banks?
 
SELECT 
    a.date,
    a.no_of_trades AS axis_trades,
    h.no_of_trades AS hdfc_trades,
    i.no_of_trades AS icici_trades,
    k.no_of_trades AS kotak_trades,
    s.no_of_trades AS sbi_trades,
    (a.no_of_trades + h.no_of_trades + i.no_of_trades + k.no_of_trades + s.no_of_trades) AS total_trades
FROM axis_bank AS a
JOIN hdfc_bank AS h ON a.date = h.date
JOIN icici_bank AS i ON i.date = a.date
JOIN kotak_bank AS k ON k.date = a.date
JOIN sbi_bank  AS s ON s.date = a.date
ORDER BY a.date;



-- # . Highest trading volume per bank?

SELECT 'Axis Bank' AS bank, MAX(volume) AS max_volume FROM axis_bank
UNION ALL
SELECT 'HDFC Bank', MAX(volume) FROM hdfc_bank
UNION ALL
SELECT 'SBI Bank', MAX(volume) FROM sbi_bank
UNION ALL
SELECT 'ICICI Bank', MAX(volume) FROM icici_bank
UNION ALL
SELECT 'Kotak Bank', MAX(volume) FROM kotak_bank;


-- #  5. Average open price of all banks on same date?

SELECT 'Axis Bank' AS bank, ROUND(AVG(open), 2) AS avg_open_price FROM axis_bank
UNION ALL
SELECT 'HDFC Bank', ROUND(AVG(open), 2) FROM hdfc_bank
UNION ALL
SELECT 'SBI Bank', ROUND(AVG(open), 2) FROM sbi_bank
UNION ALL
SELECT 'ICICI Bank', ROUND(AVG(open), 2) FROM icici_bank
UNION ALL
SELECT 'Kotak Bank', ROUND(AVG(open), 2) FROM kotak_bank;


-- #Days when HDFC volume was double ICICI volume?

select h.date, h.volume as hdfc_volume, i.volume as icici_volume
from hdfc_bank as h
join icici_bank as i on i.date = h.date
where h.volume >= 2 * i.volume;



-- # Days when all banks closed higher than previous close?

select dayname(a.date) as 'Day', a.date
from axis_bank as a 
JOIN hdfc_bank AS h ON h.date = a.date
JOIN icici_bank AS i ON i.date = a.date
JOIN kotak_bank AS k ON k.date = a.date
JOIN sbi_bank  AS s ON s.date = a.date
where a.close > a.prev_close
and h.close > h.prev_close
and i.close > i.prev_close
and k.close > k.prev_close
and s.close > s.prev_close;


-- # Bank with highest close price on each date?

select a.date, greatest(a.close, h.close, i.close, k.close, s.close) as highest_close
from axis_bank as a 
JOIN hdfc_bank AS h ON h.date = a.date
JOIN icici_bank AS i ON i.date = a.date
JOIN kotak_bank AS k ON k.date = a.date
JOIN sbi_bank  AS s ON s.date = a.date;

-- # Day with maximum trades for each bank?

SELECT date, no_of_trades
FROM axis_bank
WHERE no_of_trades = (SELECT MAX(no_of_trades) FROM axis_bank)
UNION ALL
SELECT date, no_of_trades 
FROM hdfc_bank 
WHERE no_of_trades = (SELECT MAX(no_of_trades) FROM hdfc_bank)
UNION ALL
SELECT date, no_of_trades 
FROM icici_bank 
WHERE no_of_trades = (SELECT MAX(no_of_trades) FROM icici_bank)
UNION ALL
SELECT date, no_of_trades 
FROM kotak_bank 
WHERE no_of_trades = (SELECT MAX(no_of_trades) FROM kotak_bank)
UNION ALL
SELECT date, no_of_trades 
FROM sbi_bank 
WHERE no_of_trades = (SELECT MAX(no_of_trades) FROM sbi_bank);




-- # Trend comparison: which bank had the highest increase in close over entire year?

SELECT 'Axis Bank' AS bank, (MAX(close) - MIN(close)) AS growth FROM axis_bank
UNION ALL
SELECT 'HDFC Bank', (MAX(close) - MIN(close)) FROM hdfc_bank
UNION ALL
SELECT 'SBI Bank', (MAX(close) - MIN(close)) FROM sbi_bank
UNION ALL
SELECT 'ICICI Bank', (MAX(close) - MIN(close)) FROM icici_bank
UNION ALL
SELECT 'Kotak Bank', (MAX(close) - MIN(close)) FROM kotak_bank
ORDER BY growth DESC;


-- # Find the total traded volume for each bank and compare it with the overall market volume using CTE.?

WITH BankVolume AS (
    SELECT 'Axis Bank' AS bank, SUM(volume) AS total_volume FROM axis_bank
    UNION ALL
    SELECT 'HDFC Bank', SUM(volume) FROM hdfc_bank
    UNION ALL
    SELECT 'ICICI Bank', SUM(volume) FROM icici_bank
    UNION ALL
    SELECT 'Kotak Bank', SUM(volume) FROM kotak_bank
    UNION ALL
    SELECT 'SBI Bank', SUM(volume) FROM sbi_bank
),
MarketTotal AS (
    SELECT SUM(total_volume) AS market_volume FROM BankVolume
)
SELECT b.bank, b.total_volume, 
       ROUND((b.total_volume / m.market_volume)*100, 2) AS percentage_share
FROM BankVolume b
CROSS JOIN MarketTotal m;




 
 



