import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:player/player.dart';

class VideoView extends StatefulWidget {
  final Player player;
  final FijkFit fit;

  const VideoView(this.player, {Key? key,this.fit=FijkFit.contain}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: [
            //解决点击事件冲突，我们若不加，点击事件就被吸收掉，不触发
            AbsorbPointer(absorbing:true,child: FijkView(player: widget.player,fit: widget.fit,)),


            //条件编译
            //只在播放器在暂停时我们显示这个按钮
            if (widget.player.state == FijkState.paused)
              Align(
                child:
                    Image.asset('asset/images/play.png', width: 70, height: 70),
                alignment: Alignment.center,
              ),
          ],
        ),
        onTap:tapVideo,
      ),
    );
  }

//  方法区
  void tapVideo() {
    print('点击了Video');

    //如果视频播放器当前状态是暂停，我们就播放
    //如果是其他状态提我们就暂停
    if (widget.player.state == FijkState.paused) {
      widget.player.start();
    } else {
      widget.player.pause();
    }

    //触发重绘，该改变的状态player 自己已经改变了
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //销毁player
    //不销毁，关了页面还在播放
    widget.player.release();
  }

}
