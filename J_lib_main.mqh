#property copyright "Copyright 2019, janusquadrifrons"

////////////// universal variables  /////////////////////////////////

   extern double LotSize=1;  
   double   pips;
   int      MagicNumber=1555;
   int      err;
   double Last_Buy_BetterPrice_Difference = 0; double Last_Buy_Revised_SL = 0; double Last_Sell_BetterPrice_Difference = 0; double Last_Sell_Revised_SL = 0; // --- listener
   double Last_Buy_BestPrice_Difference = 0; double Last_Sell_BestPrice_Difference = 0; // --- listener
   double Max_Buy_Price_Difference = 0; double Max_Sell_Price_Difference = 0;    // --- listener
   double Mean_Buy_Price_Difference = 0; double Mean_Sell_Price_Difference =0;   // --- listener

////////////// to seek a new candle ///////////////////////////////// 

   bool IsNewCandle () 
   {
      static int BarsOnChart=0;
      if(Bars==BarsOnChart) 
      return(false);
      BarsOnChart=Bars;
      return(true);
   }

////////////// counting open orders ///////////////////////////////// 

   int      totalbuys=0;
   int      totalsells=0;
   int      totalbuystops=0;
   int      totalsellstops=0;
   int      totalbuylimits=0;
   int      totalselllimits=0;
   int      totalopenorders=0;
   int      totalopenpositions=0;

   void CheckOrders(string pair)
   {
      totalbuys      =  0;
      totalsells     =  0;
      totalbuystops  =  0;
      totalsellstops =  0;
      totalbuylimits =  0;
      totalselllimits=  0;
   
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
            {
            if(OrderSymbol()==pair && OrderType()==OP_BUY)        totalbuys++;
            if(OrderSymbol()==pair && OrderType()==OP_SELL)       totalsells++;
            if(OrderSymbol()==pair && OrderType()==OP_BUYSTOP)    totalbuystops++;
            if(OrderSymbol()==pair && OrderType()==OP_SELLSTOP)   totalsellstops++;
            if(OrderSymbol()==pair && OrderType()==OP_BUYLIMIT)   totalbuylimits++;
            if(OrderSymbol()==pair && OrderType()==OP_SELLLIMIT)  totalselllimits++;
            }
      }

      totalopenorders=totalbuys+totalsells+totalbuystops+totalsellstops+totalbuylimits+totalselllimits;
      totalopenpositions=totalbuys+totalsells;   
   }

////////////// order entry function ///////////////////////////////// 

   void OrderEntry(int direction, double Entry, double SL, double TP) 
   {
   
   int ticket;
   
   if(direction==0)  {ticket =  OrderSend(Symbol(),OP_BUY,LotSize,Entry,3,SL,TP,NULL,MagicNumber,0,Green);
      if(ticket<0)
         {ErrorCounter();}
      }
   if(direction==1)  {ticket = OrderSend(Symbol(),OP_SELL,LotSize,Entry,3,SL,TP,NULL,MagicNumber,0,Green);
      if(ticket<0)
         {ErrorCounter();}
      }
   if(direction==10) {ticket =  OrderSend(Symbol(),OP_BUYSTOP,LotSize,Entry,0,SL,TP,NULL,MagicNumber,40,White);
      if(ticket<0)
         {ErrorCounter();}
      }
   if(direction==11) {ticket = OrderSend(Symbol(),OP_SELLSTOP,LotSize,Entry,0,SL,TP,NULL,MagicNumber,40,White);
      if(ticket<0)
         {ErrorCounter();}
      }
   if(direction==20) {ticket =  OrderSend(Symbol(),OP_BUYLIMIT,LotSize,Entry,0,SL,TP,NULL,MagicNumber,40,White);
      if(ticket<0)
         {ErrorCounter();}
      }
   if(direction==21) {ticket = OrderSend(Symbol(),OP_SELLLIMIT,LotSize,Entry,0,SL,TP,NULL,MagicNumber,40,White);
      if(ticket<0)
         {ErrorCounter();}
      }
   }

