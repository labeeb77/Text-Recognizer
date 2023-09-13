import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsPage extends StatefulWidget {
  const AdsPage({super.key});

  @override
  State<AdsPage> createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  @override
  void initState() {
    initInterstitialAd();
    super.initState();
  }

  late InterstitialAd interstitialAd;
  bool isAdLoaded = false;

  initInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            setState(() {
              isAdLoaded = true;
            });

            interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                setState(() {
                  isAdLoaded = false;
                });
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                setState(() {
                  isAdLoaded = false;
                });
              },
            );
          },
          onAdFailedToLoad: (error) {
            interstitialAd.dispose();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: TextButton(
            onPressed: () {
              if (isAdLoaded) {
                interstitialAd.show();
              }
            },
            child: const Text('Run Ad')),
      )),
    );
  }
}
