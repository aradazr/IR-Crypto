// ignore_for_file: library_private_types_in_public_api

import 'package:arz_digital/Screens/coin_list_screen.dart';
import 'package:arz_digital/data/model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


//! instagram
//! Aradazr.dev
//
//? GitHub
//? https://github.com/Aradazr
//
//* Telegram
//* https://t.me/Aradazr
//
//? LinkedIn
//? https://www.linkedin.com/in/aradazr/

///
// Crypto app with live api
// dark and light theme
// search box




class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/text.png',
            ),
            SizedBox(
             height: size.height/15,
            ),
            SpinKitWave(
              color: Colors.white,
              size: 30.0,
            ),
          ],
        )),
      ),
    );
  }

  //! میگیم زمانی که دیتا رو از سرور دریافت کردی بعدش به صفحه بعد پوش کن
  //! ینی اگر سرور قطع باشه و نشه پوش کرد به صفحه ی بعد نمیریم

  Future<void> getData() async {
    var response = await Dio().get('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');
    List<Crypto> cryptoList = response.data
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();

    // var response2 = await Dio().get('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');
    // List<Crypto> cryptoList2 = response2.data['image']
    //     .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
    //     .toList();

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => CoinListScreen(
          //! و بعد   اطلاعات را درون کریپتو لیست صفحه ی بعد بریز
          cryptoList: cryptoList,
          // cryptoList2: cryptoList2,
        ),
      ),
    );
  }
}