////////////// order close function ///////////////////////////////// 

   double   LastBuyClosePrice, LastBuyLimitClosePrice, LastBuyStopClosePrice, 
            LastSellClosePrice, LastSellLimitClosePrice, LastSellStopClosePrice;

   void CloseBuys()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderClose(OrderTicket(),OrderLots(),Bid,3,Red);
                  if(result ==true)    LastBuyClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }
   void CloseSells()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderClose(OrderTicket(),OrderLots(),Ask,3,Red);
                  if(result ==true)    LastSellClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }

   void CloseBuyStops()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUYSTOP && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderDelete(OrderTicket(),Red);
                  if(result ==true)    LastBuyStopClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }
   void CloseSellStops()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELLSTOP && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderDelete(OrderTicket(),Red);
                  if(result ==true)    LastSellStopClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }
   void CloseBuyLimits()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUYLIMIT && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderDelete(OrderTicket(),Red);
                  if(result ==true)    LastBuyLimitClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }
   void CloseSellLimits()
      {
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELLLIMIT && OrderMagicNumber()==MagicNumber)
               {
                  bool result=OrderDelete(OrderTicket(),Red);
                  if(result ==true)    LastSellLimitClosePrice=OrderClosePrice();
                  if(result !=true)    err=GetLastError();Print("Last Error ",err);
               }
         }
      }   
  
      

////////////// move to breakeven function ///////////////////////////
   void MoveToBreakeven()
      {
      for(int b=OrdersTotal()-1; b>=0; b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                  if((Bid-OrderOpenPrice())>(WhenToMoveToBe*pips))
                     if(OrderOpenPrice()>OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PipsToLockIn*pips),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven BUY OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven BUY Order modified successfully."); Last_Buy_Revised_SL = OrderOpenPrice()+(PipsToLockIn*pips);}
                        } 

         }
      for(int s=OrdersTotal()-1; s>=0; s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                  if((OrderOpenPrice()-Ask)>(WhenToMoveToBe*pips))
                     if(OrderOpenPrice()<OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PipsToLockIn*pips),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven SELL OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven SELL Order modified successfully."); Last_Sell_Revised_SL = OrderOpenPrice()-(PipsToLockIn*pips);}
                        } 
         }
      }
////////////// move to breakeven ratio (%) function /////////////////
   void MoveToBreakevenRatio()
      {
      for(int b=OrdersTotal()-1; b>=0; b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                  if(Bid>(OrderOpenPrice()*(1+MoveToBreakevenRatio_TriggerRatio)))
                     if(OrderOpenPrice()>OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),(ND(Bid-((Bid-OrderOpenPrice())*MoveToBreakevenRatio_RatioToLockIn))),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven BUY OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven BUY Order modified successfully."); Last_Buy_Revised_SL = OrderOpenPrice()+(PipsToLockIn*pips);}
                        } 

         }
      for(int s=OrdersTotal()-1; s>=0; s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                  if(Ask<(OrderOpenPrice()*(1-MoveToBreakevenRatio_TriggerRatio)))
                     if(OrderOpenPrice()<OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),(ND(Ask+((OrderOpenPrice()-Ask)*MoveToBreakevenRatio_RatioToLockIn))),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven SELL OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven SELL Order modified successfully."); Last_Sell_Revised_SL = OrderOpenPrice()-(PipsToLockIn*pips);}
                        } 
         }
      }
      
