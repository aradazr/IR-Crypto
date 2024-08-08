import 'dart:ui';

import 'package:arz_digital/constans/my_colors.dart';
import 'package:arz_digital/data/model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CoinListScreen extends StatefulWidget {
  CoinListScreen({
    super.key,
    this.cryptoList,
  });

  List<Crypto>? cryptoList;
  // List<Crypto>? cryptoList2;

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  bool isLoading = false;
  bool isSearched = false;
  bool isLight = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: isLight ? Colors.white : Colors.black,
            leading: InkWell(
                child: Icon(Icons.contrast,
                    color: isLight ? Colors.black : Colors.white),
                onTap: () {
                  setState(() {
                    isLight = !isLight;
                  });
                }),
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(7),
                child:
                    Container(color: Color.fromARGB(0, 0, 0, 0), height: 1.0)),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      isSearched = !isSearched;
                    });
                  },
                  icon: Icon(Icons.search,
                      color: isLight ? Colors.black : Colors.white)),
            ],
            backgroundColor: isLight ? Colors.white : Colors.grey[900],
            automaticallyImplyLeading: false,
            title: Text(
              'کریپتو ایران',
              style: TextStyle(
                color: isLight ? Colors.black : Colors.white,
                fontFamily: 'mh',
              ),
            ),
            centerTitle: true,
          ),
          //!-----------------------------------------------------------------------------------------------------------------------------------------------

          backgroundColor: isLight ? backgroundColorLight : Colors.grey[900],
          //!-----------------------------------------------------------------------------------------------------------------------------------------------
          body: Column(
            children: [
              Visibility(
                  visible: isLoading,
                  child: Text(
                    '...درحال بروز رسانی',
                    style: TextStyle(
                      color: isLight ? Colors.black : Colors.white,
                    ),
                  )),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Visibility(
                  visible: isSearched,
                  child: SizedBox(
                    width: size.width / 1.05,
                    child: Padding(
                      padding:  EdgeInsets.only(top: 8),
                      child: TextField(
                        //! ولیو را به فانکشنی که ساختیم پاس میدم
                        onChanged: (value) {
                          _filteredList(value);
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: isLight ? searchBoxLight : searchBoxDark,
                            ),
                            borderRadius: BorderRadius.circular(46),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(46),
                            borderSide: BorderSide(
                                color: isLight ? Colors.white : searchBoxDark),
                          ),
                          fillColor: searchBoxDark,
                          filled: true,
                          hintText: 'نام رمز ارز را وارد کنید',
                          hintStyle:
                              TextStyle(color: Colors.white, fontFamily: 'mh'),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //! یه لیست خالی درست میکنیم و میگیم این لیست برابر با دیتای دریافتیه و هر بار که رفرش میکنیم
              //! این لیست را در لیست اصلی میریزیم برای همین دیتای ما اپدیت میشه
              Expanded(
                child: RefreshIndicator(
                  color: Colors.blue,
                  backgroundColor: isLight ? Colors.white: Colors.black,
                  onRefresh: () async {
                    List<Crypto> refreshData = await _getData();
                    setState(() {
                      widget.cryptoList = refreshData;
                    });
                  },
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 10, right: 10),
                          child: Container(
                              height: size.height / 12.5,
                              width: size.width / .4,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: isLight ? cryptoBoxLight : cryptoBoxDark),
                              child:
                                  _getListTileItem(widget.cryptoList![index])),
                        );
                      },
                      itemCount: widget.cryptoList!.length),
                ),
              ),
            ],
          )),
    );
  }

//!-----------------------------------------------------------------------------------------------------------------------------------------------
//! لیست ارز ها که با لیست ویو بیلدر ساخته شده و اطلاعات به اون پاس داده شده
  Widget _getListTileItem(Crypto crypto) {
    return ListTile(
      //? عنوان ها را در اینجا نمایش میدهیم
      title: Text(
        crypto.symbol.toUpperCase(),
        style: TextStyle(color: isLight ? Colors.black : Colors.white),
      ),

      //? نام اصلی را در اینجا نمایش میدهیم
      subtitle: Text(
        crypto.name,
        style: TextStyle(color: isLight? Colors.grey[800] : Colors.grey),
      ),

      //? عکس ها را در اینجا نمایش میدهیم
      leading: SizedBox(
        width: 42.0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: crypto.image,
            placeholder: (context, url) => CircularProgressIndicator(
              color: searchBoxDark,
            ),
          ),
          // child: Image.network(crypto.image),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              //? قیمت ها را در اینجا نمایش میدهیم
              children: [
                Text(
                  crypto.currnentPrice.toStringAsFixed(2),
                  style: TextStyle(color: isLight ? Colors.grey[800] : Colors.grey[400], fontSize: 18),
                ),
                // ? درصد تغییر را در اینجا نمایش میدهیم
                Text(
                  '${crypto.changePercent24hr.toStringAsFixed(2)} %',
                  style: TextStyle(
                    fontSize: 11,
                    color: _getColorChnageText(
                        crypto.changePercent24hr.toDouble()),
                  ),
                )
              ],
            ),
            //? ایکون درصد تغییر را در اینجا نمایش میدهیم
            SizedBox(
                width: 50,
                child: Center(
                  child: _getIconChangePercent(
                      crypto.changePercent24hr.toDouble()),
                )),
          ],
        ),
      ),
    );
  }

//!-----------------------------------------------------------------------------------------------------------------------------------------------
  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: Colors.red,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: Colors.green,
          );
  }

//!-----------------------------------------------------------------------------------------------------------------------------------------------
  Color _getColorChnageText(double percentChange) {
    return percentChange <= 0 ? Colors.red : Colors.green;
  }

//!-----------------------------------------------------------------------------------------------------------------------------------------------
//! برای گرفتن دیتا از سرور و استفاده از ان در جاهای مختلف
  Future<List<Crypto>> _getData() async {
    var response = await Dio().get(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');
    List<Crypto> cryptoList = response.data
        .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList();
    return cryptoList;
  }

  // Future<List<Crypto>> _getImageData() async {
  //   var response2 = await Dio().get('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false');
  //   List<Crypto> cryptoImageList = response2.data['image']
  //       .map<Crypto>((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
  //       .toList();
  //   return cryptoImageList;
  // }
//!-----------------------------------------------------------------------------------------------------------------------------------------------
//! این فانکشن برای سرچ در تکست فیلد میباشد

  Future<void> _filteredList(String enteredWords) async {
    List<Crypto>? filteredList = [];
    //? دیتای خودمون رو درون یک متغیر میریزیم
    if (enteredWords.isEmpty) {
      //! برای نشان دادن تکست لودینگ
      setState(() {
        isLoading = true;
      });
      //!برای از بین بردن تکست لودینگ
      var result = await _getData();
      setState(() {
        widget.cryptoList = result;
        isLoading = false;
      });
      return;
    }

    //! برای جستجو در برنامه
    //! ابتدا یک لیست خالی میسازیم بعد این لیستو برابر قرار بده با کریپتو لیست اصلی
    //! و میگیم هرجاییش المنت ما و نام ما یا سیمبل ما شامل اون حرفای ورودی بود تبدیل به لیستش کن و بعد کریپتو لیست رو تبدیل کن به لیست جدید
    filteredList = widget.cryptoList!.where((element) {
      return element.name.toLowerCase().contains(enteredWords.toLowerCase()) ||
          element.symbol.toLowerCase().contains(enteredWords.toLowerCase());
    }).toList();
    setState(() {
      widget.cryptoList = filteredList;
    });
  }
}
