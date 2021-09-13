import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pam_commercant_app/db/data_online.dart';
import 'package:pam_commercant_app/db/storage_util.dart';
import 'package:pam_commercant_app/model/commande.dart';
import 'package:pam_commercant_app/model/users.dart';
import 'package:pam_commercant_app/services/notification_helper.dart';
import 'package:pam_commercant_app/utlis/parametre.dart';
import 'package:pam_commercant_app/vu/home_vu.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginVu(),
    );
  }
}

class LoginVu extends StatefulWidget {
  const LoginVu({Key? key}) : super(key: key);

  @override
  _LoginVuState createState() => _LoginVuState();
}

class _LoginVuState extends State<LoginVu> {

  Users user = Users();
  final _formKey = GlobalKey<FormState>();
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  //variable de connexion
  TextEditingController _emailOrContact = TextEditingController();
  TextEditingController _mdp = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    //Provider.of<NotificationService>(context, listen: false).initialize();
    //DbOnline.con();
    //connection_auto();
    super.initState();
  }

  void connection_auto () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //shared preference
    String? emailOrContact = prefs.getString("emailOrContact");
    String? mdp = prefs.getString("mdp");
    //If user Exist
    print("$emailOrContact and $mdp");
    if(emailOrContact!.isNotEmpty && mdp!.isNotEmpty) {
      var userVerif = await user.verifUser(emailOrContact,mdp);
      if(userVerif){
        //Enter: Sessam Ouvre toi :)
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const HomeVu(),),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: DbOnline.con(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.hasError){
          return const Center(
            child: Text('Un probleme est survenue, Veuillez vous connecter a internet !'),
          );
        }
        //
        if(snapshot.hasData) {
          connection_auto();
          return Container(
            child: Form(
              key: _formKey,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: ListView(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      //Column(),
                      //Text(_reponseFromNativeCode),
                      const SizedBox(height: 150.0),
                      SizedBox(
                        height: 100.0,
                        child: Image.asset(
                          "asset/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 45.0),
                      TextFormField(
                        obscureText: false,
                        style: style,
                        controller: _emailOrContact,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email ou numero de telephone",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.phone_android,
                              color: Colors.grey,
                            ), // icon is 48px widget.
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuiller entrer votre numero de telephone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25.0),
                      TextFormField(
                        obscureText: true,
                        style: style,
                        controller: _mdp,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Mots de passe",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Icon(
                              Icons.vpn_key,
                              color: Colors.grey,
                            ), // icon is 48px widget.
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuiller entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 35.0,
                      ),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        color: const Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              //Verification de User
                              if(Param.connection == true) {
                                //Connected
                                var userConnect = await user.verifUser(_emailOrContact.text,_mdp.text);
                                if(userConnect){
                                  //Verifie notification
                                  var notif = await Commandes.nombrenotificationCmd(Users.id.toString());
                                  if(notif.toString() != "(Fields: {nombre_notification: 0})") {
                                    for(var row in notif){
                                      showNotification(Param.flutterLocalNotificationsPlugin,Param.index,'Commande recu du pam','Vous avez ${row['nombre_notification']} commandes du pam en attente');
                                    }
                                    //Param.index++;
                                  }
                                  //Save info user for next_time
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('emailOrContact', _emailOrContact.text);
                                  prefs.setString('mdp', _mdp.text);
                                  //user.saveUserEmailOrContactAndMdp(_emailOrContact.text,_mdp.text);
                                  _emailOrContact = TextEditingController(text: '');
                                  _mdp = TextEditingController(text: '');
                                  //Enter: Sessam Ouvre toi :)
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => const HomeVu(),),
                                  );
                                } else {
                                  //msg alerte
                                  Fluttertoast.showToast(
                                      msg: "Erreur de login ou mot de passe !", //Présence enregistrée,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              } else {
                                //No connected
                                Fluttertoast.showToast(
                                    msg: "Probleme de connection internet !", //Présence enregistrée,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }

                            }
                          },
                          child: Text("Se connecter",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        //
        return Container(
          child: Form(
            key: _formKey,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ListView(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    //Column(),
                    //Text(_reponseFromNativeCode),
                    const SizedBox(height: 150.0),
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "asset/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45.0),
                    TextFormField(
                      obscureText: false,
                      style: style,
                      controller: _emailOrContact,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Email ou numero de telephone",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.phone_android,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuiller entrer votre numero de telephone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25.0),
                    TextFormField(
                      obscureText: true,
                      style: style,
                      controller: _mdp,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Mots de passe",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.vpn_key,
                            color: Colors.grey,
                          ), // icon is 48px widget.
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuiller entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: const Color(0xff01A0C7),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            //Verification de User
                            if(Param.connection == true) {
                              //Connected
                              var userConnect = await user.verifUser(_emailOrContact.text,_mdp.text);
                              if(userConnect){
                                //Verifie notification
                                var notif = await Commandes.nombrenotificationCmd(Users.id.toString());
                                if(notif.toString() != "(Fields: {nombre_notification: 0})") {
                                  for(var row in notif){
                                    showNotification(Param.flutterLocalNotificationsPlugin,Param.index,'Commande recu du pam','Vous avez ${row['nombre_notification']} commandes du pam en attente');
                                  }
                                  //Param.index++;
                                }
                                //Save info user for next_time
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('emailOrContact', _emailOrContact.text);
                                prefs.setString('mdp', _mdp.text);
                                //user.saveUserEmailOrContactAndMdp(_emailOrContact.text,_mdp.text);
                                //Enter: Sessam Ouvre toi :)
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => const HomeVu(),),
                                );
                              } else {
                                //msg alerte
                                Fluttertoast.showToast(
                                    msg: "Erreur de login ou mot de passe !", //Présence enregistrée,
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 5,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }
                            } else {
                              //No connected
                              Fluttertoast.showToast(
                                  msg: "Probleme de connection internet !", //Présence enregistrée,
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 5,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }

                          }
                        },
                        child: Text("Se connecter",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

  }
}

