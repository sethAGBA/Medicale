// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:medical/constants/app_colors.dart';
// import 'dart:io'; // Pour utiliser File
// import 'home_screen.dart';
// import 'package:permission_handler/permission_handler.dart';

// enum CountryCode {
//   togo('+228', Colors.green, 'assets/images/togo_flag.png'),
//   france('+33', Colors.blue, 'assets/images/france_flag.png'),
//   usa('+1', Colors.red, 'assets/images/usa_flag.jpeg');

//   final String code;
//   final Color color;
//   final String flagPath;
//   const CountryCode(this.code, this.color, this.flagPath);
// }

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _dobController = TextEditingController();
//   String _selectedGender = 'Homme';
//   bool _obscureText = true;
//   bool _obscureConfirmText = true;
//   bool _isLoading = false;
//   bool _usePhoneNumber = false;
//   File? _image;
//   CountryCode _selectedCountry = CountryCode.togo;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _dobController.text =
//             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }

//   bool _validateEmailOrPhone(String value) {
//     if (_usePhoneNumber) {
//       final fullNumber = _selectedCountry.code + value;
//       print('Validating phone number: $fullNumber'); // Débogage

//       switch (_selectedCountry) {
//         case CountryCode.togo:
//           final phoneRegex = RegExp(r'^\+228[9][0-1][0-9]{6}$');
//           return phoneRegex.hasMatch(fullNumber) && value.length == 8;
//         case CountryCode.france:
//           final phoneRegex = RegExp(r'^\+33[6-7][0-9]{8}$');
//           return phoneRegex.hasMatch(fullNumber) && value.length == 9;
//         case CountryCode.usa:
//           final phoneRegex = RegExp(r'^\+1[2-9][0-9]{9}$');
//           return phoneRegex.hasMatch(fullNumber) && value.length == 10;
//       }
//     } else {
//       final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//       return emailRegex.hasMatch(value);
//     }
//     return false;
//   }

//   bool _validatePassword(String password) {
//     return password.length >= 6;
//   }

//   bool _validateConfirmPassword(String password, String confirmPassword) {
//     return password == confirmPassword && password.length >= 6;
//   }

//   void _handleSignUp(BuildContext context) async {
//     final emailOrPhone = _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final confirmPassword = _confirmPasswordController.text.trim();

//     if (_usernameController.text.isEmpty ||
//         emailOrPhone.isEmpty ||
//         password.isEmpty ||
//         confirmPassword.isEmpty ||
//         _dobController.text.isEmpty ||
//         _image == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Veuillez remplir tous les champs')),
//       );
//       return;
//     }

//     if (!_validateEmailOrPhone(emailOrPhone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(_usePhoneNumber
//               ? 'Veuillez entrer un numéro valide (${_selectedCountry == CountryCode.togo ? "8 chiffres" : _selectedCountry == CountryCode.france ? "9 chiffres" : "10 chiffres"} après ${_selectedCountry.code})'
//               : 'Veuillez entrer un email valide (ex: nom@domaine.com)'),
//         ),
//       );
//       return;
//     }

//     if (!_validatePassword(password)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Le mot de passe doit contenir au moins 6 caractères')),
//       );
//       return;
//     }