////////////// move to breakeven acc to order listener //////////////
   void MoveToBreakevenAccOrderListener()
      {
      for(int b=OrdersTotal()-1; b>=0; b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                  //if((Bid-OrderOpenPrice())>(WhenToMoveToBe*pips)) // --- orjinal ifade
                  if( Bid > buy_MtB_trigger )
                     if(OrderOpenPrice()>OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+(PipsToLockIn_AOL*pips),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven BUY OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven BUY Order modified successfully."); Last_Buy_Revised_SL = OrderOpenPrice()+(PipsToLockIn*pips);}
                        } 

         }
      for(int s=OrdersTotal()-1; s>=0; s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                  //if((OrderOpenPrice()-Ask)>(WhenToMoveToBe*pips)) // --- orjinal ifade
                  if(Ask < sell_MtB_trigger )
                     if(OrderOpenPrice()<OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-(PipsToLockIn_AOL*pips),OrderTakeProfit(),0,clrYellow);
                        if(res!=true)  {Print("Error in MoveToBreakEven SELL OrderModify. Error code=",GetLastError());} 
                        else           {Print("MoveToBreakEven SELL Order modified successfully."); Last_Sell_Revised_SL = OrderOpenPrice()-(PipsToLockIn*pips);}
                        } 
         }
      }


////////////// adjust trailing stop  ////////////////////////////////
   void AdjustTrail()
      {
      for(int b=OrdersTotal()-1;b>=0;b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                     if((Bid-OrderOpenPrice())>(WhenToTrail*pips))
                        if(OrderStopLoss()<(Bid-(TrailAmount*pips)) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(pips*TrailAmount),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) { Print("Error in Adjust Trail BUY OrderModify. Error code=",GetLastError()); } 
                           else { Print("Adjust Trail BUY Order modified successfully."); Last_Buy_Revised_SL = Bid-(pips*TrailAmount);}
                           } 
         }
      for(int s=OrdersTotal()-1;s>=0;s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                     if((OrderOpenPrice()-Ask)>(WhenToTrail*pips))
                        if(OrderStopLoss()>(Ask+(TrailAmount*pips)) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(pips*TrailAmount),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) { Print("Error in Adjust Trail SELL OrderModify. Error code=",GetLastError()); }
                           else { Print("Adjust Trail SELL Order modified successfully."); Last_Sell_Revised_SL = Ask+(pips*TrailAmount);}
                           } 
         }
      } 
////////////// adjust trailing stop ratio (%) function  /////////////
   void TrailingStopRatio()
      {
      for(int b=OrdersTotal()-1;b>=0;b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                     if(Bid>(OrderOpenPrice()*(1+TrailingStopRatio_TriggerRatio)))
                        if(OrderStopLoss()<ND(Bid-((Bid-OrderOpenPrice())*TrailingStopRatio_RatioToLockIn)) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),(ND(Bid-((Bid-OrderOpenPrice())*TrailingStopRatio_RatioToLockIn))),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) Print("Error in Adjust Trail BUY OrderModify. Error code=",GetLastError()); 
                           else Print("Adjust Trail BUY Order modified successfully.");
                           } 
         }
      for(int s=OrdersTotal()-1;s>=0;s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                     if(Ask<(OrderOpenPrice()*(1-TrailingStopRatio_TriggerRatio)))
                        if(OrderStopLoss()>(ND(Ask+((OrderOpenPrice()-Ask)*TrailingStopRatio_RatioToLockIn))) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),(ND(Ask+((OrderOpenPrice()-Ask)*TrailingStopRatio_RatioToLockIn))),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) Print("Error in Adjust Trail SELL OrderModify. Error code=",GetLastError()); 
                           else Print("Adjust Trail SELL Order modified successfully.");
                           } 
         }
      } 

