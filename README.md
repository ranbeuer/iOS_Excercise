# iOS_Excercise
iOS Exercise for Devrank

Instructions for building the application.
1. open terminal and go to the folder where podfile is contained and execute 'pod install'
2. Open Devrank_Exercise.xcworkspace, build Devrank_exercise target and run it.

Architecture
The application uses MVVM architecture, it uses mainly two view modes, one for the lists of movies and one for the movie detail. These models are in charge of getting the movies and the movies' details.
The app uses a UICollectionView for showing the list of the movies which allows the user to show them in a grid view and list.
The application starts by getting the most popular movies and showing them, it also allows the user to show the best rated movies by toggling the option with a button.


Dependencies
- SVProgressHud: Used for showing error messages
- Alamofire: Used for web sevices call.
- AlamofireObjectMapper: Used for mapping json into objects.
- AlamofireImages: Used for retrieving images for lazy loading.
- UICircularProgressRing: Used for showing the rating points for the movies.
