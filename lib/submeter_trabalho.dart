import 'dart:convert';
import 'dart:io'; // Update the import statement

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'estudante.dart' as globals;


class submeter_trabalho extends StatefulWidget {
  const submeter_trabalho({Key? key}) : super(key: key);

  @override
  State<submeter_trabalho> createState() => _State();
}

class _State extends State<submeter_trabalho> {

  late Map <String, dynamic> estudante;
  late File selectedfile = File('');
  late Response response;
  String progress = "";
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async{
    //var map = ModalRoute.of(context)?.settings as Map<String, String>;
    var routeSettings = ModalRoute.of(this.context)?.settings;
    if (routeSettings != null && routeSettings.arguments != null) {
      estudante = routeSettings.arguments as Map<String, dynamic>;
      // Use the arguments map here
      print(estudante['codigo_estudante']);
      print(estudante['id_minor']);
    }

  }


  selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedfile = File(result.files.single.path!);
      });
    }
  }


  uploadFile() async {
    String uploadurl = "http://192.168.18.183/DS-2023/api_estudante_submeter.php";
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
          selectedfile.path,
          filename: basename(selectedfile.path)
        //show only filename from path
      ),
      "codigo_estudante" : estudante['codigo_estudante']
    });

    response = await dio.post(uploadurl,
      data: formdata,
      onSendProgress: (int sent, int total) {
        String percentage = (sent/total*100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " +  percentage + " % uploaded";
          //update the progress
        });
      },);



    if(response.statusCode == 200){
      print(response.toString());
      globals.est.estado = "3";
      //print response from server
    }else{
      print("Erro de conexao.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:Text("Submeter trabalho"),
          backgroundColor: Colors.blueAccent,
        ), //set appbar
        body:Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(40),
            child:Column(children: <Widget>[

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child:progress == null?
                Text("Progress: 0%"):
                Text(basename("Progress: $progress"),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),),
                //show progress status here
              ),

              Container(
                margin: EdgeInsets.all(10),
                //show file name here
                child:selectedfile == null?
                Text("Escolha o ficheiro"):
                Text(basename(selectedfile.path)),
                //basename is from path package, to get filename from path
                //check if file is selected, if yes then show file name
              ),

              Container(
                  child:ElevatedButton.icon(
                    onPressed: (){
                      selectFile();
                    },
                    icon: Icon(Icons.folder_open), label: Text("selecione"),

                  )
              ),

              //if selectedfile is null then show empty container
              //if file is selected then show upload button
              selectedfile == null?
              Container():
              Container(
                  child:ElevatedButton.icon(
                    onPressed: (){
                      uploadFile();
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text("Carregue o ficheiro"),
                  )
              )

            ],)
        )
    );
  }
}
