import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider extends ChangeNotifier {
  late InterstitialAd interstitialAd;
  bool isAdLoaded = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3906639646886799~3004634022',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          interstitialAd = ad;
          isAdLoaded = true;
          notifyListeners();

          interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isAdLoaded = false;
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              isAdLoaded = false;
              notifyListeners();
            },
          );
        },
        onAdFailedToLoad: (error) {
          interstitialAd.dispose();
          notifyListeners();
        },
      ),
    );
  }
}
