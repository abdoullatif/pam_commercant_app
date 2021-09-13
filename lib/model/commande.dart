

import 'package:pam_commercant_app/db/data_online.dart';

class Commandes {

  static late String id;
  static late String idproduit;
  static late String idadmin;
  static late String idcommercant;
  static late String ref;
  static late String quantite;
  static late String pu;
  static late String pt;
  static late String status;
  static late String date_commande;
  static late String anneeScolaire;

  //Set commande Accepter
  static updateCmdAccepter(int? idcommande) {
    DbOnline.upDataCmdAccepte(idcommande);
    return 1;
  }

  //Set commande Accepter
  static updateCmdRefuse(int? idcommande) {
    DbOnline.upDataCmdRejeter(idcommande);
    return 1;
  }

  static notificationCmd (String? id) async{
    var result = DbOnline.getnotification(id);
    return result;
  }

  static nombrenotificationCmd (String? id) async{
    var result = DbOnline.getnombrenotification(id);
    return result;
  }

  //Set commande Notification Vu
  static updateStatusNotification (String? idcommande) {
    DbOnline.upDataNotification(idcommande);
    return 1;
  }

}