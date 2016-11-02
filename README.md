# Urban Hikers' Guide

Urban Hikers' Guide is an iOS Application for finding and participating in urban hikes in Portland, OR.

This application was created as my Udacity iOS Nanodegree Program capstone project submission.

##Intended Experience

Upon opening the app, all hikes will be loaded if they haven't already. This may take a couple minutes. Once the main list view is populated with hikes,
users can browse and view details about them. Each hike includes details about its distance, difficulty, and a description. 
The app also contains static route maps for each hike.

Users can favorite individual hikes by selecting the Heart icon on a hike's detail page. Hikes in the main list view
can be filtered by Favorited by toggling the Heart icon in the upper right. Favorited hikes are persisted after restarting the app, but not after refreshing all hike data via the API. All Hike data can be refreshed from the remote API by tapping the refresh icon in the upper left of the list view or by pulling to refresh in the table view.


##Running the app

After cloning the repository, ensure you're on the master branch and open the application in Xcode. You should then be able to run the app in simulator or on a compatible device. Note that Urban Hikers' Guide is written to compile in Xcode 7 and Swift 2.2.

##External APIs and Data

Most of the data available in the app was gleaned from the excellent [_Walk There_ section of the Oregon Metro site](http://www.oregonmetro.gov/tools-living/getting-around/walk-there)
and then stored as routes in the [MapMyWalk](http://www.mapmywalk.com/my_home/#user_dashboard) app. 
Urban Hikers' Guide loads this external data via the [Under Armour Connected Fitness Platform API](https://developer.underarmour.com/).