//     if (!_validateConfirmPassword(password, confirmPassword)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Les mots de passe ne correspondent pas ou sont trop courts (min. 6 caractères)')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       await Future.delayed(const Duration(seconds: 2));
//       if (!mounted) return;
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//         (Route<dynamic> route) => false,
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur lors de l\'inscription: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Center(
//                 child: Image.asset(
//                   'assets/images/register.png',
//                   height: 200,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               const Text(
//                 'Rejoignez Nous!',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildTextField('Entrez votre nom', _usernameController, icon: Icons.person),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildPhoneOrEmailField(),
//                   ),
//                   const SizedBox(width: 10),
//                   IconButton(
//                     icon: Icon(
//                       _usePhoneNumber ? Icons.email : Icons.phone,
//                       color: _usePhoneNumber ? Colors.grey : _selectedCountry.color,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _usePhoneNumber = !_usePhoneNumber;
//                         _emailController.clear();
//                         _phoneNumberController.clear();
//                       });
//                     },
//                     tooltip: _usePhoneNumber
//                         ? 'Utiliser un email'
//                         : 'Utiliser un numéro de téléphone',
//                   ),
//                 ],
//               ),
//               _buildPasswordField('Entrez votre mot de passe', _passwordController, _obscureText, () {
//                 setState(() => _obscureText = !_obscureText);
//               }),
//               _buildPasswordField('Confirmez votre mot de passe', _confirmPasswordController, _obscureConfirmText, () {
//                 setState(() => _obscureConfirmText = !_obscureConfirmText);
//               }),
//               _buildDateField('Entrez votre date de naissance', _dobController, context),
//               _buildGenderDropdown(),
//               ElevatedButton(
//                 onPressed: _pickImage,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                     side: const BorderSide(color: Colors.white, width: 1.0),
//                   ),
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
//                 ),
//                 child: const Text(
//                   'Cliquez pour sélectionner une photo de profil',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (_image != null)
//                 Center(
//                   child: Image.file(
//                     _image!,
//                     height: 100,
//                     width: 100,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : () => _handleSignUp(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 7, 56, 9),
//                   padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
//                   textStyle: const TextStyle(fontSize: 18),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.person_add, color: Colors.white),
//                           SizedBox(width: 10),
//                           Text("Inscription", style: TextStyle(color: Colors.white)),
//                         ],
//                       ),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Vous avez déjà un compte ?",
//                     style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushReplacementNamed(context, '/signin');
//                     },
//                     child: const Text(
//                       'Connexion',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String hintText, TextEditingController controller, {IconData? icon}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.text,
//         decoration: InputDecoration(
//           labelText: hintText,
//           prefixIcon: Icon(icon, color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPhoneOrEmailField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: _usePhoneNumber
//           ? Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 DropdownButton<CountryCode>(
//                   value: _selectedCountry,
//                   items: CountryCode.values
//                       .map((country) => DropdownMenuItem(
//                             value: country,
//                             child: Row(
//                               children: [
//                                 Image.asset(
//                                   country.flagPath,
//                                   width: 24,
//                                   height: 24,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   country.code,
//                                   style: TextStyle(color: country.color),
//                                 ),
//                               ],
//                             ),
//                           ))
//                       .toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedCountry = value!;
//                       _phoneNumberController.clear();
//                     });
//                   },
//                   underline: const SizedBox(),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   width: 60,
//                   child: TextField(
//                     controller: TextEditingController(text: _selectedCountry.code),
//                     readOnly: true,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: TextField(
//                     controller: _phoneNumberController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Numéro (ex: ${_selectedCountry == CountryCode.togo ? "90123456" : _selectedCountry == CountryCode.france ? "612345678" : "2025550123"})',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : TextField(
//               controller: _emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: 'Entrez votre email (ex: nom@domaine.com)',
//                 prefixIcon: const Icon(Icons.email, color: Colors.grey),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildPasswordField(String hintText, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         controller: controller,
//         obscureText: obscureText,
//         decoration: InputDecoration(
//           labelText: hintText,
//           prefixIcon: const Icon(Icons.lock),
//           suffixIcon: IconButton(
//             icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
//             onPressed: toggleVisibility,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField(String hintText, TextEditingController controller, BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: TextField(
//         controller: controller,
//         readOnly: true,
//         decoration: InputDecoration(
//           labelText: hintText,
//           prefixIcon: const Icon(Icons.calendar_today),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         onTap: () => _selectDate(context),
//       ),
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: DropdownButtonFormField<String>(
//         value: _selectedGender,
//         items: ['Homme', 'Femme', 'Autre']
//             .map((gender) => DropdownMenuItem(
//                   value: gender,
//                   child: Text(gender),
//                 ))
//             .toList(),
//         onChanged: (value) {
//           setState(() {
//             _selectedGender = value!;
//           });
//         },
//         decoration: InputDecoration(
//           labelText: 'Sélectionnez votre genre',
//           prefixIcon: const Icon(Icons.person),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:io';
// import 'package:medical/constants/app_colors.dart';
// import 'package:medical/screens/home_screen.dart';
// import 'package:medical/models/user_model.dart';

// enum CountryCode {
//   togo('+228', Colors.green, 'assets/images/togo_flag.png'),
//   france('+33', Colors.blue, 'assets/images/france_flag.png'),
//   usa('+1', Colors.red, 'assets/images/usa_flag.jpeg');

//   final String code;
//   final Color color;
//   final String flagPath;
//   const CountryCode(this.code, this.color, this.flagPath);
// }

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _dobController = TextEditingController();

//   String _selectedGender = 'Homme';
//   bool _obscureText = true;
//   bool _obscureConfirmText = true;
//   bool _isLoading = false;
//   bool _usePhoneNumber = false;
//   File? _image;
//   CountryCode _selectedCountry = CountryCode.togo;

//   final ImagePicker _picker = ImagePicker();

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   Future<void> _selectDate() async {
//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2000),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now(),
//     );
//     if (pickedDate != null) {
//       setState(() {
//         _dobController.text =
//             "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() => _image = File(pickedFile.path));
//     }
//   }

//   bool _validateEmailOrPhone(String value) {
//     if (_usePhoneNumber) {
//       final fullNumber = _selectedCountry.code + value;
//       switch (_selectedCountry) {
//         case CountryCode.togo:
//           return RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(value) && value.length == 8;
//         case CountryCode.france:
//           return RegExp(r'^[6-7][0-9]{8}$').hasMatch(value) && value.length == 9;
//         case CountryCode.usa:
//           return RegExp(r'^[2-9][0-9]{9}$').hasMatch(value) && value.length == 10;
//       }
//     }
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
//   }

//   bool _validatePassword(String password, String confirmPassword) {
//     return password.length >= 6 && password == confirmPassword;
//   }

//   // Future<void> _handleSignUp() async {
//   //   final username = _usernameController.text.trim();
//   //   final emailOrPhone =
//   //       _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//   //   final password = _passwordController.text.trim();
//   //   final confirmPassword = _confirmPasswordController.text.trim();
//   //   final dob = _dobController.text.trim();

//   //   if (username.isEmpty || emailOrPhone.isEmpty || password.isEmpty || dob.isEmpty || _image == null) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Veuillez remplir tous les champs')),
//   //     );
//   //     return;
//   //   }

//   //   if (!_validateEmailOrPhone(emailOrPhone)) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text(_usePhoneNumber
//   //             ? 'Numéro invalide (${_selectedCountry == CountryCode.togo ? "8 chiffres" : _selectedCountry == CountryCode.france ? "9 chiffres" : "10 chiffres"})'
//   //             : 'Email invalide (ex: nom@domaine.com)'),
//   //       ),
//   //     );
//   //     return;
//   //   }

//   //   if (!_validatePassword(password, confirmPassword)) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(content: Text('Mot de passe invalide (min. 6 caractères) ou non correspondant')),
//   //     );
//   //     return;
//   //   }

//   //   setState(() => _isLoading = true);

//   //   try {
//   //     // Préparer les données pour l'API
//   //     final Map<String, dynamic> body = {
//   //       'username': username,
//   //       'password': password,
//   //       'dob': dob,
//   //       'gender': _selectedGender,
//   //       if (_usePhoneNumber) 'phoneNumber': _selectedCountry.code + emailOrPhone,
//   //       if (!_usePhoneNumber) 'email': emailOrPhone,
//   //     };

//   //     // Simuler l'upload de l'image (à remplacer par une vraie logique d'upload si nécessaire)
//   //     final response = await http.post(
//   //       Uri.parse('http://localhost:3000/auth/signup'), // URL de votre backend NestJS
//   //       headers: {'Content-Type': 'application/json'},
//   //       body: jsonEncode(body),
//   //     );

//   //     if (response.statusCode == 201) {
//   //       final data = jsonDecode(response.body);
//   //       print('Utilisateur créé: ${data['username']}');
//   //       if (mounted) {
//   //         Navigator.pushAndRemoveUntil(
//   //           context,
//   //           MaterialPageRoute(builder: (_) => const HomeScreen()),
//   //           (Route<dynamic> route) => false,
//   //         );
//   //       }
//   //     } else {
//   //       throw Exception('Erreur ${response.statusCode}: ${response.body}');
//   //     }
//   //   } catch (e) {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Erreur lors de l\'inscription: $e')),
//   //       );
//   //     }
//   //   } finally {
//   //     if (mounted) setState(() => _isLoading = false);
//   //   }
//   // }
// Future<void> _handleSignUp() async {
//   final emailOrPhone = _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//   final password = _passwordController.text.trim();
//   final dob = _dobController.text.trim();

//   try {
//     final response = await http.post(
//       Uri.parse('http://localhost:3000/auth/register'), // Updated endpoint
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'fullName': _usernameController.text.trim(),
//         'email': _usePhoneNumber ? null : emailOrPhone,
//         'phoneNumber': _usePhoneNumber ? _selectedCountry.code + emailOrPhone : null,
//         'password': password,
//         'dateOfBirth': dob, // Ensure format matches backend (e.g., "2023-01-01")
//         'gender': _selectedGender.toLowerCase(), // Match enum: 'male', 'female', 'other'
//         'profilePhoto': _image != null ? 'uploaded_image_url' : null, // Handle separately
//         'role': 'user', // Hardcoded for now; adjust as needed
//       }),
//     );

//     if (response.statusCode == 201) {
//       final data = jsonDecode(response.body);
//       final user = UserModel.fromMap(data['user']);
//       final token = data['access_token'];
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('access_token', token);

//       if (mounted) {
//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/redirect',
//           (route) => false,
//           arguments: user,
//         );
//       }
//     } else {
//       throw Exception('Erreur ${response.statusCode}: ${response.body}');
//     }
//   } catch (e) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
//     }
//   } finally {
//     if (mounted) setState(() => _isLoading = false);
//   }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Image.asset('assets/images/register.png', height: 200, fit: BoxFit.contain),
//             ),
//             const SizedBox(height: 30),
//             const Text(
//               'Rejoignez-nous !',
//               style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//             ),
//             const SizedBox(height: 20),
//             _buildTextField('Nom', _usernameController, Icons.person),
//             _buildEmailOrPhoneField(),
//             _buildPasswordField('Mot de passe', _passwordController, _obscureText, () {
//               setState(() => _obscureText = !_obscureText);
//             }),
//             _buildPasswordField('Confirmer le mot de passe', _confirmPasswordController, _obscureConfirmText, () {
//               setState(() => _obscureConfirmText = !_obscureConfirmText);
//             }),
//             _buildDateField(),
//             _buildGenderDropdown(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               child: const Text('Sélectionner une photo', style: TextStyle(color: Colors.white, fontSize: 16)),
//             ),
//             if (_image != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 10),
//                 child: Center(child: Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover)),
//               ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _isLoading ? null : _handleSignUp,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromARGB(255, 7, 56, 9),
//                 padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//               ),
//               child: _isLoading
//                   ? const CircularProgressIndicator(color: Colors.white)
//                   : const Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.person_add, color: Colors.white),
//                         SizedBox(width: 10),
//                         Text('Inscription', style: TextStyle(color: Colors.white, fontSize: 18)),
//                       ],
//                     ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text('Déjà un compte ? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                 TextButton(
//                   onPressed: () => Navigator.pushNamed(context, '/signin'),
//                   child: const Text('Connexion', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.grey),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailOrPhoneField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           if (_usePhoneNumber) ...[
//             DropdownButton<CountryCode>(
//               value: _selectedCountry,
//               items: CountryCode.values
//                   .map((country) => DropdownMenuItem(
//                         value: country,
//                         child: Row(
//                           children: [
//                             Image.asset(country.flagPath, width: 24, height: 24),
//                             const SizedBox(width: 8),
//                             Text(country.code, style: TextStyle(color: country.color)),
//                           ],
//                         ),
//                       ))
//                   .toList(),
//               onChanged: (value) => setState(() {
//                 _selectedCountry = value!;
//                 _phoneNumberController.clear();
//               }),
//               underline: const SizedBox(),
//             ),
//             const SizedBox(width: 8),
//             SizedBox(
//               width: 60,
//               child: TextField(
//                 controller: TextEditingController(text: _selectedCountry.code),
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//           ],
//           Expanded(
//             child: TextField(
//               controller: _usePhoneNumber ? _phoneNumberController : _emailController,
//               keyboardType: _usePhoneNumber ? TextInputType.phone : TextInputType.emailAddress,
//               decoration: InputDecoration(
//                 labelText: _usePhoneNumber
//                     ? 'Numéro (ex: ${_selectedCountry == CountryCode.togo ? "90123456" : _selectedCountry == CountryCode.france ? "612345678" : "2025550123"})'
//                     : 'Email (ex: nom@domaine.com)',
//                 prefixIcon: Icon(_usePhoneNumber ? Icons.phone : Icons.email, color: Colors.grey),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           IconButton(
//             icon: Icon(_usePhoneNumber ? Icons.email : Icons.phone, color: _usePhoneNumber ? Colors.grey : _selectedCountry.color),
//             onPressed: () => setState(() {
//               _usePhoneNumber = !_usePhoneNumber;
//               _emailController.clear();
//               _phoneNumberController.clear();
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback toggle) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         controller: controller,
//         obscureText: obscure,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: const Icon(Icons.lock, color: Colors.grey),
//           suffixIcon: IconButton(
//             icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
//             onPressed: toggle,
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: TextField(
//         controller: _dobController,
//         readOnly: true,
//         onTap: _selectDate,
//         decoration: InputDecoration(
//           labelText: 'Date de naissance',
//           prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }

//   Widget _buildGenderDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: DropdownButtonFormField<String>(
//         value: _selectedGender,
//         items: ['Homme', 'Femme', 'Autre']
//             .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
//             .toList(),
//         onChanged: (value) => setState(() => _selectedGender = value!),
//         decoration: InputDecoration(
//           labelText: 'Genre',
//           prefixIcon: const Icon(Icons.person, color: Colors.grey),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart';

// enum CountryCode {
//   togo('+228', Colors.green, 'assets/images/togo_flag.png'),
//   france('+33', Colors.blue, 'assets/images/france_flag.png'),
//   usa('+1', Colors.red, 'assets/images/usa_flag.jpeg');

//   final String code;
//   final Color color;
//   final String flagPath;
//   const CountryCode(this.code, this.color, this.flagPath);
// }

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _dobController = TextEditingController();

//   bool _usePhoneNumber = false;
//   bool _obscureText = true;
//   bool _isLoading = false;
//   String _selectedGender = 'male';
//   CountryCode _selectedCountry = CountryCode.togo;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     final fullName = _fullNameController.text.trim();
//     final emailOrPhone =
//         _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final dob = _dobController.text.trim();

//     if (fullName.isEmpty || emailOrPhone.isEmpty || password.isEmpty || dob.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Veuillez remplir tous les champs')),
//       );
//       return;
//     }

//     if (!_usePhoneNumber &&
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailOrPhone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email invalide (ex: nom@domaine.com)')),
//       );
//       return;
//     }

//     if (_usePhoneNumber) {
//       if (_selectedCountry == CountryCode.togo &&
//           !RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(emailOrPhone)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Numéro invalide (ex: 90123456)')),
//         );
//         return;
//       }
//       // Add similar validation for France and USA if needed
//     }

//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Mot de passe trop court (min. 6 caractères)')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'fullName': fullName,
//           'email': _usePhoneNumber ? null : emailOrPhone,
//           'phoneNumber': _usePhoneNumber ? _selectedCountry.code + emailOrPhone : null,
//           'password': password,
//           'dateOfBirth': dob.split('/').reversed.join('-'), // Convert "DD/MM/YYYY" to "YYYY-MM-DD"
//           'gender': _selectedGender,
//           'profilePhoto': null, // Handle image upload separately
//           'role': 'user',
//         }),
//       );

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final user = UserModel.fromMap(data['user']);
//         final token = data['access_token'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('access_token', token);

//         if (mounted) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/redirect',
//             (route) => false,
//             arguments: user,
//           );
//         }
//       } else {
//         throw Exception('Erreur ${response.statusCode}: ${response.body}');
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/register.png', height: 200),
//               const SizedBox(height: 30),
//               const Text(
//                 'Créer un compte',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Nom complet',
//                   prefixIcon: const Icon(Icons.person, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildEmailOrPhoneField(),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   labelText: 'Mot de passe',
//                   prefixIcon: const Icon(Icons.lock, color: Colors.grey),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _dobController,
//                 decoration: InputDecoration(
//                   labelText: 'Date de naissance (JJ/MM/AAAA)',
//                   prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     _dobController.text = '${date.day}/${date.month}/${date.year}';
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 items: ['male', 'female', 'other']
//                     .map((gender) => DropdownMenuItem(
//                           value: gender,
//                           child: Text(gender == 'male'
//                               ? 'Homme'
//                               : gender == 'female'
//                                   ? 'Femme'
//                                   : 'Autre'),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedGender = value!),
//                 decoration: InputDecoration(
//                   labelText: 'Sexe',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSignUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 7, 56, 9),
//                   padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('S\'inscrire', style: TextStyle(color: Colors.white, fontSize: 18)),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center, // Fixed typo here
//                 children: [
//                   const Text('Déjà un compte ? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   TextButton(
//                     onPressed: () => Navigator.pushNamed(context, '/signin'),
//                     child: const Text('Connectez-vous', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailOrPhoneField() {
//     return Row(
//       children: [
//         if (_usePhoneNumber) ...[
//           DropdownButton<CountryCode>(
//             value: _selectedCountry,
//             items: CountryCode.values
//                 .map((country) => DropdownMenuItem(
//                       value: country,
//                       child: Row(
//                         children: [
//                           Image.asset(country.flagPath, width: 24, height: 24),
//                           const SizedBox(width: 8),
//                           Text(country.code, style: TextStyle(color: country.color)),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (value) => setState(() {
//               _selectedCountry = value!;
//               _phoneNumberController.clear();
//             }),
//             underline: const SizedBox(),
//           ),
//           const SizedBox(width: 8),
//           SizedBox(
//             width: 60,
//             child: TextField(
//               controller: TextEditingController(text: _selectedCountry.code),
//               readOnly: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//         Expanded(
//           child: TextField(
//             controller: _usePhoneNumber ? _phoneNumberController : _emailController,
//             keyboardType: _usePhoneNumber ? TextInputType.phone : TextInputType.emailAddress,
//             decoration: InputDecoration(
//               labelText: _usePhoneNumber
//                   ? 'Numéro (ex: ${_selectedCountry == CountryCode.togo ? "90123456" : _selectedCountry == CountryCode.france ? "612345678" : "2025550123"})'
//                   : 'Email (ex: nom@domaine.com)',
//               prefixIcon: Icon(_usePhoneNumber ? Icons.phone : Icons.email, color: Colors.grey),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         IconButton(
//           icon: Icon(_usePhoneNumber ? Icons.email : Icons.phone, color: _usePhoneNumber ? Colors.grey : _selectedCountry.color),
//           onPressed: () => setState(() {
//             _usePhoneNumber = !_usePhoneNumber;
//             _emailController.clear();
//             _phoneNumberController.clear();
//           }),
//         ),
//       ],
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart';
// import '../config.dart';

// enum CountryCode {
//   togo('+228', Colors.green, 'assets/images/togo_flag.png'),
//   france('+33', Colors.blue, 'assets/images/france_flag.png'),
//   usa('+1', Colors.red, 'assets/images/usa_flag.jpeg');

//   final String code;
//   final Color color;
//   final String flagPath;
//   const CountryCode(this.code, this.color, this.flagPath);
// }

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _dobController = TextEditingController();

//   bool _usePhoneNumber = false;
//   bool _obscureText = true;
//   bool _isLoading = false;
//   String _selectedGender = 'male';
//   CountryCode _selectedCountry = CountryCode.togo;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     final fullName = _fullNameController.text.trim();
//     final emailOrPhone =
//         _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final dob = _dobController.text.trim();

//     if (fullName.isEmpty || emailOrPhone.isEmpty || password.isEmpty || dob.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Veuillez remplir tous les champs')),
//       );
//       return;
//     }

//     if (!_usePhoneNumber &&
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailOrPhone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email invalide (ex: nom@domaine.com)')),
//       );
//       return;
//     }

//     if (_usePhoneNumber) {
//       if (_selectedCountry == CountryCode.togo &&
//           !RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(emailOrPhone)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Numéro invalide (ex: 90123456)')),
//         );
//         return;
//       }
//     }

//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Mot de passe trop court (min. 6 caractères)')),
//       );
//       return;
//     }

//     // Validate and format dateOfBirth
//     String formattedDob;
//     try {
//       final parts = dob.split('/');
//       if (parts.length != 3) throw FormatException('Format attendu: JJ/MM/AAAA');
//       final day = int.parse(parts[0]);
//       final month = int.parse(parts[1]);
//       final year = int.parse(parts[2]);
//       formattedDob = DateTime(year, month, day).toIso8601String(); // Full ISO 8601
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Date de naissance invalide (ex: 21/03/1990)')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final requestBody = {
//         'fullName': fullName,
//         'email': _usePhoneNumber ? null : emailOrPhone,
//         'phoneNumber': _usePhoneNumber ? _selectedCountry.code + emailOrPhone : null,
//         'password': password,
//         'dateOfBirth': formattedDob, // e.g., "1990-03-21T00:00:00.000Z"
//         'gender': _selectedGender,
//         'profilePhoto': null,
//         'role': 'user',
//       };

//       // Log the request body
//       print('Request Body: ${jsonEncode(requestBody)}');

//       final response = await http.post(
//         Uri.parse('${Config.baseUrl}/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       print('Response Status: ${response.statusCode}');
//       print('Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final user = UserModel.fromMap(data['user']);
//         final token = data['access_token'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('access_token', token);

//         if (mounted) {
//           Navigator.pushNamedAndRemoveUntil(
//             context,
//             '/redirect',
//             (route) => false,
//             arguments: user,
//           );
//         }
//       } else {
//         throw Exception('Échec de l\'inscription: ${response.statusCode} - ${response.body}');
//       }
//     } on FormatException catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur de format de réponse: $e')),
//         );
//       }
//     } on http.ClientException catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur réseau: $e')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur inattendue: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/register.png', height: 200),
//               const SizedBox(height: 30),
//               const Text(
//                 'Créer un compte',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Nom complet',
//                   prefixIcon: const Icon(Icons.person, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildEmailOrPhoneField(),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   labelText: 'Mot de passe',
//                   prefixIcon: const Icon(Icons.lock, color: Colors.grey),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _dobController,
//                 decoration: InputDecoration(
//                   labelText: 'Date de naissance (JJ/MM/AAAA)',
//                   prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     _dobController.text = '${date.day}/${date.month}/${date.year}';
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 items: ['male', 'female', 'other']
//                     .map((gender) => DropdownMenuItem(
//                           value: gender,
//                           child: Text(gender == 'male'
//                               ? 'Homme'
//                               : gender == 'female'
//                                   ? 'Femme'
//                                   : 'Autre'),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedGender = value!),
//                 decoration: InputDecoration(
//                   labelText: 'Sexe',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSignUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 7, 56, 9),
//                   padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('S\'inscrire', style: TextStyle(color: Colors.white, fontSize: 18)),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Déjà un compte ? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   TextButton(
//                     onPressed: () => Navigator.pushNamed(context, '/signin'),
//                     child: const Text('Connectez-vous', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailOrPhoneField() {
//     return Row(
//       children: [
//         if (_usePhoneNumber) ...[
//           DropdownButton<CountryCode>(
//             value: _selectedCountry,
//             items: CountryCode.values
//                 .map((country) => DropdownMenuItem(
//                       value: country,
//                       child: Row(
//                         children: [
//                           Image.asset(country.flagPath, width: 24, height: 24),
//                           const SizedBox(width: 8),
//                           Text(country.code, style: TextStyle(color: country.color)),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (value) => setState(() {
//               _selectedCountry = value!;
//               _phoneNumberController.clear();
//             }),
//             underline: const SizedBox(),
//           ),
//           const SizedBox(width: 8),
//           SizedBox(
//             width: 60,
//             child: TextField(
//               controller: TextEditingController(text: _selectedCountry.code),
//               readOnly: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//         Expanded(
//           child: TextField(
//             controller: _usePhoneNumber ? _phoneNumberController : _emailController,
//             keyboardType: _usePhoneNumber ? TextInputType.phone : TextInputType.emailAddress,
//             decoration: InputDecoration(
//               labelText: _usePhoneNumber
//                   ? 'Numéro (ex: ${_selectedCountry == CountryCode.togo ? "90123456" : _selectedCountry == CountryCode.france ? "612345678" : "2025550123"})'
//                   : 'Email (ex: nom@domaine.com)',
//               prefixIcon: Icon(_usePhoneNumber ? Icons.phone : Icons.email, color: Colors.grey),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         IconButton(
//           icon: Icon(_usePhoneNumber ? Icons.email : Icons.phone, color: _usePhoneNumber ? Colors.grey : _selectedCountry.color),
//           onPressed: () => setState(() {
//             _usePhoneNumber = !_usePhoneNumber;
//             _emailController.clear();
//             _phoneNumberController.clear();
//           }),
//         ),
//       ],
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart';
// import '../config.dart';

// enum CountryCode {
//   togo('+228', Colors.green, 'assets/images/togo_flag.png'),
//   france('+33', Colors.blue, 'assets/images/france_flag.png'),
//   usa('+1', Colors.red, 'assets/images/usa_flag.jpeg');

//   final String code;
//   final Color color;
//   final String flagPath;
//   const CountryCode(this.code, this.color, this.flagPath);
// }

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _dobController = TextEditingController();

//   bool _usePhoneNumber = false;
//   bool _obscureText = true;
//   bool _isLoading = false;
//   String _selectedGender = 'male';
//   String _selectedRole = 'user'; // New field for role selection
//   CountryCode _selectedCountry = CountryCode.togo;

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();
//     _passwordController.dispose();
//     _dobController.dispose();
//     super.dispose();
//   }

//   Future<void> _handleSignUp() async {
//     final fullName = _fullNameController.text.trim();
//     final emailOrPhone =
//         _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
//     final password = _passwordController.text.trim();
//     final dob = _dobController.text.trim();

//     if (fullName.isEmpty || emailOrPhone.isEmpty || password.isEmpty || dob.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Veuillez remplir tous les champs')),
//       );
//       return;
//     }

//     if (!_usePhoneNumber &&
//         !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailOrPhone)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Email invalide (ex: nom@domaine.com)')),
//       );
//       return;
//     }

//     if (_usePhoneNumber) {
//       if (_selectedCountry == CountryCode.togo &&
//           !RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(emailOrPhone)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Numéro invalide (ex: 90123456)')),
//         );
//         return;
//       }
//     }

//     if (password.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Mot de passe trop court (min. 6 caractères)')),
//       );
//       return;
//     }

//     String formattedDob;
//     try {
//       final parts = dob.split('/');
//       if (parts.length != 3) throw FormatException('Format attendu: JJ/MM/AAAA');
//       final day = int.parse(parts[0]);
//       final month = int.parse(parts[1]);
//       final year = int.parse(parts[2]);
//       formattedDob = DateTime(year, month, day).toIso8601String();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Date de naissance invalide (ex: 21/03/1990)')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final requestBody = {
//         'fullName': fullName,
//         'email': _usePhoneNumber ? null : emailOrPhone,
//         'phoneNumber': _usePhoneNumber ? _selectedCountry.code + emailOrPhone : null,
//         'password': password,
//         'dateOfBirth': formattedDob,
//         'gender': _selectedGender,
//         'profilePhoto': null,
//         'role': _selectedRole, // Use selected role
//       };

//       print('Signup Request Body: ${jsonEncode(requestBody)}');

//       final response = await http.post(
//         Uri.parse('${Config.baseUrl}/auth/register'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       print('Signup Response Status: ${response.statusCode}');
//       print('Signup Response Body: ${response.body}');

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         final user = UserModel.fromMap(data['user']);
//         final token = data['access_token'];

//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('access_token', token);

//         print('User Model: ${user.toJson()}');
//         print('Attempting navigation to /redirect');

//         Navigator.pushNamedAndRemoveUntil(
//           context,
//           '/redirect',
//           (route) => false,
//           arguments: user,
//         );
//         print('Navigation executed successfully');
//       } else {
//         throw Exception('Échec de l\'inscription: ${response.statusCode} - ${response.body}');
//       }
//     } on FormatException catch (e) {
//       print('FormatException: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur de format de réponse: $e')),
//         );
//       }
//     } on http.ClientException catch (e) {
//       print('ClientException: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur réseau: $e')),
//         );
//       }
//     } catch (e) {
//       print('Caught exception: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur inattendue: $e')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/signup.png', height: 200),
//               const SizedBox(height: 30),
//               const Text(
//                 'Créer un compte',
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: _fullNameController,
//                 decoration: InputDecoration(
//                   labelText: 'Nom complet',
//                   prefixIcon: const Icon(Icons.person, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               _buildEmailOrPhoneField(),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: _obscureText,
//                 decoration: InputDecoration(
//                   labelText: 'Mot de passe',
//                   prefixIcon: const Icon(Icons.lock, color: Colors.grey),
//                   suffixIcon: IconButton(
//                     icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
//                     onPressed: () => setState(() => _obscureText = !_obscureText),
//                   ),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _dobController,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: 'Date de naissance (JJ/MM/AAAA)',
//                   prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onTap: () async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (date != null) {
//                     _dobController.text = '${date.day}/${date.month}/${date.year}';
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedGender,
//                 items: ['male', 'female', 'other']
//                     .map((gender) => DropdownMenuItem(
//                           value: gender,
//                           child: Text(gender == 'male'
//                               ? 'Homme'
//                               : gender == 'female'
//                                   ? 'Femme'
//                                   : 'Autre'),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedGender = value!),
//                 decoration: InputDecoration(
//                   labelText: 'Sexe',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: _selectedRole,
//                 items: ['user', 'professional', 'admin']
//                     .map((role) => DropdownMenuItem(
//                           value: role,
//                           child: Text(role == 'user'
//                               ? 'Utilisateur'
//                               : role == 'professional'
//                                   ? 'Professionnel'
//                                   : 'Administrateur'),
//                         ))
//                     .toList(),
//                 onChanged: (value) => setState(() => _selectedRole = value!),
//                 decoration: InputDecoration(
//                   labelText: 'Rôle',
//                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _handleSignUp,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 7, 56, 9),
//                   padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                 ),
//                 child: _isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('S\'inscrire', style: TextStyle(color: Colors.white, fontSize: 18)),
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('Déjà un compte ? ', style: TextStyle(fontSize: 16, color: Colors.grey)),
//                   TextButton(
//                     onPressed: () => Navigator.pushNamed(context, '/signin'),
//                     child: const Text('Connectez-vous', style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmailOrPhoneField() {
//     return Row(
//       children: [
//         if (_usePhoneNumber) ...[
//           DropdownButton<CountryCode>(
//             value: _selectedCountry,
//             items: CountryCode.values
//                 .map((country) => DropdownMenuItem(
//                       value: country,
//                       child: Row(
//                         children: [
//                           Image.asset(country.flagPath, width: 24, height: 24),
//                           const SizedBox(width: 8),
//                           Text(country.code, style: TextStyle(color: country.color)),
//                         ],
//                       ),
//                     ))
//                 .toList(),
//             onChanged: (value) => setState(() {
//               _selectedCountry = value!;
//               _phoneNumberController.clear();
//             }),
//             underline: const SizedBox(),
//           ),
//           const SizedBox(width: 8),
//           SizedBox(
//             width: 60,
//             child: TextField(
//               controller: TextEditingController(text: _selectedCountry.code),
//               readOnly: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                 filled: true,
//                 fillColor: Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//         ],
//         Expanded(
//           child: TextField(
//             controller: _usePhoneNumber ? _phoneNumberController : _emailController,
//             keyboardType: _usePhoneNumber ? TextInputType.phone : TextInputType.emailAddress,
//             decoration: InputDecoration(
//               labelText: _usePhoneNumber
//                   ? 'Numéro (ex: ${_selectedCountry == CountryCode.togo ? "90123456" : _selectedCountry == CountryCode.france ? "612345678" : "2025550123"})'
//                   : 'Email (ex: nom@domaine.com)',
//               prefixIcon: Icon(_usePhoneNumber ? Icons.phone : Icons.email, color: Colors.grey),
//               border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         IconButton(
//           icon: Icon(_usePhoneNumber ? Icons.email : Icons.phone, color: _usePhoneNumber ? Colors.grey : _selectedCountry.color),
//           onPressed: () => setState(() {
//             _usePhoneNumber = !_usePhoneNumber;
//             _emailController.clear();
//             _phoneNumberController.clear();
//           }),
//         ),
//       ],
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical/constants/app_colors.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../config.dart';
import '../services/auth_service.dart';

enum CountryCode {
  togo('+228', AppColors.success, 'assets/images/togo_flag.png'),
  france('+33', AppColors.primary, 'assets/images/france_flag.png'),
  usa('+1', AppColors.error, 'assets/images/usa_flag.jpeg');

  final String code;
  final Color color;
  final String flagPath;
  const CountryCode(this.code, this.color, this.flagPath);
}

enum PasswordStrength {
  weak,
  medium,
  strong,
  veryStrong
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dobController = TextEditingController();

  bool _usePhoneNumber = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptedTerms = false;
  String _selectedGender = 'male';
  CountryCode _selectedCountry = CountryCode.togo;
  PasswordStrength _passwordStrength = PasswordStrength.weak;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();

    // Écouter les changements de mot de passe pour la force
    _passwordController.addListener(_updatePasswordStrength);
    // Écouter les changements pour la correspondance des mots de passe
    _passwordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }

  // Ajoutez cette nouvelle méthode pour vérifier la correspondance
  void _checkPasswordMatch() {
    setState(() {
      // Force le rebuild pour afficher les indicateurs de correspondance
    });
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordStrength);
    _passwordController.removeListener(_checkPasswordMatch);
    _confirmPasswordController.removeListener(_checkPasswordMatch);
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength = _calculatePasswordStrength(_passwordController.text);
    });
  }

  PasswordStrength _calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Longueur
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Contient des minuscules
    if (password.contains(RegExp(r'[a-z]'))) score++;

    // Contient des majuscules
    if (password.contains(RegExp(r'[A-Z]'))) score++;

    // Contient des chiffres
    if (password.contains(RegExp(r'[0-9]'))) score++;

    // Contient des caractères spéciaux
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    if (score <= 5) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }

  String _getPasswordStrengthText() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return 'Faible';
      case PasswordStrength.medium:
        return 'Moyen';
      case PasswordStrength.strong:
        return 'Fort';
      case PasswordStrength.veryStrong:
        return 'Très fort';
    }
  }

  Color _getPasswordStrengthColor() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return AppColors.error;
      case PasswordStrength.medium:
        return Colors.orange;
      case PasswordStrength.strong:
        return Colors.lightGreen;
      case PasswordStrength.veryStrong:
        return AppColors.success;
    }
  }

  double _getPasswordStrengthProgress() {
    switch (_passwordStrength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.medium:
        return 0.5;
      case PasswordStrength.strong:
        return 0.75;
      case PasswordStrength.veryStrong:
        return 1.0;
    }
  }

  bool _validateEmailOrPhone(String value) {
    if (_usePhoneNumber) {
      switch (_selectedCountry) {
        case CountryCode.togo:
          return RegExp(r'^[9][0-1][0-9]{6}$').hasMatch(value) && value.length == 8;
        case CountryCode.france:
          return RegExp(r'^[6-7][0-9]{8}$').hasMatch(value) && value.length == 9;
        case CountryCode.usa:
          return RegExp(r'^[2-9][0-9]{9}$').hasMatch(value) && value.length == 10;
      }
    }
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  bool _isPasswordStrong() {
    return _passwordStrength == PasswordStrength.strong || 
           _passwordStrength == PasswordStrength.veryStrong;
  }

  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final emailOrPhone = _usePhoneNumber ? _phoneNumberController.text.trim() : _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final dob = _dobController.text.trim();

    // Validation des champs vides
    if (fullName.isEmpty || emailOrPhone.isEmpty || password.isEmpty || confirmPassword.isEmpty || dob.isEmpty) {
      _showSnackBar('Veuillez remplir tous les champs', isError: true);
      return;
    }

    // Validation du nom complet
    if (fullName.length < 3) {
      _showSnackBar('Le nom doit contenir au moins 3 caractères', isError: true);
      return;
    }

    // Validation email/téléphone
    if (!_validateEmailOrPhone(emailOrPhone)) {
      _showSnackBar(
        _usePhoneNumber
            ? 'Numéro invalide (${_selectedCountry == CountryCode.togo ? "8 chiffres" : _selectedCountry == CountryCode.france ? "9 chiffres" : "10 chiffres"})'
            : 'Email invalide (ex: nom@domaine.com)',
        isError: true,
      );
      return;
    }

    // Validation de la force du mot de passe
    if (!_isPasswordStrong()) {
      _showSnackBar('Veuillez choisir un mot de passe plus robuste', isError: true);
      return;
    }

    // Validation de la confirmation du mot de passe
    if (password != confirmPassword) {
      _showSnackBar('Les mots de passe ne correspondent pas', isError: true);
      return;
    }

    // Validation des conditions d'utilisation
    if (!_acceptedTerms) {
      _showSnackBar('Veuillez accepter les conditions d\'utilisation', isError: true);
      return;
    }

    // Validation de l'âge (au moins 13 ans)
    String formattedDob;
    try {
      final parts = dob.split('/');
      if (parts.length != 3) throw FormatException('Format attendu: JJ/MM/AAAA');
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      
      final birthDate = DateTime(year, month, day);
      final age = DateTime.now().difference(birthDate).inDays ~/ 365;
      
      if (age < 13) {
        _showSnackBar('Vous devez avoir au moins 13 ans pour vous inscrire', isError: true);
        return;
      }
      
      formattedDob = birthDate.toIso8601String();
    } catch (e) {
      _showSnackBar('Date de naissance invalide (ex: 21/03/1990)', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final requestBody = {
        'fullName': fullName,
        'email': _usePhoneNumber ? null : emailOrPhone,
        'phoneNumber': _usePhoneNumber ? _selectedCountry.code + emailOrPhone : null,
        'password': password,
        'dateOfBirth': formattedDob,
        'gender': _selectedGender,
        'profilePhoto': null,
        'role': 'user',
      };

      print('Request URL: ${Config.authUrl}/register');
      print('Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('${Config.authUrl}/register'),
        headers: Config.defaultHeaders,
        body: jsonEncode(requestBody),
      ).timeout(Config.timeoutDuration);

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromMap(data['user']);
        final token = data['access_token'];

        await AuthService.saveUserAndToken(user, token);

        if (mounted) {
          _showSnackBar('Compte créé avec succès !', isError: false);
          
          // Navigation après un court délai
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/redirect',
                (route) => false,
                arguments: user,
              );
            }
          });
        }
      } else if (response.statusCode == 409) {
        throw Exception('Ce compte existe déjà');
      } else {
        throw Exception('Échec de l\'inscription: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erreur capturée: $e');
      if (mounted) {
        String errorMessage = 'Erreur d\'inscription. Veuillez réessayer.';
        if (e.toString().contains('existe déjà')) {
          errorMessage = 'Un compte avec cet email/téléphone existe déjà';
        }
        _showSnackBar(errorMessage, isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: AppColors.textLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.textLight),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        elevation: 6,
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Politique de confidentialité',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicySection(
                      'Protection de vos données',
                      'Vos données de santé sont cryptées et stockées de manière sécurisée conformément au RGPD et aux normes HIPAA.',
                    ),
                    _buildPolicySection(
                      'Collecte d\'informations',
                      'Nous collectons uniquement les informations nécessaires pour vous fournir nos services de santé : nom, contact, date de naissance et données médicales.',
                    ),
                    _buildPolicySection(
                      'Partage des données',
                      'Vos données ne sont jamais vendues à des tiers. Elles sont uniquement partagées avec les professionnels de santé que vous consultez.',
                    ),
                    _buildPolicySection(
                      'Vos droits',
                      'Vous pouvez à tout moment accéder, modifier ou supprimer vos données personnelles depuis les paramètres de votre compte.',
                    ),
                    _buildPolicySection(
                      'Sécurité',
                      'Nous utilisons des protocoles de sécurité avancés (SSL/TLS, cryptage AES-256) pour protéger vos informations.',
                    ),
                    _buildPolicySection(
                      'Cookies',
                      'Nous utilisons des cookies essentiels pour assurer le bon fonctionnement de l\'application et améliorer votre expérience.',
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Dernière mise à jour : ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primarys,
              AppColors.primary,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Card(
                  elevation: 12,
                  shadowColor: AppColors.shadow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    constraints: const BoxConstraints(maxWidth: 450),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo/Image
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.1),
                                AppColors.secondary.withOpacity(0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/register.png',
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person_add_outlined,
                                size: 60,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Titre
                        Text(
                          'Créer un compte',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Votre santé, notre priorité',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Champs de formulaire
                        _buildFullNameField(),
                        const SizedBox(height: 18),
                        _buildEmailOrPhoneField(),
                        const SizedBox(height: 18),
                        _buildPasswordField(),
                        const SizedBox(height: 18),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 18),
                        _buildDateOfBirthField(),
                        const SizedBox(height: 18),
                        _buildGenderField(),
                        const SizedBox(height: 24),

                        // Note de sécurité
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Inscription sécurisée - Vos données sont protégées',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Conditions d'utilisation
                        _buildTermsCheckbox(),
                        const SizedBox(height: 24),

                        // Bouton d'inscription
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textLight,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 3,
                              shadowColor: AppColors.primary.withOpacity(0.4),
                              disabledBackgroundColor: AppColors.textSecondary.withOpacity(0.3),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: AppColors.textLight,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.how_to_reg, size: 22),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Créer mon compte',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Divider avec texte
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.textSecondary.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'OU',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.textSecondary.withOpacity(0.3),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Lien de connexion
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Déjà un compte ? ',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/signin'),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Connectez-vous',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom complet',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _fullNameController,
          textCapitalization: TextCapitalization.words,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'Jean Dupont',
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailOrPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _usePhoneNumber ? 'Numéro de téléphone' : 'Adresse email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.textSecondary.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  _buildToggleButton(
                    icon: Icons.email_outlined,
                    isSelected: !_usePhoneNumber,
                    onTap: () {
                      if (_usePhoneNumber) {
                        setState(() {
                          _usePhoneNumber = false;
                          _phoneNumberController.clear();
                        });
                      }
                    },
                  ),
                  _buildToggleButton(
                    icon: Icons.phone_outlined,
                    isSelected: _usePhoneNumber,
                    onTap: () {
                      if (!_usePhoneNumber) {
                        setState(() {
                          _usePhoneNumber = true;
                          _emailController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_usePhoneNumber)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textSecondary.withOpacity(0.3),
                  ),
                ),
                child: DropdownButton<CountryCode>(
                  value: _selectedCountry,
                  underline: const SizedBox(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                  items: CountryCode.values.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              country.flagPath,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: country.color.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Icon(
                                    Icons.flag,
                                    size: 16,
                                    color: country.color,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            country.code,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value!;
                      _phoneNumberController.clear();
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: _selectedCountry == CountryCode.togo
                        ? '90 12 34 56'
                        : _selectedCountry == CountryCode.france
                            ? '6 12 34 56 78'
                            : '202 555 0123',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.phone, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.secondary, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ],
          )
        else
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'nom@exemple.com',
              hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.secondary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppColors.textLight : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          // Indicateur de force du mot de passe
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _getPasswordStrengthProgress(),
                    backgroundColor: AppColors.textSecondary.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getPasswordStrengthColor(),
                    ),
                    minHeight: 4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _getPasswordStrengthText(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getPasswordStrengthColor(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Utilisez 8+ caractères avec majuscules, chiffres et symboles',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmer le mot de passe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
        if (_confirmPasswordController.text.isNotEmpty && 
            _passwordController.text != _confirmPasswordController.text) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.error_outline, size: 14, color: AppColors.error),
              const SizedBox(width: 6),
              Text(
                'Les mots de passe ne correspondent pas',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ] else if (_confirmPasswordController.text.isNotEmpty && 
                   _passwordController.text == _confirmPasswordController.text) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.check_circle_outline, size: 14, color: AppColors.success),
              const SizedBox(width: 6),
              Text(
                'Les mots de passe correspondent',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date de naissance',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _dobController,
          readOnly: true,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: 'JJ/MM/AAAA',
            hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
            prefixIcon: Icon(Icons.calendar_today_outlined, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.textSecondary.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.secondary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime(2000),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: AppColors.primary,
                      onPrimary: AppColors.textLight,
                      surface: AppColors.cardBackground,
                      onSurface: AppColors.textPrimary,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              _dobController.text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
            }
          },
        ),
      ],
    );
  }

  Widget _buildGenderField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sexe',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.textSecondary.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              prefixIcon: Icon(
                _selectedGender == 'male'
                    ? Icons.male
                    : _selectedGender == 'female'
                        ? Icons.female
                        : Icons.transgender,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            dropdownColor: AppColors.cardBackground,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            items: [
              DropdownMenuItem(
                value: 'male',
                child: Row(
                  children: [
                    Icon(Icons.male, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    const Text('Homme'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Row(
                  children: [
                    Icon(Icons.female, color: Colors.pink, size: 20),
                    const SizedBox(width: 8),
                    const Text('Femme'),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Row(
                  children: [
                    Icon(Icons.transgender, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    const Text('Autre'),
                  ],
                ),
              ),
            ],
            onChanged: (value) => setState(() => _selectedGender = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return InkWell(
      onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _acceptedTerms ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _acceptedTerms ? AppColors.primary : AppColors.textSecondary.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: _acceptedTerms
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textLight,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                        'J\'accepte les ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showPrivacyPolicy,
                        child: Text(
                          'conditions d\'utilisation',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        ' et la ',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showPrivacyPolicy,
                        child: Text(
                          'politique de confidentialité',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}