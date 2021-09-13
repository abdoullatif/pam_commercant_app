import 'dart:async';

import 'package:mysql1/mysql1.dart';
import 'package:pam_commercant_app/utlis/parametre.dart';

 class DbOnline {
   //Variable
   static var conn;

   ///----------------------------------------------------------------------------------
   ///--------------OPEN CONNECTION-----------------------------------------------------
   /// ---------------------------------------------------------------------------------
   // Open a connection (testdb should already exist)
   static Future con() async {
      conn = await MySqlConnection.connect(ConnectionSettings(
         host: 'pamgnsupport.com', //pamgnsupport.com
         port: 3407, //3306
         user: 'pam_admin_db',
         db: 'pam',
         password: 'Tulip2020'));
      if (conn != null) {print("Connection reussi");Param.connection = true;} else {print("Probleme, connection non etablir");Param.connection = false;}
   }

    // Create a table
    //await conn.query('CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), age int)');

   ///----------------------------------------------------------------------------------
   ///--------------INSERTION-----------------------------------------------------------
   /// ---------------------------------------------------------------------------------
   // Insert some data
   static setPannier(String? idcommercant, String? idproduit, int? quantite) async {
     var result = await conn.query(
         'insert into stock(idcommercant,idproduit,quantite) values(?,?,?)',
         [idcommercant, idproduit, quantite]);
     print('Insertion row id=${result.insertId}');
   }

    /*
    for (var row in results) {
      print('Name: ${row[0]}, email: ${row[1]} age: ${row[2]}');
    }
    */
   ///----------------------------------------------------------------------------------
   ///--------------SELECT--------------------------------------------------------------
   /// ---------------------------------------------------------------------------------

   // get user with email
   static Future getUserWithEmailAndContact(String emailOrContact) async => await conn.query(
       'select * from users where email_usr_pm = ? or contacte = ?', [emailOrContact,emailOrContact]);

   // get user with id
   static Future<List<Map<String, dynamic>>> getUserWhereId(String id) async => await conn.query(
       'select * from users where id = ?', [id]);

   // get user with email or contact
   static Future getUserWhereEmailAndContact(String emailOrContact, String mdp) async => await conn.query(
       'select * from users where email_usr_pm = ? or contacte = ? and mdp_usr_pm = ?', [emailOrContact,emailOrContact,mdp]);

  // Besoin du partenaire
   static Future getBesoinPam(String? id) async => await await conn.query(
       'select produits.idproduit,produits.designation,produits.pu,produits.image from produits where produits.idproduit not in (select stock.idproduit from stock where idcommercant=?)', [id]);

   // Mon stock
   static Future getStock(String? id) async {
     var results = await conn.query(
         'select * from stock,produits,users where stock.idcommercant = ? and stock.idcommercant = users.id and stock.idproduit = produits.idproduit', [id]);
     return results;
   }

   // Commande Active
   static Future getCmdActive(String? id) async {
     var results = await conn.query(
         'select commande.id as id_com,commande.pt,commande.quantite,produits.designation,produits.image,users.name,users.prenom,users.contacte from commande,produits,users where commande.idproduit=produits.idproduit and commande.idadmin=users.id and commande.idcommercant=? and commande.statuts=\'0\' ', [id]);
     return results;
   }

   // Commande Effectuer
   static Future getCmdEffect(String? id) async {
     var results = await conn.query(
         'select * from commande,produits,users where commande.idproduit=produits.idproduit and commande.idadmin=users.id and commande.idcommercant=? and commande.statuts in (\'ok\',\'livree\')', [id]);
     return results;
   }

   // Commande Effectuer
   static Future getnotification(String? id) async {
     var results = await conn.query(
         'select count(commande.id) as status_notification from commande where commande.idcommercant=? and commande.statutprod=\'0\' ', [id]);
     return results;
   }

   // Nombre notification
   static Future getnombrenotification(String? id) async {
     var results = await conn.query(
         'select count(commande.id) as nombre_notification from commande where commande.idcommercant=? and commande.statuts=\'0\' ', [id]);
     return results;
   }

   // Historique
   static Future getHistorique(String? id) async {
     var results = await conn.query(
         'select * from commande,produits,users where commande.idproduit=produits.idproduit and commande.idadmin=users.id and commande.statuts=\'livree\' and commande.idcommercant=? ', [id]);
     return results;
   }

   ///----------------------------------------------------------------------------------
   ///--------------UPDATE--------------------------------------------------------------
   /// ---------------------------------------------------------------------------------
   // Update data Stock
   static upDataStock (int? quantite, String? idcommercant, String? idproduit) async {
     await conn.query('update stock set quantite = ? where idcommercant = ? and idproduit = ?', [quantite, idcommercant, idproduit]);
   }
   // Update data Accepter la commande
   static upDataCmdAccepte (int? idcommande) async {
     await conn.query('update commande set statuts = "ok" where id= ?', [idcommande]);
   }
   // Update data Rejeter la commande
   static upDataCmdRejeter (int? idcommande) async {
     await conn.query('update commande set statuts = "rejected" where id= ?', [idcommande]);
   }
   // Update data Rejeter la commande
   static upDataNotification (String? id) async {
     await conn.query('update commande set statutprod = "1" where commande.id = ?', [id]);
   }

   ///----------------------------------------------------------------------------------
   ///--------------CLOSE CONNECTION ----------------------------------------------------
   /// ---------------------------------------------------------------------------------
   // Finally, close the connection
   static Future closeCon() async {
     await conn.close();
   }

}