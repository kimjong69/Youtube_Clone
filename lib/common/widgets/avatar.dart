import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube_clone/common/widgets/custom_button.dart';
import 'package:youtube_clone/main.dart';

class Avatar extends StatelessWidget {
  final String buttonText;
  final bool circular;
  final String? imgUrl;
  final void Function(String imgUrl) onUpload;
  const Avatar(
      {super.key, this.imgUrl, required this.onUpload, required this.circular, required this.buttonText});

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final imgExtension = image.path.split('.').last.toLowerCase();
    final imageBytes = await image.readAsBytes();
    final userId = supabase.auth.currentUser!.id;
    final imgPath = '/$userId/profile';
    await supabase.storage.from('profiles').uploadBinary(
          imgPath,
          imageBytes,
          fileOptions:
              FileOptions(upsert: true, contentType: 'image/$imgExtension'),
        );
    String imgUrl = supabase.storage.from('profiles').getPublicUrl(imgPath);
    imgUrl = Uri.parse(imgUrl).replace(queryParameters: {
      't': DateTime.now().millisecondsSinceEpoch.toString()
    }).toString();
    onUpload(imgUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: imgUrl != null
              ? ClipRRect(
                  borderRadius: circular == true
                      ? BorderRadius.circular(100)
                      : BorderRadius.zero,
                  child: Image.network(
                    imgUrl!,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  color: Colors.grey,
                  child: const Center(
                    child: Text('No Image'),
                  ),
                ),
        ),
        const SizedBox(
          height: 12,
        ),
        CustomButton(
          text: buttonText,
          width: 60,
          onTap: () {
            pickImage();
          },
        )
      ],
    );
  }
}
