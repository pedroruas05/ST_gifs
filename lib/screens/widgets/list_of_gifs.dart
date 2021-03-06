import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gif_app/core/get_controllers/gifs_controller.dart';
import 'package:transparent_image/transparent_image.dart';

class ListOfGifs extends StatefulWidget {
  final bool enableShowMore;
  final bool isLoading;
  final List<dynamic> gifsUrls;
  final VoidCallback onPressed;
  final VoidCallback onPressedFavorite;
  final VoidCallback onPressedSearch;

  ListOfGifs({
    this.enableShowMore,
    this.isLoading,
    this.gifsUrls,
    this.onPressed,
    this.onPressedFavorite,
    this.onPressedSearch,
  });

  @override
  _ListOfGifsState createState() => _ListOfGifsState();
}

class _ListOfGifsState extends State<ListOfGifs> {

  final gifsController = Get.find<GifsController>();
  final fieldController = TextEditingController();


  int getCount(String search) {
    if (search == null) {
      return widget.gifsUrls.length;
    } else {
      return widget.gifsUrls.length + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<GifsController>(builder: () {
      return Visibility(
        visible: !widget.isLoading,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: 
            if (gifsController.gifsUrls.isEmpty)
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Não há nada\n para apresentar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: 
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: gifsController.getCount(search),
                    itemBuilder: (_, index) {
                      if (search == null ||
                          index < gifsController.gifsUrls.length) {
                        return GestureDetector(
                          onTap: widget.onPressed,
                          child: Stack(
                            children: [
                              FadeInImage.memoryNetwork(
                                height: 250,
                                width: 250,
                                placeholder: kTransparentImage,
                                image: gifsController.gifsUrls[index]["images"]
                                    ["fixed_height"]["url"],
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: ElevatedButton(
                                  onPressed: widget.onPressedFavorite,
                                  child: gifsController.isFavorited(
                                          id: gifsController.gifsUrls[index]
                                              ["id"])
                                      ? Icon(Icons.favorite,
                                          color: Colors.white)
                                      : Icon(Icons.favorite_outline),
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Visibility(
                          visible: widget.enableShowMore,
                          child: InkWell(
                          onTap: () {
                            offset += 49;
                            gifsController.getGifs(
                                search: search, offset: offset);
                          },
                          child: Ink(
                            color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Carregar mais",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(Icons.refresh, color: Colors.white),
                              ],
                            ),
                          ),
                        );
                        );
                        
                      }
                    },
                  );
                ),
              ),
          ],
        ),
        replacement: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
              SizedBox(height: 10),
              Text(
                "Please, wait a second...",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ],
          ),
        ),
      );
      
    );
  }
}
