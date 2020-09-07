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
#### OrderEntry(int direction, double Entry, double SL, double TP)  
- Function        : Create a new order.
- Purpose         : As its name implies.
#### CloseBuys(),CloseSells(),CloseBuyStops(),CloseSellStops(),CloseBuyLimits(),CloseSellLimits()  
- Function        : Close all orders according to its type.
- Purpose         : Flash exits.
#### OrderEntry(int direction, double Entry, double SL, double TP)  
- Function        : Create a new order.
- Purpose         : As its name implies.
