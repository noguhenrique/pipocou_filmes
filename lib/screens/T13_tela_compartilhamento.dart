import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class CompartilhamentoPage extends StatefulWidget {
  final dynamic movie;

  const CompartilhamentoPage({Key? key, required this.movie}) : super(key: key);

  @override
  _CompartilhamentoPageState createState() => _CompartilhamentoPageState();
}

class _CompartilhamentoPageState extends State<CompartilhamentoPage> {
  late String imagePath;

  @override
  void initState() {
    super.initState();
    generateTemporaryImage();
  }

  Future<void> generateTemporaryImage() async {
    final ByteData? byteData = await NetworkAssetBundle(Uri.parse(
            'https://image.tmdb.org/t/p/original${widget.movie['backdrop_path']}'))
        .load('');
    final buffer = byteData!.buffer;
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    imagePath = '$tempPath/temp_image.png';
    await File(imagePath).writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    setState(() {});
  }

  void shareImage() async {
    try {
      await Share.shareFiles(
        [imagePath],
        text:
            'Fiz uma descoberta no Pipocou Filmes: ${widget.movie['title']} (${DateTime.parse(widget.movie['release_date']).year})! \n Confira mais em: https://play.google.com/store/apps/details?id=pipocoufilmes',
      );
    } catch (e) {
      print('Erro ao compartilhar imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_sharp, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            'Compartilhamento',
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                Card(
                  //color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://image.tmdb.org/t/p/original${widget.movie['backdrop_path']}',
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            '${widget.movie['title']} (${DateTime.parse(widget.movie['release_date']).year})',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: RatingBarIndicator(
                            rating: widget.movie['vote_average'].toDouble() / 2,
                            itemCount: 5,
                            itemSize: 20.0,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            //unratedColor: Colors.grey.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            width: deviceWidth,
            child: const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Compartilhe com seus amigos',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: deviceWidth,
              child: ElevatedButton(
                onPressed: () {
                  shareImage();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Compartilhar Filme',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
