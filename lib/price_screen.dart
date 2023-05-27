import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'coin_data.dart';
import 'package:http/http.dart' as http;
import 'dart:io'show Platform ;
import 'dart:convert';

const apiKey='834026A6-6F52-4ABE-ABEC-BB21112A7F0F';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}
      String selectedCurrency = 'USD';



class _PriceScreenState extends State<PriceScreen> {

String tim='';
String base='';
String source='';
late double price;



  DropdownButton<String> androidDropDown()
  {
    List<DropdownMenuItem<String>> dropdownItems = [];
  for(String currency in currenciesList)
  {
    var newItem = DropdownMenuItem(
      child: Text(currency),
      value: currency,
    );
    dropdownItems.add(newItem);
  }
  return DropdownButton<String>(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value){
   setState(() {
  selectedCurrency= value!;
    });
        });
  }

  CupertinoPicker iOSPicker()
  {

    List<Widget> str=[];
  for(String i in currenciesList)
  {
    Widget newItem=Text(i);
    str.add(newItem as Text);
  }
  return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged:(selectedIndex){
        print(selectedIndex);
      }, children:
            str,
      // Text('USD'),
      // Text('EUR'),
      // Text('GBP'),
    );
  }
   getPicker()
  {
    if(Platform.isIOS)
      {
        return iOSPicker();
      }
    else if(Platform.isAndroid)
      {
        return androidDropDown();
      }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

   // void getData()
   // async{
   //   http.Response response= await http.get('https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=834026A6-6F52-4ABE-ABEC-BB21112A7F0F' as Uri);
   //  // print(response.statusCode);
   //   if(response.statusCode==200)
   //     {
   //       String data=response.body;
   //       print(data);
   //     }
   // }


  Future getData() async {
    http.Response response =
    await http.get(Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=$apiKey'));
    if (response.statusCode == 200) {
      String data = response.body;
     // print(data);
      tim=jsonDecode(data)['time'];
      print(tim);
      base=jsonDecode(data)['asset_id_base'];
      print(base);
      source=jsonDecode(data)['asset_id_quote'];
      print(source);
      price =jsonDecode(data)['rate'];
      print(price);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${price!}  USD',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child:Platform.isIOS? iOSPicker():androidDropDown(),
          ),
        ],
      ),
    );
  }
}
//https://rest.coinapi.io/v1/exchangerate/BTC/USD?apikey=834026A6-6F52-4ABE-ABEC-BB21112A7F0F