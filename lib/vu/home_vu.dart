
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pam_commercant_app/model/commande.dart';
import 'package:pam_commercant_app/model/users.dart';
import 'package:pam_commercant_app/services/notification.dart';
import 'package:pam_commercant_app/services/notification_helper.dart';
import 'package:pam_commercant_app/utlis/parametre.dart';
import 'package:pam_commercant_app/vu/stock_vu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'besoin_vu.dart';
import 'command_effectuer.dart';
import 'commande_active_vu.dart';
import 'package:badges/badges.dart';

class HomeVu extends StatelessWidget {
  const HomeVu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  //Timmer for 10 seconde
  Timer? _timer;
  //Nombre de notification
  int nombre_notif = 0;


  @override
  void initState() {
    super.initState();
    //Check the server every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) => setState(() {
      //
    }));
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer!.isActive) _timer!.cancel();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("bam dam boum !");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 90.0,),
              SizedBox(
                height: 150.0,
                child: Image.asset(
                  "asset/commercant_logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30.0,),
              Center(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 0.0,
                  crossAxisCount: 2,
                  children: [
                    //button besoin pam
                    InkWell(
                      child: Image.asset('asset/imagesButton/pam.png'),
                      onTap: (){
                        String name = "Besoin";
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const BesoinVu(),settings: RouteSettings(arguments: name,)),
                        );
                      },
                    ),
                    //button commande pam
                    FutureBuilder(
                        future: Commandes.notificationCmd(Users.id.toString()),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {

                          var snap = snapshot.data;
                          //print('data notification : $snap');

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return nombre_notif == 0 ?
                            InkWell(
                              child: Image.asset("asset/imagesButton/command_active.png"),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const CommandActiveVu()),
                                );
                              },
                            ) :
                            Badge(
                              padding: const EdgeInsets.all(13.0),
                              position: BadgePosition.topEnd(top: 10, end: 10),
                              badgeContent: Text( '$nombre_notif',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),),
                              child: InkWell(
                                child: Image.asset("asset/imagesButton/command_active.png"),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const CommandActiveVu()),
                                  );
                                },
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return InkWell(
                              child: Image.asset("asset/imagesButton/command_active.png"),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const CommandActiveVu()),
                                );
                              },
                            );
                          }

                          for (var row in snap){
                            nombre_notif = row['status_notification'] ?? 0;
                            //if(nombre_notif != 0) showNotification(Param.flutterLocalNotificationsPlugin,Param.index,'Commande recu du pam','Vous avez ${row['status_notification']} commandes du pam en attente');
                          }

                          if (snapshot.hasData) {
                            for (var row in snap) {
                              return row['status_notification'] == 0 ?
                              InkWell(
                                child: Image.asset("asset/imagesButton/command_active.png"),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => const CommandActiveVu()),
                                  );
                                },
                              ) :
                              Badge(
                                padding: const EdgeInsets.all(13.0),
                                position: BadgePosition.topEnd(top: 10, end: 10),
                                badgeContent: Text( '${row['status_notification']}',
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),),
                                child: InkWell(
                                  child: Image.asset("asset/imagesButton/command_active.png"),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const CommandActiveVu()),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return InkWell(
                            child: Image.asset("asset/imagesButton/command_active.png"),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const CommandActiveVu()),
                              );
                            },
                          );
                        }
                    ),
                    //button stock
                    InkWell(
                      child: Image.asset("asset/imagesButton/stock.png"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const StockVu()),
                        );
                      },
                    ),
                    //button commande effectuer / historique pam
                    InkWell(
                      child: Image.asset('asset/imagesButton/command_effect.png'),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => const CommandEffctuerVu()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          //logOut delete share pref
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove("emailOrContact");
          prefs.remove("mdp");
          Navigator.pop(context);
        },
        tooltip: 'Quitter', backgroundColor: Colors.transparent,
        child: Image.asset("asset/imagesButton/close.png"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}


