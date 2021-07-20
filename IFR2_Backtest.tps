//Author: Sandro Roger Boschetti
//Date: 2021-06-06 (1st version)
//Date: 2021-07-20 (last update)
//This is a script written in Pine Script for Tradingview website intended
//for IFR2 backtesting. This code IS NOT FINISHED yet and may containg errors.

//@version=4
study("SrB - IFR2 Backtest", overlay=false)

defaultNumOfYears = 5
totalNumYears = input(title="Number of Years", type=input.integer, defval=defaultNumOfYears)

defaultRSIperiod = 2
rsiPeriod = input(title="RSI Period", type=input.integer, defval=defaultRSIperiod)

defaultRSIvalue = 25
rsiValue = input(title="RSI Value", type=input.integer, defval=defaultRSIvalue)

var bought = false
var timeElapsed = 0
var buyPrice = 0.00
var n = 0
var profit = 0.00
var profitAccum = 0.00
var factor = 1.0

m_rsi = rsi(close, rsiPeriod)

//Date to start off
dateBegin = timestamp(year(timenow)-totalNumYears,month(timenow),dayofmonth(timenow),hour(timenow),minute(timenow))
timePeriod = time >= dateBegin

//Buy
if ((not bought) and (m_rsi < rsiValue) and timePeriod)
    bought := true
    buyPrice := close
    n := n + 1

//Get the highet high of 2 bars from "[1]" the last but one. (Máxima dos dois candles sem contar o atual)
hh = highest(2)[1]

//Sell
if (bought and (high>=hh))
    profit := (hh / buyPrice) - 1
    profitAccum := profitAccum + profit
    factor := factor * hh / buyPrice
    bought := false
    buyPrice := 0.00
    timeElapsed := 0

//Sell
if (bought and (timeElapsed>=7))
    profit := (close / buyPrice) - 1
    profitAccum := profitAccum + profit
    factor := factor * close / buyPrice
    bought := false
    buyPrice := 0.00
    timeElapsed := 0

if bought
    timeElapsed := timeElapsed + 1

//Está errado!!!
monthlyProfit = (pow(factor, 1.0/(totalNumYears * 12.0)) - 1.0) * 100.0

//sem reaplicar os resultados
plot(profitAccum, color=color.blue)

//reaplicando os resultados
plot(factor, color=color.green)

//rentabilidade mensal em percentual
plot(monthlyProfit, color=color.yellow)


//Reminders:
//label.new(0, high, tostring(high))
//td = (timenow - timestamp(2016,06,06))  / (1000 * 60.0 * 60 * 24 * 365.25)
//Tutorial on Pine Script: https://www.youtube.com/watch?v=VUxQwt5yXx0
//A video on function: https://www.youtube.com/watch?v=x99E3ND-y_o

