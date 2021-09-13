
import 'package:flutter/material.dart';
import 'package:pam_commercant_app/model/produits.dart';
import 'package:pam_commercant_app/model/users.dart';


class CommandEffctuerVu extends StatelessWidget {
  const CommandEffctuerVu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CommandEffctuerPannel(),
    );
  }
}

class CommandEffctuerPannel extends StatefulWidget {
  const CommandEffctuerPannel({Key? key}) : super(key: key);

  @override
  _CommandEffctuerPannelState createState() => _CommandEffctuerPannelState();
}

class _CommandEffctuerPannelState extends State<CommandEffctuerPannel> {

  @override
  Widget build(BuildContext context) {
    //Users
    //print(" id user : ${Users.id}");
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: FutureBuilder(
          future: Produits.CmdEffectuer(Users.id.toString()),
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
                            "HISTORIQUE",
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
                            onPressed: null,
                              
                              /*
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Align(
                                      alignment: Alignment.center,
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
                                      "Commande Accepter",
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ), //const
                                    actions: <Widget>[
                                      /*
                                      TextButton(
                                        child: const Text('Non',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('non');
                                        },
                                      ),
                                      */
                                      TextButton(
                                        child: const Text('ok',style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                        onPressed: () {
                                          Navigator.of(context).pop('oui');
                                        },
                                      ),
                                    ],
                                    //shape: CircleBorder(),
                                  );
                                },
                              );
                              */

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
                                  Divider(),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('${row["designation"]}',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ),
                                  Divider(),
                                  /*ListTile(
                                    title: ,
                                    subtitle: ,
                                  ),*/
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('PRIX UNITAIRE : ${row["pu"]}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('PRIX TOTAL : ${row["pt"]}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text('QUANTITE : ${row["quantite"]}',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),), //["idproduit"],
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: row["statuts"] == "ok" ?
                                    const Text('EN ATTENTE DE LIVRAISON',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),) : row["statuts"] == "livree" ?
                                    const Text('LIVRAISON EFFECTUER',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),) :
                                    Text('STATUTS : ${row["statuts"]}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 18.0,
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
                        child: Text('Aucun element d\'historique',
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