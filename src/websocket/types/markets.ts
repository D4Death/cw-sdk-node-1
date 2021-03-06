import { PublicOrder, OrderBookSnapshot, OrderBookDelta } from 'util/types/shared';
import { OrderSide } from './trading';

export interface MarketUpdate {
  market: Market;
  orderBookSnapshot?: OrderBookSnapshot;
  orderBookDelta?: OrderBookDelta;
  orderBookSpread?: OrderBookSpread;
  trades?: PublicTrade[];
  intervals?: Interval[];
  summary?: Summary;
  sparkline?: Sparkline;
}

export interface Market {
  id: number;
  exchangeID: number;
  currencyPairID: number;
}

export interface Interval {
  period: string;
  ohlc: OHLC;
  closeTime: Date;
  volumeBase: string;
  volumeQuote: string;
}

export interface OHLC {
  open: string;
  high: string;
  low: string;
  close: string;
}

export interface OrderDeltas {
  set: PublicOrder[];
  remove: string[];
}

export interface PublicTrade {
  externalID: string;
  timestamp: Date;
  side: OrderSide;
  price: string;
  amount: string;
}

export interface OrderBookSpread {
  timestamp: Date;
  bid: PublicOrder;
  ask: PublicOrder;
}

export interface Summary {
  last: string;
  high: string;
  low: string;
  volumeBase: string;
  volumeQuote: string;
  changeAbsolute: string;
  changePercent: string;
  numTrades: number;
}

export interface Sparkline {
  timestamp: Date;
  price: string;
}
