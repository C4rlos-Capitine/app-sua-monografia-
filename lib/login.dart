import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';


class login  extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  State<login> createState() => _State();
}



class _State extends State<login> {

  final codController = TextEditingController();
  final passController = TextEditingController();
  //List userdata=[];
  late Map<String, dynamic> estudante;
  Future<void> autenticar() async{
    String uri = "http://192.168.18.183/DS-2023/api_user_login.php";
    bool log = false;
    try{
      var res = await http.post(Uri.parse(uri),

          body: {
            'codigo': codController.text,
            'password': passController.text
          });
          if (res.statusCode == 200) {
            var response = json.decode(res.body);
            //estudante = response;
            estudante = response as Map<String, dynamic>;
            print(res.body);
            if (response['success'] == 'true') {
              print("login bem sucedido");
              Navigator.pushNamed(context, '/home', arguments: estudante);

              //Navigator.pushReplacementNamed(context, '/home', arguments: estudante);

            } else {
              print("login falhou");
            }
          } else {
            print("Server returned status code: ${res.statusCode}");
          }
    }catch(e){
      print(e);
    }
    //return log;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sist. Gest. TCC"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,//space between components
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Login"),
          Container(
            margin: const EdgeInsets.all(5),
            child: TextFormField(
              controller: codController,
              decoration: InputDecoration(border: OutlineInputBorder(), label: Text("codigo")),
            ),
          ),


          Container(
            margin: const EdgeInsets.all(5),
            child: TextFormField(
              controller: passController,
              obscureText: true,
              obscuringCharacter: "*",
              decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'password'),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child:  ElevatedButton(onPressed: (){
              autenticar();
              //Navigator.pushNamed(context, "/home");
              //Navigator.pushReplacementNamed(context, '/home', arguments: estudante);
              },
                child: Text("login"))
          ),

        ],
      ),
    );
  }
}
