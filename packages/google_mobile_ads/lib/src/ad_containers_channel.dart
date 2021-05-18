import 'package:google_mobile_ads/src/ad_containers_new.g.dart';
import 'package:reference/reference.dart';

class ChannelRegistrar extends $ChannelRegistrar {
  ChannelRegistrar($LibraryImplementations implementations)
      : super(implementations);

  static ChannelRegistrar instance = ChannelRegistrar(
      $LibraryImplementations(MethodChannelMessenger.instance));
}
