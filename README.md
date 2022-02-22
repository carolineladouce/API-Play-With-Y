# MapKit Yelp Fusion API 

In this app, I played with MapKit and the Yelp Fusion Api to gather and display info about nearby businesses. 

This app is built programmatically using Swift, UIKit, MapKit, Core Location, and the Yelp Fusion API. 

## How to use this app

For this demo, I selected to display places where users can find pizza or vegetables 🍕🥦


![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/39711539/133482513-ef026417-7166-4eb6-ae12-10a43dc16817.gif)

When opening the app, the app requests user permission to access their location. 
Then, users can toggle between a Map view or List view to check out nearby businesses. 
The List view cells include business name, associated emoji, price range, distance from users location.
After selecting a business, users can see more information such as walking directions, a button to call the business, or click the share button to send details to their network. 

## What I learned

How to make API calls and parse data 

MapKit & Core Location

Request and track user location by using Core Location

Display a map that centers to and frames a location with a specific radius 

Display directions from user location to destination

Customize clickable map annotations

Customize UITableViewCell content

Create a price range display

Add share sheet using UIActivityViewController 

Display loading indicator using UIActivityIndicatorView while app is fetching data

Set up an in-app “call” button

Convert emojis to an image


