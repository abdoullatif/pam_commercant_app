
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam_commercant_app/model/stock.dart';
import 'package:pam_commercant_app/model/users.dart';


class StockVu extends StatelessWidget {
  const StockVu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: StockPannel(),
    );
  }
}

class StockPannel extends StatefulWidget {
  const StockPannel({Key? key}) : super(key: key);

  @override
  _StockPannelState createState() => _StockPannelState();
}

class _StockPannelState extends State<StockPannel> {
  //State
  StateSetter? _setState;
  //TextEditing
  int _counter = 0;
  TextEditingController _quantite = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Users
    print(" id user : ${Users.id}");
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: FutureBuilder(
          future: Stock.stock(Users.id.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var snap = snapshot.data;
            //print('data : $snap');
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Erreur est survenue !!!"),
              );
            }

            int n = int.tryParse(snap.length.toString()) ?? 0;

            final items = List<String>.generate(n, (i) => "Item $i");

            for (var row in snap) {
              print('idproduit: ${row['idproduit']}, designation: ${row['designation']} pu: ${row['pu']} image: ${row['image']}');
            }

            if (snapshot.hasData) {
              return Column(
                children: [
                  //
                  Container(
                    //color: Colors.indigo,
                      margin: const EdgeInsets.only(top: 40.0),
                      child: const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "MON STOCK",
                            style: TextStyle(
                              fontSize: 24.0,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                  ),
                  Expanded(
                    child: snap.toString() != "()" ?
                    GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape ? 3 : 1,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        //childAspectRatio: (2 / 1),
                      ),
                      children: [
                        for (var row in snap)
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blue,
                            ),
                            onPressed: (){
                              _counter = int.tryParse(row["quantite"]) ?? 0;
                              //Press on produit
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "MODIFIER LE STOCK",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState){
                                        _setState = setState;

                                        void _incrementCounter() {
                                          setState(() {
                                            _counter++;
                                          });
                                        }

                                        void _decrementCounter() {
                                          setState(() {
                                            if(_counter == 0){
                                              //
                                            } else {
                                              _counter--;
                                            }
                                          });
                                        }

                                        _quantite = TextEditingController()..text = _counter.toString();

                                        return Container(
                                          width: MediaQuery.of(context).size.width/1.2,
                                          //height: MediaQuery.of(context).size.height/5,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [

                                                TextField(
                                                  obscureText: false,
                                                  controller: _quantite,
                                                  keyboardType: TextInputType.number,
                                                  decoration: const InputDecoration(
                                                    hintText: "Quantite",
                                                    hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.blue),
                                                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
                                                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.orange),),
                                                  ),
                                                  onChanged: (number) {
                                                    setState((){
                                                      if(number == "") number = "0";
                                                      _counter = int.tryParse(number) ?? 0;
                                                    });
                                                  },
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 54.0,
                                                    height: 2.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0,),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    TextButton(
                                                      onPressed: _decrementCounter,
                                                      child: const Icon(Icons.remove,size: 70.0,),
                                                    ),
                                                    const SizedBox(height: 20.0,),
                                                    TextButton(
                                                      onPressed: _incrementCounter,
                                                      child: const Icon(Icons.add,size: 70.0,),
                                                    ),

                                                  ],
                                                ),

                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Annuler',style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('non');
                                          _counter = 0;
                                          _quantite = TextEditingController()..text = '';
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Enregistrer',style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                          if(_quantite.text.isNotEmpty){
                                            setState(() {
                                              Stock.updateQuantiteStock(int.tryParse(_quantite.text) ?? 0, Users.id.toString(), row['idproduit']);
                                              _counter = 0;
                                              _quantite = TextEditingController()..text = '';
                                              //Message
                                              Fluttertoast.showToast(
                                                  msg: "Stock Modifier",
                                                  toastLength: Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 5,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                  fontSize: 24.0
                                              );
                                            });
                                          } else {
                                            //Message
                                            Fluttertoast.showToast(
                                                msg: "Veuillez saissir un stock",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 24.0
                                            );
                                          }

                                        },
                                      ),
                                    ],
                                    //shape: CircleBorder(),
                                  );
                                },
                              );
                            },
                            child: Card(
                              elevation: 5.0,
                              child: Column(
                                children: [
                                  const SizedBox(height: 30.0,),
                                  SizedBox(
                                    height: 150.0,
                                    width: 150.0,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: row['image'].toString().contains("\\") ?
                                      NetworkImage("https://pamgnsupport.com/uploads/${row['image'].toString().substring(1)}"):
                                      NetworkImage("https://pamgnsupport.com/uploads/${row['image'].toString()}"),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('${row["designation"]}',
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                  const SizedBox(height: 5.0,),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Prix Unitaire ${row["pu"]}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Quantite : ${row["quantite"]}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ):
                    const Center(
                      child: Card(
                        elevation: 3,
                        child: Text('Pas de produit dans votre stock',
                          style: TextStyle(
                            fontSize: 20.0,
                            //fontWeight: FontWeight.bold,
                          ),),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Text('Chargement ... ');

          }
      ),
    );
  }
}

//
/*

  ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      if (snapshot.hasData) {
                        for (var row in snap) {
                          String img = row['image'];
                        return TextButton(
                          //elevation: 0,
                          //padding: const EdgeInsets.all(0.0),
                          //color: Colors.transparent,
                          //disabledColor: Colors.transparent,
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            ),
                            onPressed: (){},
                            child: Card(
                              margin: const EdgeInsets.only(top: 25.0,),
                              elevation: 2.0,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage("https://pamgnsupport.com/uploads/${img.substring(1)}"),  //FileImage(File.fromUri(Uri()))
                                  //backgroundImage: Image.file(file),
                                ),
                                title: Text('${row["designation"]} ${row["pu"]}'),
                                subtitle: Text('${row["idproduit"]}'),
                              ),
                            )
                        );
                      }
                      }
                      return const Text('Chargement ... ');
                    },
                  ),


 */

