//
//  ViewController.swift
//  Yelp Play
//
//  Created by Caroline LaDouce on 9/6/21.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

//{"id": "xEnNFXtMLDF5kZDxfaCJgA", "alias": "the-halal-guys-new-york-2", "name": "The Halal Guys", "image_url": "https://s3-media2.fl.yelpcdn.com/bphoto/pqcdqGpzyurT2pSVA9G2kw/o.jpg", "is_closed": false, "url": "https://www.yelp.com/biz/the-halal-guys-new-york-2?adjust_creative=RzPd81IBxDPwaWBeNhRk8w&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=RzPd81IBxDPwaWBeNhRk8w", "review_count": 9646, "categories": [{"alias": "foodstands", "title": "Food Stands"}, {"alias": "mideastern", "title": "Middle Eastern"}, {"alias": "halal", "title": "Halal"}], "rating": 4.0, "coordinates": {"latitude": 40.761861, "longitude": -73.979306}, "transactions": ["delivery", "pickup"], "price": "$", "location": {"address1": "W 53rd St", "address2": null, "address3": "", "city": "New York", "zip_code": "10019", "country": "US", "state": "NY", "display_address": ["W 53rd St", "New York, NY 10019"]}, "phone": "+13475271505", "display_phone": "(347) 527-1505", "distance": 591.0232163573934}

struct YelpResponse: Codable {
    var businesses: [YelpListing]
}


struct Categories: Codable {
    var alias: String
    var title: String
}


struct Coordinates: Codable {
    var latitude: Double
    var longitude: Double
}


struct YelpLocation: Codable {
    var address1: String
    var address2: String?
    var address3: String?
    var city: String
    var zip_code: String
    var country: String
    var state: String
    var display_address: [String]
}


struct YelpListing: Codable {
    var id: String
    var alias: String
    var name: String
    var image_url: String
    var is_closed: Bool
    var url: String
    var review_count: Int
    var categories: [Categories]
    var rating: Float
    var coordinates: Coordinates
    var transactions: [String]
    var price: String?
    var location: YelpLocation
    var phone: String
    var display_phone: String
    var distance: Float
}


var yelpListings: [YelpListing] = []

//var locValue: CLLocationCoordinate2D = (latitude)

var userLocation = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
//let defaultLatValue = userLocation.latitude
//let defaultLonValue = userLocation.longitude
//let defaultLatValue = 40.758896
//let defaultLonValue = -73.985130

let loadingViewController = LoadingViewController()

