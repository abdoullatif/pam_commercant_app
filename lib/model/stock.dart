
import 'package:pam_commercant_app/db/data_online.dart';


  class Stock {

    late String idcommercant;
    late String idproduit;
    late String quantite;


    //Get stock commercant
    static Future stock(String? id) async{
      var data = await DbOnline.getStock(id);
      return data;
    }

    //Set produit in stock
    static pannier(String? idcommercant, String? idproduit, int? quantite) {
      DbOnline.setPannier(idcommercant, idproduit, quantite);
      return 1;
    }

    //Set quantite produit in stock
    static updateQuantiteStock(int? quantite, String? idcommercant, String? idproduit) {
      DbOnline.upDataStock(quantite, idcommercant, idproduit);
      return 1;
    }

  }