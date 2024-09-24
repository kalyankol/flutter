import 'package:chatapp/widgets/imagepicker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatapp/firebase_options.dart';

final auth=FirebaseAuth.instance;

class Log extends StatefulWidget {
  const Log({super.key});

  @override
  State<Log> createState() => _LogState();
}

class _LogState extends State<Log> {
  bool _isLog=true;
  var _email="";
  var _password="";
  final _form=GlobalKey<FormState>();
  void _onsubmit() async{
    final valid=_form.currentState!.validate();

    if(!valid){
      return;
    }

    _form.currentState!.save();

    try{
      if(_isLog){
        final UserCredential= await auth.signInWithEmailAndPassword(email: _email, password: _password);
      }
      else{
        final UserCredential= await auth.createUserWithEmailAndPassword(email: _email, password: _password);
        print(UserCredential);
      }
    }
    on FirebaseAuthException catch(error){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? 'Authentication Failed'),
            )
        );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20
                ),
                width: 200,
                child: const Image(image: AssetImage("assets/logo.png")),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if(!_isLog) const UserImage(),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Email Address"
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value){
                                if(value==null || value.trim().isEmpty || !value.contains('@')){
                                  return "Enter a valid Email";
                                }
                                return null;
                              },
                              onSaved: (value){
                                _email=value!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "password"
                              ),
                              obscureText: true,
                              validator: (value){
                                if(value==null || value.trim().length<6){
                                  return "password must be 6 characters long";
                                }
                                return null;
                              },
                              onSaved: (value){
                                _password=value!;
                              },
                            ),
                            const SizedBox(height: 12,),
                            ElevatedButton(
                              onPressed: _onsubmit, 
                              child: Text(_isLog ? "Login" : "Sign up")
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  _isLog=!_isLog;
                                });
                              }, 
                              child: Text(_isLog ? "Create an account" : "I already have an account")
                            )
                          ],
                        ) 
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}