////////////// adjust trailing stop acc to order listener ////////////////////////////////
   void AdjustTrailAccOrderListener()
      {
      for(int b=OrdersTotal()-1;b>=0;b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                     //if((Bid-OrderOpenPrice())>(WhenToTrail*pips)) // --- orjinal ifade
                     if( Bid > buy_MtB_trigger + (WhenToTrail*pips))
                        if(OrderStopLoss()<(Bid-(last_buy_BB_distance)) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-(last_buy_BB_distance),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) { Print("Error in Adjust Trail BUY OrderModify. Error code=",GetLastError()); } 
                           else { Print("Adjust Trail BUY Order modified successfully."); Last_Buy_Revised_SL = Bid-(BB_distance);}
                           } 
         }
      for(int s=OrdersTotal()-1;s>=0;s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                     //if((OrderOpenPrice()-Ask)>(WhenToTrail*pips)) // --- orjinal ifade
                     if( Ask < sell_MtB_trigger - (WhenToTrail*pips))
                        if(OrderStopLoss()>(Ask+(last_sell_BB_distance)) || OrderStopLoss()==0)
                           {
                           bool res=OrderModify(OrderTicket(),OrderOpenPrice(),Ask+(last_sell_BB_distance),OrderTakeProfit(),0,clrWhite);
                           if(res!=true) { Print("Error in Adjust Trail SELL OrderModify. Error code=",GetLastError()); }
                           else { Print("Adjust Trail SELL Order modified successfully."); Last_Sell_Revised_SL = Ask+(BB_distance);}
                           } 
         }
      } 
      
////////////// get open order prices ////////////////////////////////

   double   BuyTPPrice, BuySLPrice, LastBuyEntryPrice, 
            SellTPPrice, SellSLPrice, LastSellEntryPrice;
   double BuyStart, SellStart;
   double AllowedBuyStartPrice, AllowedSellStartPrice;

   void GetOpenOrderPrices()
   {
      if(totalbuys>0)
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
               {
               BuyTPPrice=OrderTakeProfit();
               BuySLPrice=OrderStopLoss();
               LastBuyEntryPrice=OrderOpenPrice(); 
                  /*Print("LastBuyPrice : " ,LastBuyEntryPrice);*/
               if(OrderOpenPrice()<AllowedBuyStartPrice) AllowedBuyStartPrice=OrderOpenPrice();
               }
         }
      
      if(totalsells>0)
      for(int i=OrdersTotal()-1;i>=0;i--)
         {
         if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
            if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
               {
               SellSLPrice=OrderStopLoss();
               SellTPPrice=OrderTakeProfit();
               LastSellEntryPrice=OrderOpenPrice(); 
                  /*Print("LastSellPrice : " ,LastSellEntryPrice);*/
               if(OrderOpenPrice()>AllowedSellStartPrice) AllowedSellStartPrice=OrderOpenPrice();
               }
         }
   }

////////////// normalize double      ////////////////////////////////
   double ND(double val)
      {
      return(NormalizeDouble(val, Digits));
      }
////////////// normalize price      ////////////////////////////////
   double NP(const double price,string symbol=NULL)
   {
      if(price<0.0) return(0.0);
      if(symbol==NULL || symbol=="") symbol=_Symbol;
      double tickSize=SymbolInfoDouble(symbol,SYMBOL_TRADE_TICK_SIZE);
      return(round(price/tickSize)*tickSize);
   }
////////////// SL to donchian        ////////////////////////////////
   void SLtoDonchian()
   {
      for(int b=OrdersTotal()-1; b>=0; b--)
         {
         if(OrderSelect(b,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_BUY)
                  if(OrderSymbol()==Symbol())
                  //if((Bid-OrderOpenPrice())>(WhenToMoveToBe*pips))
                     //if(OrderOpenPrice()>OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),LastBuyEntryPrice,OrderTakeProfit(),0,clrYellow);
                        if(res!=true) Print("Error in SLtoDonchian BUY OrderModify. Error code=",GetLastError()); 
                        else Print("SLtoDonchian BUY Order modified successfully.");
                        } 

         }
      for(int s=OrdersTotal()-1; s>=0; s--)
         {
         if(OrderSelect(s,SELECT_BY_POS,MODE_TRADES))
            if(OrderMagicNumber()==MagicNumber)
               if(OrderType()==OP_SELL)
                  if(OrderSymbol()==Symbol())
                  //if((OrderOpenPrice()-Ask)>(WhenToMoveToBe*pips))
                     //if(OrderOpenPrice()<OrderStopLoss() || OrderStopLoss()==0)
                        {
                        bool res=OrderModify(OrderTicket(),OrderOpenPrice(),LastSellEntryPrice,OrderTakeProfit(),0,clrYellow);
                        if(res!=true) Print("Error in SLtoDonchian SELL OrderModify. Error code=",GetLastError()); 
                        else Print("SLtoDonchian SELL Order modified successfully.");
                        } 
         }
   }
