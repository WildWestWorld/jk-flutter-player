import 'dart:io';

import 'package:fijkplayer/fijkplayer.dart';

import 'player_platform_interface.dart';

class Player extends FijkPlayer {
  static const assetUrlSuffix = "asset:///";

  //默认的缓存路径
  static String _cachePath =
      '/storage/emulated/0/Android/data/com.example.router_demo/files';

  //缓存的开关
  bool enableCache = true;

  static void setCachePath(String path){
    _cachePath =path;
  }

  @override
  Future<void> setDataSource(String path,
      {bool autoPlay = false, bool showCover = false}) async {
    //获取视频缓存路径
    var videoPath = getVideoCachePath(path, _cachePath);

    // 三级缓存判断
    //如果视频存储的路径存在文件
    if (File(videoPath).existsSync()) {
      //  如果三级缓存存在，直接用本地保存的视频文件播放
      path = videoPath;
    } else if (enableCache) {  //  如果三级缓存不存在，且视频缓存开关为开，就使用视频缓存
      path = 'ijkio:cache:ffio:${path}';
      //设置三级缓存
      setOption(FijkOption.formatCategory, 'cache_file_path', videoPath);

    }
    super.setDataSource(path,autoPlay: autoPlay,showCover: showCover);
  }

  void setCommonDataSource(String url,
      {SourceType type = SourceType.net,
      bool autoPlay = false,
      bool showCover = false}) {
    if (type == SourceType.asset && !url.startsWith(assetUrlSuffix)) {
      url = assetUrlSuffix + url;
    }

    setDataSource(url, autoPlay: autoPlay, showCover: showCover);
  }

  //获取视频缓存路径
  String getVideoCachePath(String url, String cachePath) {
    Uri uri = Uri.parse(url);
    String name = uri.pathSegments.last;
    var path = "${cachePath}/${name}";
    return path;
  }

  Future<String?> getPlatformVersion() {
    return PlayerPlatform.instance.getPlatformVersion();
  }
}

enum SourceType { net, asset }
