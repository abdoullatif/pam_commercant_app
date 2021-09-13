
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam_commercant_app/model/produits.dart';
import 'package:pam_commercant_app/model/stock.dart';
import 'package:pam_commercant_app/model/users.dart';


class BesoinVu extends StatelessWidget {
  const BesoinVu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Besoin(),
    );
  }
}

class Besoin extends StatefulWidget {
  const Besoin({Key? key}) : super(key: key);

  @override
  _BesoinState createState() => _BesoinState();
}

class _BesoinState extends State<Besoin> {

  @override
  Widget build(BuildContext context) {

    //Users
    print(" id user : ${Users.id}");

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: FutureBuilder(
          future: Produits.besoinPam(Users.id.toString()),
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

            if (snapshot.hasData) {
              return Column(
                children: [
                  //Message
                  Container(
                    //color: Colors.indigo,
                      margin: const EdgeInsets.only(top: 40.0),
                      child: const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          //height: 50.0,
                          child: Text(
                            "BESOIN DU PAM",
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
                            Orientation.landscape ? 2: 1,
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
                                          "AJOUTER A MON STOCK",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    content: const Text(
                                      "Voulez-vous ajouter cette marchandise a votre stock ?",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ), //const
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Non',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('non');
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Oui',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                          //Inset dans la bd Online stock
                                          Stock.pannier(Users.id.toString(),row['idproduit'],0);
                                          setState(() {
                                            //Message
                                            Fluttertoast.showToast(
                                                msg: "Ajouter a votre stock",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: Colors.green,
                                                textColor: Colors.white,
                                                fontSize: 24.0
                                            );
                                          });
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
                                  ListTile(
                                    title: Align(
                                      alignment: Alignment.center,
                                      child: Text('${row["designation"]}',
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    subtitle: Align(
                                      alignment: Alignment.center,
                                      child: Text('Prix unitaire ${row["pu"]}',
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),), //["idproduit"],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                      ],
                    ):
                    const Center(
                      child: Card(
                        elevation: 3,
                        child: Text('Pas de produit en demande',
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

