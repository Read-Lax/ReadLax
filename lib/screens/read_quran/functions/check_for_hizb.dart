import 'package:image_downloader/image_downloader.dart';

// ignore: non_constant_identifier_names
download_image(String imageUrl) async {
  var imageId = await ImageDownloader.downloadImage(imageUrl,
      destination:
          AndroidDestinationType.directoryPictures);
  var imagePath = await ImageDownloader.findPath(imageId!);
  return imagePath.toString();
}

// ignore: non_constant_identifier_names
download_audio(String hizbAudioUrl, String hizbIndex) async {
  var audioId = await ImageDownloader.downloadImage(hizbAudioUrl,
      destination:
          AndroidDestinationType.directoryDownloads);
  var audioPath = await ImageDownloader.findPath(audioId!);
  return audioPath.toString();
}
