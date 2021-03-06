import 'package:audioplayers/audioplayers.dart';
import './../../utils/commonFetch.dart';
import './../../utils//api.dart';

class PlayController {
  // 已经播放过或者正要播放的歌曲索引
  var _currentIndex;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  // 当前所播放的歌曲封面主色调
  List<int> _coverMainColor;
  get coverMainColor => _coverMainColor;
  set coverMainColor(val) => _coverMainColor = val;

  // 当前所播放的歌曲长度
  Duration _duration;
  get duration => _duration;
  set duration(val) => _duration = val;

  // 当前所播放的歌单位置索引
  int _songIndex;
  get songIndex => _songIndex;
  set songIndex(val) => _songIndex = val;

  // 当前所播放的歌单（只包含歌曲Id）
  dynamic songList;

  // 当前用户喜欢歌曲
  List<dynamic> _collectSongs;
  get collectSongs => _collectSongs;
  set collectSongs(val) => _collectSongs = val;

  // 当前是否正在播放歌曲
  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = val;

  // 当前正在播放的歌曲Url
  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;


  // 当前播放页面是否显示评论
  bool _showSongComments;
  get showSongComments => _showSongComments;
  set showSongComments(val) => _showSongComments = val;

  // 音乐播放器实例
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前歌曲播放进度Duration
  Duration _songPosition;
  get songPosition => _songPosition;
  set songPosition(val) => _songPosition = val;

  List<dynamic> combinLyric (String source) {
    List<dynamic> outputLyric = [];
    source.split('[').forEach((item) {
      outputLyric.add(item.split(']'));
    });
    return outputLyric;
  }

  double stringDurationToDouble (String duration) {
    return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
  }

  void goNextSong (String id) async {
    dynamic songDetail = await getSongDetail(int.parse(id));
    dynamic songLyr = await getData('lyric', {
      'id': id
    });
    _songIndex = _songIndex + 1;
    _currentIndex = _currentIndex + 1;
    songDetail['lyric'] = combinLyric(songLyr['lrc']['lyric']);
    _playList.add(songDetail);
    _songUrl = 'http://music.163.com/song/media/outer/url?id=' + id + '.mp3';
    _audioPlayer.play(_songUrl);
    _playing = true;
  }

  PlayController.initState() {
    _playList = [];
    _collectSongs = [];
    _currentIndex = -1;
    _playing = false;
    _showSongComments = false;
    songUrl = '';
    _coverMainColor = [0, 0, 0];
    _audioPlayer = new AudioPlayer();
    // 监听当前歌曲长度
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
    // 监听当前歌曲播放进度
    _audioPlayer.onAudioPositionChanged.listen((d) {
      songPosition = d;
      /*
      自动切换下一曲功能
      当前播放歌曲长度等于当前播放进度
      精确度：秒
      */
      if (stringDurationToDouble(songPosition.toString().substring(2, 7)) == stringDurationToDouble(_duration.toString().substring(2, 7)) && songList != null && songList.length > 1) {
        _audioPlayer.stop();
        _playing = false;
        goNextSong(_songIndex == songList.length - 1 ? songList[0] : songList[_songIndex + 1]);
        }  
    });
  } 

  PlayController(this._playing, this._playList, this._currentIndex, this._coverMainColor);
}