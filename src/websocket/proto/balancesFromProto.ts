// import {
//     Balances,
//     Balance
//   } from '../types/trading';
// import { ProtobufBroker } from '../modules/proto';

// export function balanceFromProto(balance: ProtobufBroker.IBalance): Balance | null {
//   if (!balance.currency || !balance.amountString) {
//     return null;
//   }
//   return {
//     currency: balance.currency,
//     amount: balance.amountString
//   };
// }

// export function balancesFromProto(balances: ProtobufBroker.IBalances): Balances | null {
//   if (!balances.fundingType || !balances.balances) {
//     return null;
//   }
//   const returnBalances: Balances = {
//     fundingType: balances.fundingType,
//     balances: []
//   };

//   balances.balances.forEach((balanceProto) => {
//     const balance = balanceFromProto(balanceProto);
//     if (!balance) {
//       return;
//     }
//     returnBalances.balances.push(balance);
//   });

//   return returnBalances;
// }