//let category1AnnotationView = MKAnnotationView.self
//let category2AnnotationView = MKAnnotationView.self

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    let loadingViewController = LoadingViewController()
    
    // rename this to YELP_SEARCH_API
    let YELP_API = "https://api.yelp.com/v3/businesses/search"
    
    
    // Create constants for default latitude and longitude values, according to default lat/lon values to be used in API call
    let defaultLatValue = 40.711681
    //40.7150597 40.758896
    let defaultLonValue = -74.0136841
    //        -73.985130
    //    -74.0099571
    
    
    
    
    let homeTableView = UITableView()
    
    let segmentedControl: UISegmentedControl = {
        let segC = UISegmentedControl(items: ["Map", "List"])
        return segC
    }()
    
    var homeMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var categoryString = ""
    
    let category1AnnotationView = MKAnnotationView.self
    let category2AnnotationView = MKAnnotationView.self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        view.backgroundColor = UIColor.white
        title = "🍕 Pizza Vegetables 🥦"
        
        
        // Create a map view for the home screen
        homeMapView = MKMapView()
        homeMapView.delegate = self
        
        homeMapView.frame = view.bounds
        homeTableView.frame = view.bounds
        view.addSubview(homeTableView)
        view.addSubview(homeMapView)
        
        
        
        requestLocationAccess()
        let initialLocation = CLLocation(latitude: defaultLatValue, longitude: defaultLonValue)
        homeMapView.showsUserLocation = true
        homeMapView.centerToLocation(initialLocation)
        
        fetchSampleData()
        
        //        let category1AnnotationView = MKAnnotationView.self
        //        let category2AnnotationView = MKAnnotationView.self
        
        
        //        homeMapView.register(category1AnnotationView.self, forAnnotationViewWithReuseIdentifier: category1AnnotationView.reuseIdentifier!)
        //        homeMapView.register(category2AnnotationView.self, forAnnotationViewWithReuseIdentifier: category2AnnotationView.reuseIdentifier!)
        
        
        homeTableView.dataSource = self
        homeTableView.delegate = self
        homeTableView.register(TableViewCell.self, forCellReuseIdentifier: "homeTableCell")
        
        // Default location set to the latitude and longitude default values that will be used in the parameters of the api call
        //let initialLocation = CLLocation(latitude: defaultLatValue, longitude: defaultLonValue)
        
        
        
        //                requestLocationAccess()
        //                let initialLocation = CLLocation(latitude: defaultLatValue, longitude: defaultLonValue)
        //                homeMapView.showsUserLocation = true
        //                homeMapView.centerToLocation(initialLocation)
        
        segmentedControl.backgroundColor = UIColor.systemBackground
        segmentedControl.selectedSegmentTintColor = UIColor.systemBlue
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(mapListSegmentChange(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        
        let segmentTopConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        let margins = view.layoutMarginsGuide
        //let segmentLeadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        //let segmentTrailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        let segmentWidthConstraint = segmentedControl.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.75)
        let segmentXConstraint = segmentedControl.centerXAnchor.constraint(equalTo: margins.centerXAnchor)
        
        
        segmentTopConstraint.isActive = true
        //        segmentLeadingConstraint.isActive = true
        //        segmentTrailingConstraint.isActive = true
        segmentWidthConstraint.isActive = true
        segmentXConstraint.isActive = true
        
        
        
        self.view = view
        
    } /// End viewDidLoad
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpListings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeTableCell", for: indexPath) as! TableViewCell
        
        guard let tableViewCell = cell as? TableViewCell else {
            return cell
        }
        
        tableViewCell.restaurantTitleLabel.text = yelpListings[indexPath.row].name
        
        
        let priceLabelText = NSMutableAttributedString()
        if yelpListings[indexPath.row].price == "$" {
            priceLabelText.append(NSAttributedString(string: "$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]))
            priceLabelText.append(NSAttributedString(string: "$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            tableViewCell.priceRangeLabel.attributedText = priceLabelText
            
        } else if yelpListings[indexPath.row].price == "$$" {
            priceLabelText.append(NSAttributedString(string: "$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]))
            priceLabelText.append(NSAttributedString(string: "$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            tableViewCell.priceRangeLabel.attributedText = priceLabelText
            
        } else if yelpListings[indexPath.row].price == "$$$" {
            priceLabelText.append(NSAttributedString(string: "$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]))
            priceLabelText.append(NSAttributedString(string: "$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            tableViewCell.priceRangeLabel.attributedText = priceLabelText
            
        } else if yelpListings[indexPath.row].price == "$$$$" {
            priceLabelText.append(NSAttributedString(string: "$$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGreen]))
            tableViewCell.priceRangeLabel.attributedText = priceLabelText
            
        } else {
            priceLabelText.append(NSAttributedString(string: "$$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
            tableViewCell.priceRangeLabel.attributedText = priceLabelText
        }
        
        // Format the distance for display
        let distanceInFeet = Measurement(value: Double(yelpListings[indexPath.row].distance), unit: UnitLength.feet)
        let distanceInMiles = distanceInFeet.converted(to: UnitLength.miles)
        let roundedDistanceInMiles = round(distanceInMiles.value * 1000) / 1000.0
        tableViewCell.distanceLabel.text = "\(roundedDistanceInMiles) miles"
        
        tableViewCell.priceDistanceSeparatorLabel.text = "•"
        tableViewCell.accessoryType = .disclosureIndicator
        
        
        
        // Here, I would set the tableViewCell "iconImageView.image" to the appropriate image asset (mexican, pizza, etc) according to the indexPath.row categories -> alias
        
        //        let cat = yelpListings[indexPath.row].categories[0]
        //       // print("CAT INDEX: \(cat)")
        //        print("___________")
        //        print("RESTAURANT NAME: \(yelpListings[indexPath.row].name)")
        //        print("CATEGORIES COUNT: \(yelpListings[indexPath.row].categories.count)")
        //        print("THE CATEGORIES ARE:")
        //
        //var categoryString = ""
        
        getRestaurantCategory()
        
        // pizza,farmersmarket,organic_stores,grocery
        
        if categoryString == "pizza" {
            //tableViewCell.iconImageView.image = UIImage(named: "pizza")
            tableViewCell.iconImageView.image = "🍕".emojiToImage()
        } else if categoryString == "farmersmarket" {
            //tableViewCell.iconImageView.image = UIImage(named: "mexican")
            tableViewCell.iconImageView.image = "🥦".emojiToImage()
        } else if categoryString == "organic stores" {
            //tableViewCell.iconImageView.image = UIImage(named: "mexican")
            tableViewCell.iconImageView.image = "🥦".emojiToImage()
        } else if categoryString == "grocery" {
            tableViewCell.iconImageView.image = "🥦".emojiToImage()
        } else {
            //print("NO IMAGE FOR RESTAURANT: \(yelpListings[indexPath.row].name)")
            tableViewCell.iconImageView.image = "🍽".emojiToImage()
        }
        
        
        func getRestaurantCategory() {
            for ind in 0...yelpListings[indexPath.row].categories.count - 1 {
                //print("\(yelpListings[indexPath.row].categories[ind])")
                print(yelpListings[indexPath.row].name)
                
                // pizza,farmersmarket,organic_stores,grocery
                
                if yelpListings[indexPath.row].categories[ind].title == "Pizza" {
                    //tableViewCell.iconImageView.image = UIImage(named: "pizza")
                    categoryString = "pizza"
                    print("CHOSEN CATEGORY: \(categoryString)")
                    return
                } else if yelpListings[indexPath.row].categories[ind].title == "Farmers Market" {
                    //tableViewCell.iconImageView.image = UIImage(named: "mexican")
                    categoryString = "farmersmarket"
                    print("CHOSEN CATEGORY: \(categoryString)")
                    return
                } else if yelpListings[indexPath.row].categories[ind].title == "Organic Stores" {
                    //tableViewCell.iconImageView.image = UIImage(named: "mexican")
                    categoryString = "organic stores"
                    print("CHOSEN CATEGORY: \(categoryString)")
                    return
                } else if yelpListings[indexPath.row].categories[ind].title == "Grocery" {
                    //tableViewCell.iconImageView.image = UIImage(named: "mexican")
                    categoryString = "grocery"
                    print("CHOSEN CATEGORY: \(categoryString)")
                    return
                    
                    
                } else {
                    categoryString = "\(yelpListings[indexPath.row].categories[ind])"
                    print("CHOSEN CATEGORY: \(categoryString)")
                }
            }
            
        } // End func getRestaurantCategory
        
        return cell
    } // End func
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = yelpListings[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.imageUrlString = detail.image_url
        detailViewController.restaurantYelpUrl = detail.url
        detailViewController.restaurantPhoneNumber = detail.phone
        detailViewController.endLocationLat = detail.coordinates.latitude
        detailViewController.endLocationLon = detail.coordinates.longitude
        detailViewController.nameBar.text = detail.name
        
        let detailVC = UINavigationController(rootViewController: detailViewController)
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true)
    }
    
    
    func requestLocationAccess() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func callLoadingViewController() {
        loadingViewController.modalPresentationStyle = .overCurrentContext
        loadingViewController.modalTransitionStyle = .crossDissolve
        present(loadingViewController, animated: true, completion: nil)
    }
    
    
    func dismissLoadingViewController() {
        loadingViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func fetchSampleData() {
        // Call loadingViewController to popup while yelp data is being fetched
        callLoadingViewController()
        
        var headers = HTTPHeaders()
        let authorizationHeader = HTTPHeader(name: "Authorization", value: "Bearer \(yelpAPIKey)")
        headers.add(authorizationHeader)
        let parameters = ["longitude": defaultLonValue, "latitude": defaultLatValue, "radius": "1000", "sort_by": "distance", "categories": "pizza,farmersmarket,organic_stores,grocery"] as [String : Any]
        
        AF.request(YELP_API, method: .get, parameters: parameters, headers: headers).validate().responseData { response in
            
            if let data = response.data {
                do {
                    let responseArray = try JSONDecoder().decode(YelpResponse.self, from: data)
                    
                    yelpListings = responseArray.businesses
                    self.homeTableView.reloadData()
                    
                    for index in 0...yelpListings.count - 1 {
                        // Populate homeMapView with map annotations
                        let mapAnnotation = MKPointAnnotation()
                        mapAnnotation.title = yelpListings[index].name as String
                        mapAnnotation.subtitle = "\(index)"
                        mapAnnotation.coordinate = CLLocationCoordinate2D(latitude: yelpListings[index].coordinates.latitude, longitude: yelpListings[index].coordinates.longitude)
                        
                        self.homeMapView.addAnnotation(mapAnnotation)
                        
                    }
                } catch {
                    print("ERROR: \(error)")
                }
            }
        }
        
        // Dismiss loadingViewController after data fetch is complete
        dismissLoadingViewController()
        
    } /// End func
    
    
    
    
    // Set map annotations to custom pin emoji
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = homeMapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            // Create the view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = false
        } else {
            // assign the annotation on the annotation view
            annotationView?.annotation = annotation
        }
        
        annotationView?.image = "🌼".emojiToImage()
        
        return annotationView
    }
    //
    
    
    //    func mapView(_ mapVIew: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        if annotation is MKUserLocation {
    //            return nil
    //        }
    //
    //        if categoryString == "oatmilk" {
    //            let markerEmoji = "A"
    //            var emojiMarkerView = homeMapView.dequeueReusableAnnotationView(withIdentifier: markerEmoji)
    //            if emojiMarkerView == nil {
    //                emojiMarkerView = category1AnnotationView.init(annotation: annotation, reuseIdentifier: markerEmoji)
    //                emojiMarkerView?.canShowCallout = false
    //            } else {
    //                emojiMarkerView?.annotation = annotation
    //            }
    //
    //
    //            return emojiMarkerView
    //        } else {
    //            let markerEmoji = "B"
    //            var emojiMarkerView = homeMapView.dequeueReusableAnnotationView(withIdentifier: markerEmoji)
    //            if emojiMarkerView == nil {
    //                emojiMarkerView = category2AnnotationView.init(annotation: annotation, reuseIdentifier: markerEmoji)
    //                emojiMarkerView?.canShowCallout = false
    //            } else {
    //                emojiMarkerView?.annotation = annotation
    //            }
    //
    //            return emojiMarkerView
    //        }
    //
    //    }
    
    
    // When user clicks a map annotation, DetailViewController will display with approriate info
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let intIndex = Int((view.annotation?.subtitle)!!)
        let detailViewController = DetailViewController()
        
        detailViewController.imageUrlString = yelpListings[intIndex!].image_url
        detailViewController.restaurantYelpUrl = yelpListings[intIndex!].url
        detailViewController.restaurantPhoneNumber = yelpListings[intIndex!].phone
        
        detailViewController.endLocationLat = yelpListings[intIndex!].coordinates.latitude
        detailViewController.endLocationLon = yelpListings[intIndex!].coordinates.longitude
        
        detailViewController.nameBar.text = yelpListings[intIndex!].name
        
        let detailVC = UINavigationController(rootViewController: detailViewController)
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true)
    }
    
    
    // MARK - Touch Handlers
    
    @objc func mapListSegmentChange(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            homeTableView.alpha = 0
            homeMapView.alpha = 1
        case 1:
            homeMapView.alpha = 0
            homeTableView.alpha = 1
        default:
            break
        }
    } // End func mapListSegmentChange
    
    
    
}/// End class ViewController



// MARK - Extensions


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        DetailViewController().startLocationLat = locValue.latitude
        DetailViewController().startLocationLon = locValue.longitude
        
        userLocation.latitude = locValue.latitude
        userLocation.longitude = locValue.longitude
    }
}


private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}


extension String {
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

