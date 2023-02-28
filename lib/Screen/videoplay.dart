import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Model/GetVideoModel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;


/// Stateful widget to fetch and then display video content.
class VideoPlay extends StatefulWidget {
  const VideoPlay({Key? key}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;

   late List<VideoPlayerController> _vController = [];

   GetVideoModel? videoModel;
  getVideos()async{
    var headers = {
      'Cookie': 'ci_session=f8c1bfdbb9cf97d7bfb0598674fde352c2311f5b'
    };
    var request = http.MultipartRequest('GET', Uri.parse('${baseUrl}get_video'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult =  await response.stream.bytesToString();
      final jsonResponse = GetVideoModel.fromJson(json.decode(finalResult));
      print("video response here ${jsonResponse.message} and ${jsonResponse}");
      setState(() {
        videoModel = jsonResponse;
      });
      for(var i=0;i<jsonResponse.data!.length;i++){
        // _vController.add(VideoPlayerController.network(jsonResponse.data![i].video.toString()));
        _vController.add(VideoPlayerController.network(jsonResponse.data![i].video.toString())..initialize().then((value){
          setState(() {
          });
        }));
        isPlayed.add(false);
        print("video controller length ${_vController.length}");
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  List<bool> isPlayed = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500),(){
      return getVideos();
    });
    // _controller = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  bool isPlay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(
      //   child: _controller.value.isInitialized
      //       ? AspectRatio(
      //     aspectRatio: _controller.value.aspectRatio,
      //     child: VideoPlayer(_controller),
      //   )
      //       : Container(),
      // ),
      body:Column(
        children: [
          Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                color: colors.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10,left: 10),
                    child: Text("Feed Mart TV",style: TextStyle(color: colors.whiteTemp,fontSize: 20,fontWeight: FontWeight.bold),),
                  ),
                ),
              ),
              // Container(
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Container(
              //             height: 70,
              //             color: colors.whiteTemp,
              //             child: Padding(
              //               padding: const EdgeInsets.all(5),
              //               child: Container(
              //                   child: Center(child: Text("Feed Mart TV",style: TextStyle(color: colors.secondary,fontSize: 20),))),
              //             )
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //             height: 70,
              //             color: colors.secondary,
              //             child: Align(
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.end,
              //                 children: [
              //                   SizedBox(width: 3,),
              //                   Padding(
              //                     padding: const EdgeInsets.only(right: 10),
              //                     child: Image.asset("assets/images/notifaction.png",height: 30,width: 30),
              //                   ),
              //
              //                 ],
              //               ),
              //             )
              //         ),
              //       ),
              //
              //     ],
              //   ),
              // ),


            ],
          ),
          SizedBox(height: 20,),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _vController.length == 0 ? Center(child: Text("No Video to show"),) : ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                // padding: EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  itemCount: _vController.length,
                  itemBuilder: (C,i){
                    // print("checking listview data ${_vController.length} and  ${_vController[i].value.aspectRatio} and ");
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.secondary,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                      height:150,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: AspectRatio(aspectRatio: _vController[i].value.aspectRatio,child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: VideoPlayer(_vController[i])),)),
                                  Container(
                                    height: 30,
                                    padding: EdgeInsets.only(left: 10,top: 10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: colors.secondary,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                        )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text("Feed Mart: ${videoModel!.data![i].title}")
                                      ],),
                                  ),
                                ],
                              )),
                          Positioned(
                              bottom: 50,
                              width: MediaQuery.of(context).size.width,
                              child: VideoProgressIndicator(
                                _vController[i],
                                allowScrubbing: false,
                                colors: VideoProgressColors(
                                    backgroundColor: Colors.blueGrey,
                                    bufferedColor: Colors.blueGrey,
                                    playedColor: Colors.blueAccent),
                              )),
                          Positioned(
                              left: 1,right: 1,
                              top: 1,
                              bottom: 1,
                              //alignment: Alignment.center,
                              child: isPlayed[i] == true ? InkWell(
                                  onTap: (){
                                    setState(() {
                                      isPlayed[i] = false;
                                      _vController[i].pause();
                                    });
                                  },
                                  child: Icon(Icons.pause,color: Colors.white,)) : InkWell(
                                  onTap: (){
                                    setState(() {
                                      isPlayed[i] = true;
                                      _vController[i].play();
                                    });
                                  },
                                  child: Icon(Icons.play_arrow,color: Colors.white,))),

                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _controller.value.isPlaying
      //           ? _controller.pause()
      //           : _controller.play();
      //     });
      //   },
      //   child: Icon(
      //     _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
      //   ),
      // ),
    );
  }

  //  showVideo(i){
  //   print("length here ${videoModel!.data!.length} and ${_vController.length}");
  //    for(var i=0;i<videoModel!.data!.length;i++){
  //      // _vController.add(VideoPlayerController.network(jsonResponse.data![i].video.toString()));
  //      _vController.add(VideoPlayerController.network('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4')..initialize().then((value){
  //        setState(() {
  //        });
  //      }));
  //      print("video controller length ${_vController.length}");
  //    }
  //   return AspectRatio(aspectRatio: _vController[i].value.aspectRatio,child: VideoPlayer(_vController[i]),);
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}