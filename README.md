RBLChecker-iOS
==============
> I challenged myself to write and ship and iOS app in one evening, heres what I came up with in 6 hours.

The app consumes the API that I was dicking about with a couple of weeks ago, which is a simple express app that performs DNSBL lookups and is running on heroku. 

You can view the API at [This link](https://rblchecker.herokuapp.com).
The source for it is available [On my github profile](https://github.com/nickpack/RBLChecker)

I owe a lot of thanks to the following projects for making it as painless as possible:
* CocoaPods
* AFNetworking
* FontAwesomeKit
* Google Analytics
* ODRefreshControl
* PrettyKit
* SVWebViewController
* TSMessages

## Whats next with this?
Heres a very scrappy braindump that I intend to implement:
* Add bookmarking of server addresses using CoreData
* Store historical results in Coredata
* Plot health history graphs based on aforementioned data
* Expand webservice and add a scheduled check of hosts, with push notifications to the app
* Replace all of the listing API calls with native DNS lookups on the device - This is really poorly documented and I didn't have time to mess with it when I built this but basically the underlying OS networking C code needs to be used to achieve this.

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code.

## Changelog
* 12/05/2013 - Initial public release

## Contributers
* Nick Pack

## Licence
Copyright (c) 2013 Nick Pack
Licensed under the MIT license.	

## Screenshots
![Screenshot 1](http://a1.mzstatic.com/us/r30/Purple2/v4/7a/b9/54/7ab9544c-0b4d-d67b-1681-ea0e3dcbae83/mzl.agyegrsd.png?downloadKey=1368985023_ae3e8932e39f8a438dd8263081ab7d8b)

![Screenshot 2](http://a1.mzstatic.com/us/r30/Purple/v4/c1/a4/3f/c1a43fba-bffa-bcc9-1209-ab2645731c49/mzl.amwlxkna.png?downloadKey=1368985023_4f60300bc115fcd28a1c9f5738419d28)