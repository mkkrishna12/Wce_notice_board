import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const MaterialApp(home: FileDownload()));
// }
dynamic value = -1.0;

class FileDownload extends StatefulWidget {
  FileDownload(this.fileUrl, {Key key}) : super(key: key);
  String fileUrl;
  @override
  State<FileDownload> createState() => _FileDownloadState();

  static progressIndicator(value1) {
    return (value1 == -1.0)
        ? PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: Container(),
    )
        : PreferredSize(
      preferredSize: const Size.fromHeight(10.0),
      child: LinearProgressIndicator(
        backgroundColor: Colors.grey,
        valueColor:
        const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
        minHeight: 5,
        value: value1,
      ),
    );
  }
}

class _FileDownloadState extends State<FileDownload> {
  //you can save other file formats too.

  SnackBar snackBar;
  String getFileName(String url) {
    RegExp regExp = RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(url);

    var match = matches.elementAt(0);
    // print(Uri.decodeFull(match.group(2)));
    return Uri.decodeFull(match.group(2));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          // Text("File URL: ${widget.fileUrl}"),
          // const Divider(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFFF5F57),
              onPrimary: const Color(0xFFFF8470),
              shadowColor: Colors.red,
              elevation: 6,

            ),
            onPressed: () async {
              Map<Permission, PermissionStatus> statuses = await [
                Permission.storage,
                ///add more permission to request here.
              ].request();

              if (statuses[Permission.storage].isGranted) {

                var dir = await DownloadsPathProvider.downloadsDirectory;

                if (dir != null) {
                  String saveName = getFileName(widget.fileUrl);
                  String savePath = dir.path + "/$saveName";
                  // print(savePath);
                  //output:  /storage/emulated/0/Download/banner.png

                  try {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'Downloading file . . . .',
                      ),
                    ));
                    await Dio().download(widget.fileUrl, savePath,
                        onReceiveProgress: (received, total) {
                          if (total != -1) {
                            // setState(() {
                            //   NoticeViewer.pValue = total / 100;
                            // });
                          }
                        });
                    // print("File is saved to download folder");
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        'File is saved to download folder',
                      ),
                    ));
                  } on DioError catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        e.message.toString(),
                      ),
                    ));
                  }
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something wrong ')));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('No permission to read and write.'),
                ));
              }
            },
            child: const Text(
              "Download Notice",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}