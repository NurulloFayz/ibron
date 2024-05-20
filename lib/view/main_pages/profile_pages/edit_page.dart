import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ibron/controller/edit_page_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  static const String id = 'editProfilePage';
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  EditPageController controller = EditPageController();
  late String id;
  String? pickedImagePath;

// Inside the openGallery method, update the pickedImagePath
  void openGallery() async {
    var pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        pickedImagePath = pickedImage.path;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getId();
  }
  Future<void> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? ''; // Retrieve the ID or assign an empty string if it's null
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text('Редактировать профиль',style: GoogleFonts.roboto(textStyle: TextStyle(
            fontSize: screenHeight / 40,fontWeight: FontWeight.w400
        )),),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: screenHeight / 50,),
              GestureDetector(
                onTap: () {
                  openGallery();
                },
                child: ClipOval(
                  child: CircleAvatar(
                    radius: screenHeight / 13,
                    backgroundColor: Colors.transparent,
                    child: pickedImagePath != null
                        ? Image.file(
                      File(pickedImagePath!),
                      fit: BoxFit.cover, // Set BoxFit.cover here
                    )
                        : Icon(
                      Icons.camera_alt,
                      size: screenHeight / 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 30,),
              Row(
                children: [
                  SizedBox(width: screenWidth / 30,),
                  Text('Имя',style: GoogleFonts.roboto(textStyle: TextStyle(
                      fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                  ))),
                ],
              ),
              SizedBox(height: screenHeight / 100,),
              Container(
                margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                child: TextField(
                  controller: controller.firstname,
                  decoration: InputDecoration(
                      hintText: 'Введите имя',
                      hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                          fontWeight: FontWeight.w400
                      )),
                      contentPadding: EdgeInsets.all(screenHeight / 60),
                      filled: true,
                      fillColor:const Color(0xFFF2F4F7),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 50,),
              Row(
                children: [
                  SizedBox(width: screenWidth / 30,),
                  Text('Фамилия',style: GoogleFonts.roboto(textStyle: TextStyle(
                      fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                  ))),
                ],
              ),
              SizedBox(height: screenHeight / 100,),
              Container(
                margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                child: TextField(
                  controller: controller.lastname,
                  decoration: InputDecoration(
                      hintText: 'Введите фамилию',
                      hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                          fontWeight: FontWeight.w400
                      )),
                      contentPadding: EdgeInsets.all(screenHeight / 60),
                      filled: true,
                      fillColor: const Color(0xFFF2F4F7),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 50,),
              Row(
                children: [
                  SizedBox(width: screenWidth / 30,),
                  Text('Дата рождения',style: GoogleFonts.roboto(textStyle: TextStyle(
                      fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                  ))),
                ],
              ),
              SizedBox(height: screenHeight / 100,),
              Container(
                margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                child: TextField(
                  controller: controller.birthday,
                  decoration: InputDecoration(
                      hintText: 'Выберите дата рождения ',
                      hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                          fontWeight: FontWeight.w400
                      )),
                      contentPadding: EdgeInsets.all(screenHeight / 60),
                      filled: true,
                      fillColor: const Color(0xFFF2F4F7),
                      suffixIcon: IconButton(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.calendar_month,color: Colors.grey,),
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 40,),
              Row(
                children: [
                  SizedBox(width: screenWidth / 30,),
                  Text("Пол",style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,fontWeight: FontWeight.w400)),),
                ],
              ),
              SizedBox(height: screenHeight / 70,),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controller.gender = 'Мужчина';
                        print(controller.gender);
                      });
                    },
                    icon: Icon(controller.gender == 'Мужчина' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: Colors.green,
                    ),
                  ),
                  Text('Мужчина', style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: screenHeight / 50,
                        fontWeight: FontWeight.w400
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controller.gender = 'Женщина';
                        print(controller.gender);
                      });
                    },
                    icon: Icon(controller.gender == 'Женщина' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: Colors.green,
                    ),
                  ),
                  Text('Женщина', style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: screenHeight / 50,
                        fontWeight: FontWeight.w400
                    ),
                  )),
                ],
              ),
              SizedBox(height: screenHeight / 50,),
              Row(
                children: [
                  SizedBox(width: screenWidth / 30,),
                  Text('Номер телефона',style: GoogleFonts.roboto(textStyle: TextStyle(
                      fontSize: screenHeight / 50,fontWeight: FontWeight.w400
                  ))),
                ],
              ),
              SizedBox(height: screenHeight / 100,),
              Container(
                margin: EdgeInsets.only(right: screenWidth / 40, left: screenWidth / 40),
                child: TextField(
                  controller:controller.phone,
                  decoration: InputDecoration(
                      hintText: 'Введите номер телефона',
                      hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: screenHeight / 45,color: Colors.grey,
                          fontWeight: FontWeight.w400
                      )),
                      contentPadding: EdgeInsets.all(screenHeight / 60),
                      suffixIcon: const Icon(Icons.create,color: Colors.grey,),
                      filled: true,
                      fillColor:const Color(0xFFF2F4F7),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),
              SizedBox(height: screenHeight / 5,),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: Colors.green,
        onPressed: () {
          if (pickedImagePath != null) {
            // Pass the picked image file to the uploadImage method
            controller.uploadImage(File(pickedImagePath!));
            controller.updateUserInfo(context, id);
          } else {
            // Handle case where no image is selected
            print('No image selected.');
          }
        },
        label: SizedBox(
          width: screenWidth * .8,
          child: Center(
            child: Text('Продолжить',style: GoogleFonts.roboto(textStyle: TextStyle(
                fontSize: screenHeight / 45,color: Colors.white,fontWeight: FontWeight.w400
            )),),
          ),
        ),
      ),
    );
  }
}
