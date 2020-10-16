import 'package:firebase_auth/firebase_auth.dart';

class ObjectFactory {
  static final _objectFactory = ObjectFactory._internal();

  ObjectFactory._internal();

  factory ObjectFactory() => _objectFactory;

  //Initialisation of Objects
  FirebaseAuth _auth = FirebaseAuth.instance;

  ///
  /// Getters of Objects
  ///

  FirebaseAuth get auth => _auth;
}
