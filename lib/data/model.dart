// class Crypto {
//   String id;
//   String name;
//   String symbol;
//   double changePercent24hr;
//   double priceUsd;
//   double marketCapUsd;
//   int rank;

//   Crypto(
//     this.id,
//     this.name,
//     this.symbol,
//     this.changePercent24hr,
//     this.priceUsd,
//     this.marketCapUsd,
//     this.rank,
//   );

//   factory Crypto.fromMapJson(Map<String, dynamic> jsonMapObject) {
//     return Crypto(
//       jsonMapObject['id'],
//       jsonMapObject['name'],
//       jsonMapObject['symbol'],
//       double.parse(jsonMapObject['changePercent24Hr']),
//       double.parse(jsonMapObject['priceUsd']),
//       double.parse(jsonMapObject['marketCapUsd']),
//       int.parse(jsonMapObject['rank']),
//     );
//   }
// }



class Crypto {
  String id;
  String name;
  String symbol;
  String image;
  dynamic changePercent24hr;
  dynamic currnentPrice;
  int marketCapUsd;
  int rank;

  Crypto(
    this.id,
    this.name,
    this.symbol,
    this.image,
    this.changePercent24hr,
    this.currnentPrice,
    this.marketCapUsd,
    this.rank,
  );

  factory Crypto.fromMapJson(Map<String, dynamic> jsonMapObject) {
    return Crypto(
      jsonMapObject['id'],
      jsonMapObject['name'],
      jsonMapObject['symbol'],
      jsonMapObject['image'],
      jsonMapObject['price_change_percentage_24h'],
      jsonMapObject['current_price'],
      jsonMapObject['market_cap'],
      jsonMapObject['market_cap_rank'],
    );
  }
}