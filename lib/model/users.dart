import 'package:dbcrypt/dbcrypt.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pam_commercant_app/db/data_online.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Users {

  //privat variable
  static int? _id;
  static String? _name;
  static String? _prenom;
  static String? _privilege;
  static String? _image;
  static String? _email_usr_pm;
  static String? _localite;
  static String? _contacte;
  static String? _email_verified_at;
  static String? _remember_token;
  //
  static String? _type;
  static String? _mdp_usr_pm;
  static String? _privilege2;

  //BCrypt
  DBCrypt dBCrypt = DBCrypt();
  var passwordIsCorrect;

  //Constr
  Users();

  //Fonction
  verifUser(String emailOrContact, String mdp) async {
    var user = await DbOnline.getUserWithEmailAndContact(emailOrContact);
    if (user.isNotEmpty){
      for (var row in user) {
        passwordIsCorrect = dBCrypt.checkpw(mdp,row['mdp_usr_pm']);
        print(passwordIsCorrect);
        if(passwordIsCorrect){
          _id = row['id'] ?? "";
          _name = row['name'] ?? "";
          _prenom = row['prenom'] ?? "";
          _privilege = row['privilege'] ?? "";
          _image = row['image'] ?? "";
          _email_usr_pm = row['email_usr_pm'] ?? "";
          _localite = row['localite'] ?? "";
          _contacte = row['contacte'] ?? "";
          _email_verified_at = row['email_verified_at'] ?? "";
          _remember_token = row['remember_token'] ?? "";
          _type = row['type'] ?? "";
          _mdp_usr_pm = row['mdp_usr_pm'] ?? "";
          _privilege2 = row['privilege2'] ?? "";
          print("present");
          return true;
        } else {
          print("Mot de pass incorrecte");
          return false;
        }
      }
    } else {
      print("Absent");
      return false;
    }
  }
  //Get user where id
  Future getUser(String id) async {
    List<Map<String, dynamic>> user = await DbOnline.getUserWhereId(id);
    if (user.isNotEmpty) {
      for (var row in user) {
        _id = row['id'] ?? "";
        _name = row['name'] ?? "";
        _prenom = row['prenom'] ?? "";
        _privilege = row['privilege'] ?? "";
        _image = row['image'] ?? "";
        _email_usr_pm = row['email_usr_pm'] ?? "";
        _localite = row['localite'] ?? "";
        _contacte = row['contacte'] ?? "";
        _email_verified_at = row['email_verified_at'] ?? "";
        _remember_token = row['remember_token'] ?? "";
        _type = row['type'] ?? "";
        _mdp_usr_pm = row['mdp_usr_pm'] ?? "";
        _privilege2 = row['privilege2'] ?? "";
        print("Recu !");
        return true;
      }
    } else {
      print('n\'exist pas');
      return false;
    }
  }

  saveUserEmailOrContactAndMdp(String emailOrContact, String mdp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('emailOrContact', emailOrContact);
    prefs.setString('mdp', mdp);
  }

  //Getters users

  static String? get privilege2 => _privilege2;
        
  static String? get mdp_usr_pm => _mdp_usr_pm;

  static String? get type => _type;

  static String? get remember_token => _remember_token;

  static String? get email_verified_at => _email_verified_at;

  static String? get contacte => _contacte;

  static String? get localite => _localite;

  static String? get email_usr_pm => _email_usr_pm;

  static String? get image => _image;

  static String? get privilege => _privilege;

  static String? get prenom => _prenom;

  static String? get name => _name;

  static int? get id => _id;


}