import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DeepLinkService {
  Future<String> createEventDeepLink(String eventId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://dsync.page.link',
      link: Uri.parse('https://dsync.app/events/$eventId'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.dsync_meetup_app',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.example.dsync_meetup_app',
        minimumVersion: '1',
      ),
    );

    final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }

  Future<void> handleDynamicLinks(Function(Uri) onLinkReceived) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      onLinkReceived(deepLink);
    });
  }
}
