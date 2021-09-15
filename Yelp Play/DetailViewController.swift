//
//  DetailViewController.swift
//  Yelp Play
//
//  Created by Caroline LaDouce on 9/6/21.
//

import Foundation
import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {
    
    var safeArea: UILayoutGuide!
    
    let detailImageView = UIImageView()
    let nameBar = UILabel()
    
    var mapDirectionsView = MKMapView()
    var imageUrlString = ""
    var image = UIImage()
    var restaurantYelpUrl = ""
    let callButton = UIButton()
    var restaurantPhoneNumber = ""
    
    
    // Set start Latitude and Longitude to default
    var startLocationLat = 40.711681
    var startLocationLon = -74.0136841
    var endLocationLat = 0.0
    var endLocationLon = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Details"
        safeArea = view.layoutMarginsGuide
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissSelf))

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(presentShareSheet))
        
        setupDetailImageView()
        setupNameBar()
        setupMapDirectionsView()
        mapDirectionsView.delegate = self

        let coordinatesStart = CLLocationCoordinate2D.init(latitude: startLocationLat, longitude: startLocationLon)
        let coordinatesEnd = CLLocationCoordinate2D.init(latitude: endLocationLat, longitude: endLocationLon)
        
        mapDirectionsView.centerToLocation(CLLocation(latitude: startLocationLat, longitude: startLocationLon))
        
        showDirectionsOnMap(directionsStartLocation: coordinatesStart, directionsEndLocation: coordinatesEnd)
                
        view.addSubview(callButton)
        setupCallButtonAppearance()
        callButton.addTarget(self, action: #selector(callRestaurant), for: .touchDown)
        
        self.view = view
        
    } // End viewDidLoad
    
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func presentShareSheet() {
        let shareActivityViewController = UIActivityViewController(activityItems: [restaurantYelpUrl], applicationActivities: nil)
        
        shareActivityViewController.isModalInPresentation = true
        present(shareActivityViewController, animated: true)
    }
    
    
    func setupDetailImageView() {
        view.addSubview(detailImageView)
        
        detailImageView.translatesAutoresizingMaskIntoConstraints = false
        detailImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        detailImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 2.5).isActive = true
        detailImageView.contentMode = .scaleAspectFill
        
        setupDetailImageData()
    }
    
    
    func setupDetailImageData() {
        guard let imageURL: URL = URL(string: imageUrlString) else {
            return
        }
        detailImageView.loadImage(withUrl: imageURL)
    }
    
    
    func setupNameBar() {
        view.addSubview(nameBar)
        
        nameBar.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        nameBar.textColor = UIColor.white
        nameBar.textAlignment = .center
        nameBar.layoutMargins.top = 12
        nameBar.layoutMargins.bottom = 12
        
        nameBar.translatesAutoresizingMaskIntoConstraints = false
        nameBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameBar.bottomAnchor.constraint(equalTo: detailImageView.bottomAnchor).isActive = true
        nameBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        nameBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    
    func setupMapDirectionsView() {
        view.addSubview(mapDirectionsView)
        
        mapDirectionsView.translatesAutoresizingMaskIntoConstraints = false
        mapDirectionsView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapDirectionsView.topAnchor.constraint(equalTo: detailImageView.bottomAnchor, constant: 16).isActive = true
        mapDirectionsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mapDirectionsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        mapDirectionsView.heightAnchor.constraint(equalTo: mapDirectionsView.widthAnchor).isActive = true
        
        mapDirectionsView.layer.cornerRadius = 12
    }
    
    
    
    func setupCallButtonAppearance() {
        
        callButton.setTitle("Call Business", for: .normal)
        callButton.setTitleColor(.white, for: .normal)
        callButton.backgroundColor = UIColor.systemBlue
        callButton.layer.cornerRadius = 6
        
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        callButton.widthAnchor.constraint(equalTo: mapDirectionsView.widthAnchor).isActive = true
        callButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        callButton.topAnchor.constraint(equalTo: mapDirectionsView.bottomAnchor, constant: 24).isActive = true
    }
    
    
    func showDirectionsOnMap(directionsStartLocation: CLLocationCoordinate2D, directionsEndLocation: CLLocationCoordinate2D) {
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: directionsStartLocation, addressDictionary: nil ))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: directionsEndLocation, addressDictionary: nil))
        
        directionsRequest.requestsAlternateRoutes = true
        directionsRequest.transportType = .walking
        
        let drivingDirections = MKDirections(request: directionsRequest)
        
        drivingDirections.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return
            }
            
            if let drivingRoute = unwrappedResponse.routes.first {
                self.mapDirectionsView.addOverlay(drivingRoute.polyline)
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK - Touch Handlers
    
    @objc func callRestaurant(sender: UIButton) {
        
        if let restaurantPhoneNumberUrl = URL(string: "tel://\(restaurantPhoneNumber)") {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(restaurantPhoneNumberUrl)) {
                application.open(restaurantPhoneNumberUrl, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    
} /// End class


// MARK - Extensions


extension UIImageView {
    func loadImage(withUrl url: URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
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
