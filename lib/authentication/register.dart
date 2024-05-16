import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zomato_users/authentication/login.dart';
import 'package:zomato_users/mainScreen/home_screen.dart';
import 'package:zomato_users/provider/form_state.dart';
import 'package:zomato_users/widgets/error_dialog.dart';
import 'package:zomato_users/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import '../global/global.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  String userImageUrl = "";


  Future<void> _getImage() async{
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async{
    if(imageXFile == null) {
      showDialog(context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image.",
            );
          });
    }
    else {
      if (passwordController.text == confirmPasswordController.text) {
        if (nameController.text.isNotEmpty && emailController.text.isNotEmpty &&
            confirmPasswordController.text.isNotEmpty) {
          showDialog(context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering Account",
                );
              });
          String fileName = DateTime
              .now()
              .millisecondsSinceEpoch
              .toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref()
              .child("users")
              .child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(
              File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask
              .whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl= url;

            //save information to firestore
              authentication();
          });
        }
        else{
          showDialog(context: context,
              builder: (c){
             return ErrorDialog(
               message: "Please enter all the fields data.",
             );
              });
        }
      }
      else {
        showDialog(context: context,
            builder: (c){
              return ErrorDialog(
                message: "Password do not match.",
              );
            });
      }
    }
  }

  void authentication() async {
    User? currentUser;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(context: context,
          builder: (c){
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if(currentUser!= null){
     // saveDataToFirestore
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
      });
    }
  }


  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("users").doc(currentUser.uid).set(
      {
        "uid": currentUser.uid,
        "email": currentUser.email,
        "name": nameController.text.trim(),
        "photoUrl": userImageUrl,
        "status": "approved",
        "userCart": ["garbageValue"],
      }
    );

    // save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", userImageUrl);
    await sharedPreferences!.setStringList ("userCart", ["garbageValue"]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Register Page",
            style: TextStyle(
              fontSize: 20,
              color: zomatocolor,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
                padding: EdgeInsets.all(10.0),
                child:Consumer<RegisterFormData>(
                  builder: (context, registerFormData, _) => TextButton(
                    onPressed: registerFormData.isButtonEnabled()
                        ? () {
                      // formValidation
                      formValidation();
                    } : null,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: registerFormData.isButtonEnabled() ? zomatocolor : Colors.grey,
                      ),
                    ),
                  ),
                )
            )
          ],
        ),
        body:GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.message_outlined,
                        color: zomatocolor,
                        size: 100,),),

                    const SizedBox(height: 15,),

                    Text("Enter your credentials",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),),

                    const SizedBox(height: 15,),

                    // const Text("We'll check if you have an account.",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //   ),
                    // ),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          //_getImage();
                          _getImage();
                        },
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.2,
                          backgroundColor: Color(0xfff5e9ef),
                          backgroundImage: imageXFile== null? null : FileImage(File(imageXFile!.path)),
                          child: imageXFile == null ?
                          Icon(
                            Icons.add_photo_alternate,
                            size: MediaQuery.of(context).size.width *0.2,
                            color: zomatocolor,
                          ) : null,
                          ),
                        ),
                      ),

                    SizedBox(height: 10,),

                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //customTextField
                            CustomTextField(
                              data: Icons.person,
                              controller: nameController,
                              hintText: "Name",
                              isObsecre: false,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).name = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.email,
                              controller: emailController,
                              hintText: "Email",
                              isObsecre: false,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).email = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.lock,
                              controller: passwordController,
                              hintText: "Password",
                              isObsecre: true,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).password = value;
                              },
                            ),
                            CustomTextField(
                              data: Icons.lock,
                              controller: confirmPasswordController,
                              hintText: "Confirm Password",
                              isObsecre: true,
                              onChanged: (value){
                                Provider.of<RegisterFormData>(context, listen: false).confirmPassword = value;
                              },
                            )
                          ],
                        )
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text("Already have an account?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),

                        SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                          },
                          child: Text("Login",
                            style: TextStyle(
                              color: zomatocolor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),)
            ],
          ),
        )
    );
  }
}
