#property strict


#include <mql4_modules\Env\Env.mqh>


/**
 * Use trailing stop to check if the current price is higher or lower.
 * Instead of using the trainling stop immediately,
 * it is a feature to wait for the candlestick
 * to be formed to a certain extent.
 */
class CandleTrailing
{
   private:
      double point;
      double start_percentage;
      double high_price;
      double low_price;
      double buy_price;
      double sell_price;
      int    bars;

   public:
      CandleTrailing(double pips, double percentage = 50);
      
      int Signal(void);
   
};


/**
 * Constructer.
 *
 * @param double pips  Trailing stop value.
 * @param double percentage  Wait until what percent candlestick is formed.
 */
CandleTrailing::CandleTrailing(double pips, double percentage = 50)
{
   if(pips <= 0) pips = 1;
   this.point = (__Digits == 3 || __Digits == 5) ? pips * __Point * 10 : pips * __Point;
   
   if(percentage <= 0)   percentage = 50;
   if(percentage >= 100) percentage = 50;
   this.start_percentage = percentage / 100;
   
   this.high_price = 0;
   this.low_price = 0;
   this.buy_price = 0;
   this.sell_price = 0;
   this.bars = 0;
}


/**
 * Decide whether to trade.
 *
 * @return int  Returns 1 when buy signal occurs.
 *              Returns -1 when sell signal occurs.
 *              Otherwise returns 0.
 */
int CandleTrailing::Signal(void)
{
   if(this.bars == Bars) return(0);
   
   datetime candle_start_time = Time[0];
   datetime candle_end_time = Time[0] + Period() * 60;
   datetime trail_start_time = Time[0] + (int)(Period() * 60 * this.start_percentage);
   
   if(TimeCurrent() < trail_start_time) {
      this.high_price = 0;
      this.low_price = 0;
      this.buy_price = 0;
      this.sell_price = 0;
      return(0);
   }
   
   if(this.high_price == 0) {
      this.high_price = High[0];
   }
   if(this.low_price == 0) {
      this.low_price = Low[0];
   }
   
   if(this.buy_price > Close[0] + this.point || this.buy_price == 0) {
      if(Close[0] + this.point < this.low_price) {
         this.buy_price = Close[0] + this.point;
      }
   }
   if(this.sell_price < Close[0] - this.point || this.sell_price == 0) {
      if(Close[0] - this.point > this.high_price) {
         this.sell_price = Close[0] - this.point;
      }
   }
   
   if(Close[0] >= buy_price && buy_price > 0){
      this.bars = Bars;
      return(1); 
   }
   if(Close[0] <= sell_price && sell_price > 0) {
      this.bars = Bars;
      return(-1);
   }
   return(0);
}