////////////// MM - Kelly Criterion  ////////////////////////////////
////////////// ACC - WriteTradeHistory  /////////////////////////////

   string header01 = TimeToString(__DATE__,TIME_DATE);   //Compilation date called
   string header02 = Symbol();
   string header03 = IntegerToString(Period()); 
   string header04 = WindowExpertName();
   
   string FileToSaveTo = StringConcatenate(header01,"_",header02,"_",header03,"_",header04); // File name to use to save the history data
   
   void WriteTradeHistory()
   {

      int handle = FileOpen(FileToSaveTo+".csv",FILE_CSV|FILE_WRITE);
      if (handle!=INVALID_HANDLE) 
      {
         #define _del ";"
         FileWrite(handle,
            "Ticket"          +_del+
            "Open Time"       +_del+
            "Type"            +_del+
            "Lots"            +_del+
            "Symbol"          +_del+
            "Open Price"      +_del+
            "SL"              +_del+
            "TP"              +_del+
            "Close Time"      +_del+
            "Close Price"     +_del+
            "Commission"      +_del+
            "Swap "           +_del+
            "Profit"          +_del+
            "bar count"       +_del+
            "HPR"             +_del+
            "Highest Seen"    +_del+
            "Lowest Seen"     +_del+
            "MFE"             +_del+
            "MAE"             +_del+
            "TotEff"          +_del+
            "EntEff"          +_del+
            "ExEff"           +_del+
            "Start DD"        +_del+
            "End DD"          +_del+
            "Comment"         +_del+
            "MA 55 Slope"     +_del+
            "ADX(14)"         +_del+
            "ADX(14)+"        +_del+
            "ADX(14)-");

         int saved=0;   
         for(int i=OrdersHistoryTotal()-1; i>=0; i--)
         {
            if (!OrderSelect(i, SELECT_BY_POS,MODE_HISTORY)) continue;

            int orderclosebarindex=iBarShift(NULL,0,OrderCloseTime());

            int orderbars=Bars(NULL,0,OrderOpenTime(),OrderCloseTime()); //--- order kaç bar sürdü

               orderbars=orderbars+1; //--- 0 dan başladığı için düzeltme

            int type = OrderType();

            //---- calculate profit in percent
                  if(type==OP_BUY) 
                     {double longprofitpercent=(OrderClosePrice()-OrderOpenPrice())/OrderOpenPrice();
                        HPR=1+longprofitpercent;}
                  if(type==OP_SELL) 
                     {double shortprofitpercent=(OrderOpenPrice()-OrderClosePrice())/OrderOpenPrice();
                        HPR=1+shortprofitpercent;}
            //---- calculate highestprice, lowestprice, MFE(profit), MAE(loss) during an open position
                  double highestprice,lowestprice,MFE,MAE;
                  int highestbar, lowestbar;

                  if(type==OP_BUY || type==OP_SELL) 
                     {  
                        highestbar  =  iHighest(NULL,0,MODE_HIGH,orderbars,orderclosebarindex);
                        lowestbar   =  iLowest(NULL,0,MODE_LOW,orderbars,orderclosebarindex);
                        highestprice  =High[highestbar];
                        lowestprice   =Low[lowestbar];
                     }
                  
                  if(type==OP_BUY)
                     {
                        MFE   = highestprice/OrderOpenPrice();
                        MAE   = lowestprice/OrderOpenPrice();
                     }
                  if(type==OP_SELL)
                     {
                        MFE   = 1/(lowestprice/OrderOpenPrice());
                        MAE   = 1/(highestprice/OrderOpenPrice());
                     }
            //---- calculate efficiencies : TotEff : Total && EntEff : Entry && ExEff : Exit
                  double TotEff, EntEff, ExEff;
                  
                  if(type==OP_BUY)
                     {
                        TotEff   = (OrderClosePrice()-OrderOpenPrice()) / (highestprice-lowestprice); 
                        EntEff   = (highestprice-OrderOpenPrice())      / (highestprice-lowestprice);
                        ExEff    = (OrderClosePrice()-lowestprice)      / (highestprice-lowestprice);
                     }
                  if(type==OP_SELL)
                     {
                        TotEff   = (OrderOpenPrice()-OrderClosePrice()) / (highestprice-lowestprice);
                        EntEff   = (OrderOpenPrice()-lowestprice)       / (highestprice-lowestprice);
                        ExEff    = (highestprice - OrderClosePrice())   / (highestprice-lowestprice);
                     }
            //---- calculate drawdowns : StDD, EnDD
                  int StDDbar,EnDDbar;
                  double StDD, EnDD, StDDprice, EnDDprice;

                  if(type==OP_BUY || type==OP_SELL)
                     {
                        int halfoforderbars=orderbars/2;
                        int halfoforderbarsindex=orderclosebarindex-halfoforderbars;

                        StDDbar   =  iLowest(NULL,0,MODE_LOW,halfoforderbars,halfoforderbarsindex);
                        EnDDbar   =  iLowest(NULL,0,MODE_LOW,halfoforderbars,orderclosebarindex);

                        StDDprice  =  Low[StDDbar];
                        EnDDprice  =  Low[EnDDbar];

                        StDD  =  1-(StDDprice/OrderOpenPrice());
                        EnDD  =  1-(EnDDprice/OrderOpenPrice());
                     }
            //---- calculate indicator value : MA 55 slope
                  datetime ordertime = OrderOpenTime();
                  int order_barindex = iBarShift(header02,0,ordertime);

                  double ma_55_1 = iMA(NULL,0,55,0,MODE_SMA,PRICE_CLOSE,order_barindex);
                  double ma_55_2 = iMA(NULL,0,55,0,MODE_SMA,PRICE_CLOSE,order_barindex+1);
                  double MA_55_Slope = ma_55_1 - ma_55_2;
            //---- calculate indicator value : ADX(14)
                  double adxMAIN_1=iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,order_barindex);
                  //double adxMAIN_2=iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,order_barindex+1);
                  //double adxMAIN_3=iADX(NULL,0,14,PRICE_CLOSE,MODE_MAIN,order_barindex+2);

                  double adxPLUS_1=iADX(NULL,0,14,PRICE_CLOSE,MODE_PLUSDI,order_barindex);
                  //double adxPLUS_2=iADX(NULL,0,14,PRICE_CLOSE,MODE_PLUSDI,order_barindex+1);

                  double adxMINUS_1=iADX(NULL,0,14,PRICE_CLOSE,MODE_MINUSDI,order_barindex);
                  //double adxMINUS_2=iADX(NULL,0,14,PRICE_CLOSE,MODE_MINUSDI,order_barindex+1);


               switch(type)
               {
                  case OP_BUY  :
                  case OP_SELL :
                           #define _dts(_arg) TimeToString(_arg,TIME_DATE|TIME_MINUTES)
                           #define _prs(_arg) DoubleToString(_arg,(int)MarketInfo(OrderSymbol(),MODE_DIGITS))
                           #define _lts(_arg) DoubleToString(_arg,2)
                           #define _del ";"
                           saved++;
                           FileWrite(handle,(string)OrderTicket()       +_del+
                                          _dts(OrderOpenTime())       +_del+
                                          (type==OP_SELL?"Sell":"Buy")+_del+
                                          _lts(OrderLots())           +_del+
                                          OrderSymbol()               +_del+
                                          _prs(OrderOpenPrice())      +_del+
                                          _prs(OrderStopLoss())       +_del+
                                          _prs(OrderTakeProfit())     +_del+
                                          _dts(OrderCloseTime())      +_del+
                                          _prs(OrderClosePrice())     +_del+
                                          _prs(OrderCommission())     +_del+
                                          _prs(OrderSwap())           +_del+
                                          _prs(OrderProfit())         +_del+
                                          orderbars                   +_del+
                                          _prs(HPR)                   +_del+
                                          highestprice                +_del+
                                          lowestprice                 +_del+
                                          MFE                         +_del+
                                          MAE                         +_del+
                                          TotEff                      +_del+
                                          EntEff                      +_del+   
                                          ExEff                       +_del+
                                          StDD                        +_del+
                                          EnDD                        +_del+
                                          OrderComment()              +_del+        
                                          MA_55_Slope                 +_del+
                                          adxMAIN_1                   +_del+
                                          adxPLUS_1                   +_del+
                                          adxMINUS_1);
               }
         }         
         FileClose(handle); Comment((string)saved+" records saved to "+FileToSaveTo+".csv file");
      }
      return;
   }

