
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam_commercant_app/model/commande.dart';
import 'package:pam_commercant_app/model/produits.dart';
import 'package:pam_commercant_app/model/users.dart';


class CommandActiveVu extends StatelessWidget {
  const CommandActiveVu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CommandActivePannel(),
    );
  }
}

class CommandActivePannel extends StatefulWidget {
  const CommandActivePannel({Key? key}) : super(key: key);

  @override
  _CommandActivePannelState createState() => _CommandActivePannelState();
}

class _CommandActivePannelState extends State<CommandActivePannel> {

  @override
  Widget build(BuildContext context) {
    //Users
    print(" id user commande active : ${Users.id}");

    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: FutureBuilder(
          future: Produits.CmdActive(Users.id.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            var snap = snapshot.data;

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

            print('data : $snap');

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
                            "COMMANDE EN ATTENTE",
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
                            Orientation.landscape ? 2 : 1,
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
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        //height: 50.0,
                                        child: Text(
                                          "Commande",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    content: const Text(
                                      "Vous Acceptez la commande ?",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ), //const
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Refuser',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('refuser');
                                          setState(() {
                                            Commandes.updateCmdRefuse(row["id_com"]);
                                            //Update commande status
                                            Commandes.updateStatusNotification(row["id_com"].toString());
                                            //Message
                                            Fluttertoast.showToast(
                                                msg: "Commande refuser",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 5,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 24.0
                                            );
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('J\'accepte ',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                          setState(() {
                                            Commandes.updateCmdAccepter(row["id_com"]);
                                            //Update commande status
                                            Commandes.updateStatusNotification(row["id_com"].toString());
                                            //Message
                                            Fluttertoast.showToast(
                                                msg: "Commande Accepter",
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
                                      TextButton(
                                        child: const Text('Quitter',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('quitter');
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
                                    child: Text('Montant : ${row["pt"]}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Quantite demande: ${row["quantite"]}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('Commander Par : ${row["name"]} ${row["prenom"]}',
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
                        child: Text('Pas de commande en attente',
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