//
//  ViewController.swift
//  olympic-navigation
//
//  Created by Mattijs De Paepe on 08/11/2023.
//

import UIKit
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import CoreLocation
import MapboxMaps
import MapboxSearchUI

class SimpleUISearchViewController: MapsViewController {
    
    lazy var searchController: MapboxSearchController = {
        let locationProvider = PointLocationProvider(coordinate: .sanFrancisco)
        var configuration = Configuration(locationProvider: locationProvider)
        
        return MapboxSearchController(configuration: configuration)
    }()
    
    lazy var panelController = MapboxPanelController(rootViewController: searchController)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cameraOptions = CameraOptions(center: .sanFrancisco, zoom: 15)
        mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)
        
        searchController.delegate = self
        addChild(panelController)
    }
}

extension SimpleUISearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        showAnnotation(searchResult)
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
    }
}


//class ViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Define two waypoints to travel between
//        let origin = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047), name: "Mapbox")
//        let destination = Waypoint(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), name: "White House")
//        
//        // Set options
//        let routeOptions = NavigationRouteOptions(waypoints: [origin, destination])
//        
//        // Request a route using MapboxDirections.swift
//        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let response):
//                guard let self = self else { return }
//                // Pass the first generated route to the the NavigationViewController
//                let viewController = NavigationViewController(for: response, routeIndex: 0, routeOptions: routeOptions)
//                viewController.modalPresentationStyle = .fullScreen
//                self.present(viewController, animated: true, completion: nil)
//            }
//        }
//    }
//}
