import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsProvider extends ChangeNotifier {

                      // Rewarded ads


  late RewardedAd rewardedAd;
  bool isAdLoaded = false;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-6195674039585428/3818166017', 
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          rewardedAd = ad;
          isAdLoaded = true;
          notifyListeners();

          rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              isAdLoaded = false;
              notifyListeners();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              log('Failed to show rewarded ad: $error');
              isAdLoaded = false;
              notifyListeners();
            },
            onAdShowedFullScreenContent: (ad) {
              // Handle when the ad is shown to the user (e.g., pause your game).
            },
            onAdImpression: (ad) {
              // Handle when the user sees an impression of the ad.
            },
          );
        },
        onAdFailedToLoad: (error) {
          log('Failed to load rewarded ad: $error');
          rewardedAd.dispose();
          notifyListeners();
        },
      ),
    );
  }

  void showRewardedAd() async{
    if (isAdLoaded) {
     await  rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {  });
    } else {
      log('Rewarded ad is not loaded.');
    }
  }
}
