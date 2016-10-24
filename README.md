# Urban Hikers' Guide

Urban Hikers' Guide is an iOS Application for finding and participating in urban hikes in Portland, OR.

This application was created as my Udacity iOS Nanodegree Program capstone project submission.

##Intended Experience

Upon opening the app, all hikes will be loaded if they haven't already. Once the main list view is populated with hikes,
users can browse and view many details about them. Each hike includes details about its distance, difficulty, and a description. 
The app also contains static route maps for each hike, and maps in .kml and .gpx formats are available for download to your device. 
These can then be imported into Google Maps, MapMyWalk, or your other favorite tracking app.

Users can favorite individual hikes by selecting the Heart icon on a hike's detail page. Hikes in the main list view
can be filtered by Favorited by toggling the Heart icon in the upper right. All Hikes can be refreshed from the remote API by tapping the refresh icon in the upper left of the list view.


##Running the app

After cloning the repository, ensure you're on the master branch and open the application in Xcode. You should then be able to run the app in simulator. Note that Urban Hikers' Guide is written to compile in Xcode's most recent stable release, which at the time of writing is Xcode 8.0 and Swift 2.3.

##External APIs and Data

Most of the data available in the app was gleaned from the excellent [_Walk There_ section of the Oregon Metro site](http://www.oregonmetro.gov/tools-living/getting-around/walk-there)
and then stored as routes in the [MapMyWalk](http://www.mapmywalk.com/my_home/#user_dashboard) app. 
Urban Hikers' Guide loads this external data via the [Under Armour Connected Fitness Platform API](https://developer.underarmour.com/).


