import 'dart:io';
import 'package:flutter/material.dart';
import 'package:readlex/screens/create_new_post/functions/upload_post_data.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreateNewPost extends StatefulWidget {
  const CreateNewPost({super.key});

  @override
  State<CreateNewPost> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends State<CreateNewPost> {
  TextEditingController userPost = TextEditingController();
  String? imageName;
  File? pickedImageToPost;
  bool isThereAnImage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.red,
            size: 29,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          isThereAnImage == true
              // ignore: dead_code
              ? IconButton(
                  onPressed: () {
                    postTheInfo(
                        userPost.text.trim(), pickedImageToPost, imageName!);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.done,
                    color: Colors.greenAccent,
                    size: 29,
                  ))
              : const SizedBox()
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final List<AssetEntity>? userPicke =
                  await AssetPicker.pickAssets(context,
                      pickerConfig: const AssetPickerConfig(
                        maxAssets: 1,
                        requestType: RequestType.image,
                      ));
              try {
                File? imageFile = await userPicke!.first.file;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => setState(() {
                          pickedImageToPost = imageFile;
                          imageName = userPicke.first.title;
                          isThereAnImage = true;
                        }));
                // ignore: empty_catches
              } catch (error) {}
            },
            child: Center(
                child: isThereAnImage == true
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20.0)),
                          child: Image.file(
                            pickedImageToPost!,
                            width: 130,
                            height: 200,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 8,
                                  spreadRadius: 6,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            height: 200,
                            width: 130,
                            child: const Center(
                              child: Text(
                                "Pick an image",
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      )),
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: userPost,
                cursorColor: Theme.of(context).primaryColor,
                keyboardType: TextInputType.multiline,
                maxLines: 15,
                decoration: InputDecoration(
                  hoverColor: Colors.greenAccent,
                  fillColor: Theme.of(context).primaryColor,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  hintText: "Share what you think...",
                  hintStyle: TextStyle(
                    fontFamily: "VareLaRound",
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
