import 'dart:io';
/*
Future<String?> uploadProfilePicture(File imageFile) async {
  try {
    // Feltöltés a Firebase Storage-be
    Reference storageReference = FirebaseStorage.instance.ref().child('profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
    UploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask;
    // URL lekérése
    String downloadUrl = await storageReference.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print("Profilkép feltöltése hiba: $e");
    return null;
  }
}
*/