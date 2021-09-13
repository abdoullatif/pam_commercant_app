import 'package:mysql1/mysql1.dart';
import 'package:pam_commercant_app/db/data_online.dart';


class Produits {

  late String id;
  late String idproduit;
  late String designation;
  late String pu;
  late String image;


  static Future besoinPam(String? id) async{
    var data = await DbOnline.getBesoinPam(id);
    return data;
  }

  static Future CmdActive(String? id) async{
    var data = await DbOnline.getCmdActive(id);
    return data;
  }

  static Future CmdEffectuer(String? id) async{
    var data = await DbOnline.getCmdEffect(id);
    return data;
  }

}