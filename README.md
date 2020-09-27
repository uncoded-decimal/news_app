# news_app
A news app using responses from https://newsapi.org/

Download the latest version from [Play Store](https://play.google.com/store/apps/details?id=com.decimalCorp.news_app&hl=en_IN) 

This app uses:
* [flutter_bloc](https://pub.dev/packages/flutter_bloc) for the BLoC architecture
* [hive](https://pub.dev/packages/hive) for storing last 10 searches
* [share](https://pub.dev/packages/share) for sharing news urls
* [location](https://pub.dev/packages/location) and [geocoding](https://pub.dev/packages/geocoding) for getting device location and reverse-geocoding

## Problems Solved:
* PageView keep alives: [StackOverflow Answer](https://stackoverflow.com/a/63574708/8240072)

![](/assets/Screenshot_1600856974.png =250x)
