# MT4-Libraries
Metatrader libraries of mine, which I used almost in every algo.

Both should be implemented by ```#include``` directive in your trading algorithm.


## Basic Explanation / Usage of Functions 
### Main Library
#### IsNewCandle()    
- Function        : Checks if a new bar exists.
- Purpose         : Generic trigger.
#### CheckOrders(string pair)   
- Function        : Counts existing orders.
- Purpose         : Evaluation of a trade.
#### GetOpenOrderPrices()   
- Function        : Returns order open prices.
- Purpose         : Evaluation of trading ranges.
#### OrderEntry(int direction, double Entry, double SL, double TP)  
- Function        : Create a new order.
- Purpose         : As its name implies.
#### CloseBuys(),CloseSells(),CloseBuyStops(),CloseSellStops(),CloseBuyLimits(),CloseSellLimits()  
- Function        : Close all orders according to its type.
- Purpose         : Flash exits.
#### MoveToBreakeven(),MoveToBreakevenRatio(),MoveToBreakevenAccOrderListener()  
- Function        : A few methods to adjust SL to a breakeven price.
- Purpose         : Secondary exits.
#### AdjustTrail(),TrailingStopRatio(),AdjustTrailAccOrderListener()
- Function        : A few methods to adjust SL to a trailing price.
- Purpose         : Tertiary exits.
#### SLtoDonchian()   
- Function        : Adjust SL according to donchian channels.
- Purpose         : Exit evaluation. 
#### ND()   
- Function        : Normalize double.
- Purpose         : Digit trimming. 
#### NP()   
- Function        : Normalize price.
- Purpose         : Digit trimming of prices. 
#### WriteTradeHistory()  
- Function        : Saves a log of trades.
- Purpose         : System evaluation. 