////////////// ACC - ErrorCounter  /////////////////////////////
   int numberoferror130=0;
   int numberoferror131=0;

   void ErrorCounter()
      {
         int LastErrorNumber=GetLastError();

         if(LastErrorNumber==130) numberoferror130++;
         if(LastErrorNumber==131) numberoferror131++;
      }

////////////// order listener  /////////////////////////////////
   void Listener_TP()
   {
      // --- order mevcutsa
      if(totalbuys>0 && Last_Buy_BestPrice_Difference > 0) 
         {  
            Mean_Buy_Price_Difference = (Mean_Buy_Price_Difference + Last_Buy_BestPrice_Difference)/OrdersHistoryTotal(); // --- ortalama en iyi fiyat
            Last_Buy_BetterPrice_Difference = 0; Last_Buy_BestPrice_Difference = 0; // --- değerleri sıfırla
         }
      if(totalsells>0 && Last_Sell_BestPrice_Difference>0)
         { 
            Mean_Sell_Price_Difference = (Mean_Sell_Price_Difference + Last_Sell_BestPrice_Difference)/OrdersHistoryTotal(); // --- ortalama en iyi fiyat
            Last_Sell_BetterPrice_Difference = 0; Last_Sell_BestPrice_Difference =0;
         }

      if(OrderSelect(OrdersHistoryTotal()-1, SELECT_BY_POS, MODE_HISTORY == true))
      {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==MagicNumber)
         {
            // --- for buy order
            if(OrderType()==OP_BUY && OrderClosePrice()>=OrderTakeProfit() && totalbuys==0)
            {
               if(Low[1]>Last_Buy_Revised_SL && High[1]>OrderTakeProfit())
               {
                  Last_Buy_BetterPrice_Difference = (High[1]-OrderClosePrice());
                  
                  if( Last_Buy_BetterPrice_Difference > Last_Buy_BestPrice_Difference ) { Last_Buy_BestPrice_Difference = Last_Buy_BetterPrice_Difference; }
                  if( Last_Buy_BestPrice_Difference > Max_Buy_Price_Difference) { Max_Buy_Price_Difference = Last_Buy_BestPrice_Difference; }
               }
            }
            // --- for sell order
            if(OrderType()==OP_SELL && OrderClosePrice()<=OrderTakeProfit() && totalsells==0)
            {
               if(High[1]<Last_Sell_Revised_SL && Low[1]<OrderTakeProfit())
               {
                  Last_Sell_BetterPrice_Difference = (OrderClosePrice()-Low[1]);

                  if( Last_Sell_BetterPrice_Difference > Last_Sell_BestPrice_Difference ) { Last_Sell_BestPrice_Difference = Last_Sell_BetterPrice_Difference; }
                  if( Last_Sell_BestPrice_Difference> Max_Sell_Price_Difference) { Max_Sell_Price_Difference = Last_Sell_BestPrice_Difference; }
               }
            }
         }
      }
   }

