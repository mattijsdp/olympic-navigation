import UIKit
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation
import MapboxMaps
import MapboxSearch
import MapboxSearchUI

var simulationIsEnabled = true

class SimpleUISearchViewController: UIViewController, NavigationMapViewDelegate, NavigationViewControllerDelegate {

    var startLocation: SearchResult?
    var endLocation: SearchResult?
    var setStartLocation: Bool = false
    
    var navigationBar = NavigationBar()
    
    var navigationMapView: NavigationMapView! {
        didSet {
            if oldValue != nil {
                oldValue.removeFromSuperview()
            }
            
            navigationMapView.translatesAutoresizingMaskIntoConstraints = false
            
            view.insertSubview(navigationMapView, at: 0)
            
            NSLayoutConstraint.activate([
                navigationMapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navigationMapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navigationMapView.topAnchor.constraint(equalTo: view.topAnchor),
                navigationMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }

    var currentRouteIndex = 0 {
        didSet {
            showCurrentRoute()
        }
    }
    var currentRoute: MapboxDirections.Route? {
        return routes?[currentRouteIndex]
    }
    
    var routes: [MapboxDirections.Route]? {
        return routeResponse?.routes
    }
    
    var routeResponse: RouteResponse? {
        didSet {
            guard currentRoute != nil else {
                navigationMapView.removeRoutes()
                return
            }
            currentRouteIndex = 0
        }
    }
    
    func showCurrentRoute() {
        guard let currentRoute = currentRoute else { return }
        
        var routes = [currentRoute]
        routes.append(contentsOf: self.routes!.filter {
            $0 != currentRoute
        })
        navigationMapView.showcase(routes)
    }
    
    var startButton: UIButton = {
        let startButton = UIButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        startButton.clipsToBounds = true
//        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = 5
        
        startButton.backgroundColor = UIColor(named: "mapbox blue")
        startButton.setTitle("Start Navigation", for: .normal)
        startButton.setTitleColor(UIColor(named: "mapbox background"), for: .normal)
        
        startButton.layer.masksToBounds = true
        return startButton
    }()
        
    var searchController: MapboxSearchController = {
//        let pointLocationProvider = PointLocationProvider(coordinate: .defaultLocation)
        let defaultLocationProvider = DefaultLocationProvider(locationManager: .init())
        // can define category slot (horizontal) and category lists (vertical)
        // let categoryDataProvider = ConstantCategoryDataProvider()
        var configuration = Configuration(locationProvider: defaultLocationProvider) //, hideCategorySlots: true)
        
        return MapboxSearchController(configuration: configuration)
    }()
        
    // MARK: - UIViewController lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationMapView = NavigationMapView(frame: view.bounds)
        navigationMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationMapView.delegate = self
        navigationMapView.userLocationStyle = .puck2D()
        
        let navigationViewportDataSource = NavigationViewportDataSource(navigationMapView.mapView, viewportDataSourceType: .raw)
        navigationViewportDataSource.options.followingCameraOptions.zoomUpdatesAllowed = false
        navigationViewportDataSource.followingMobileCamera.zoom = 13.0
        navigationMapView.navigationCamera.viewportDataSource = navigationViewportDataSource
        
        // TODO: handle longpress
//        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        navigationMapView.addGestureRecognizer(gesture)
                
        var panelController = MapboxPanelController(rootViewController: searchController)
        
        startButton.addTarget(self, action: #selector(tappedButton(sender:)), for: .touchUpInside)
        startButton.isHidden = true
        view.addSubview(startButton)
        
        startButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 36).isActive = true
        startButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -36).isActive = true
        view.setNeedsLayout()
        
        // Fly camera somewhere?
//        let cameraOptions = CameraOptions(center: .defaultLocation, zoom: 15)
//        navigationMapView.mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)
        
        navigationBar.startButton.addTarget(self, action: #selector(tappedStartNavigationBar(sender:)), for: .touchUpInside)
        navigationBar.endButton.addTarget(self, action: #selector(tappedEndNavigationBar(sender:)), for: .touchUpInside)
                
        view.addSubview(navigationBar)
        addNavigationBarConstraints()
        navigationBar.isHidden = true
        
        searchController.delegate = self
        addChild(panelController)
                
    }
    
    // Override layout lifecycle callback to be able to style the start button.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        startButton.layer.cornerRadius = startButton.bounds.midY
        startButton.clipsToBounds = true
        startButton.setNeedsDisplay()
    }
    
    private func addNavigationBarConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        let navigation_bar_height: CGFloat = CGFloat(132)
        
        // Add
        constraints.append(navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(navigationBar.heightAnchor.constraint(equalToConstant: navigation_bar_height))
        constraints.append(navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(16)))
        constraints.append(navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: CGFloat(-16)))
         
        // Activate (apply)
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func tappedStartNavigationBar(sender: UIButton) {
        navigationBar.isHidden = true
        startButton.isHidden = true
        
        setStartLocation = true
        
        searchController.panelController?.setState(.opened)
    }
    
    @objc func tappedEndNavigationBar(sender: UIButton) {
        navigationBar.isHidden = true
        startButton.isHidden = true
        
        setStartLocation = false
        
        searchController.panelController?.setState(.opened)
    }
    
    @objc func tappedButton(sender: UIButton) {
        guard let routeResponse = routeResponse else { return }
        // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
        let indexedRouteResponse = IndexedRouteResponse(routeResponse: routeResponse, routeIndex: currentRouteIndex)
        let navigationService = MapboxNavigationService(indexedRouteResponse: indexedRouteResponse,
                                                        customRoutingProvider: NavigationSettings.shared.directions,
                                                        credentials: NavigationSettings.shared.directions.credentials,
                                                        simulating: simulationIsEnabled ? .always : .onPoorGPS)
        
        let navigationOptions = NavigationOptions(navigationService: navigationService,
                                                  // Replace default `NavigationMapView` instance with instance that is used in preview mode.
                                                  navigationMapView: navigationMapView)
        
        let navigationViewController = NavigationViewController(for: indexedRouteResponse,
                                                                navigationOptions: navigationOptions)
        navigationViewController.delegate = self
        navigationViewController.modalPresentationStyle = .fullScreen
        
        if let latestValidLocation = navigationMapView.mapView.location.latestLocation?.location {
            navigationViewController.navigationMapView?.moveUserLocation(to: latestValidLocation)
        }
        
        startButton.isHidden = true
        
        // Hide top and bottom container views before animating their presentation.
        navigationViewController.navigationView.bottomBannerContainerView.hide(animated: false)
        navigationViewController.navigationView.topBannerContainerView.hide(animated: false)
        
        // Hide `WayNameView`, `FloatingStackView` and `SpeedLimitView` to smoothly present them.
        navigationViewController.navigationView.wayNameView.alpha = 0.0
        navigationViewController.navigationView.floatingStackView.alpha = 0.0
        navigationViewController.navigationView.speedLimitView.alpha = 0.0
        
        present(navigationViewController, animated: false) {
            // Animate top and bottom banner views presentation.
            let duration = 1.0
            navigationViewController.navigationView.bottomBannerContainerView.show(duration: duration,
                                                                                   animations: {
                navigationViewController.navigationView.wayNameView.alpha = 1.0
                navigationViewController.navigationView.floatingStackView.alpha = 1.0
                navigationViewController.navigationView.speedLimitView.alpha = 1.0
            })
            navigationViewController.navigationView.topBannerContainerView.show(duration: duration)
        }
    }
    
    // TODO: should take origin and destination
    func requestRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        print("Requesting route for \(origin) to \(destination)")
        let originWaypoint = Waypoint(coordinate: origin)
        
        let destinationWaypoint = Waypoint(coordinate: destination)
        
        let navigationRouteOptions = NavigationRouteOptions(waypoints: [originWaypoint, destinationWaypoint])
        
        Directions.shared.calculate(navigationRouteOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let self = self else { return }

                self.routeResponse = response
                self.startButton.isHidden = false
                if let routes = self.routes,
                   let currentRoute = self.currentRoute {
                    self.navigationMapView.show(routes)
                    self.navigationMapView.showWaypoints(on: currentRoute)
                }
            }
        }
    }
    
    // Delegate method called when the user selects a route
    func navigationMapView(_ mapView: NavigationMapView, didSelect route: MapboxDirections.Route) {
        self.currentRouteIndex = self.routes?.firstIndex(of: route) ?? 0
    }
    
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        let duration = 1.0
        navigationViewController.navigationView.topBannerContainerView.hide(duration: duration)
        navigationViewController.navigationView.bottomBannerContainerView.hide(duration: duration,
                                                                               animations: {
            navigationViewController.navigationView.wayNameView.alpha = 0.0
            navigationViewController.navigationView.floatingStackView.alpha = 0.0
            navigationViewController.navigationView.speedLimitView.alpha = 0.0
        },
                                                                               completion: { [weak self] _ in
            navigationViewController.dismiss(animated: false) {
                guard let self = self else { return }
                
                // Show previously hidden button that allows to start active navigation.
                self.startButton.isHidden = false
                
                // Since `NavigationViewController` assigns `NavigationMapView`'s delegate to itself,
                // delegate should be re-assigned back to `NavigationMapView` that is used in preview mode.
                self.navigationMapView.delegate = self
                
                // Replace `NavigationMapView` instance with instance that was used in active navigation.
                self.navigationMapView = navigationViewController.navigationMapView
                
                // Since `NavigationViewController` uses `UserPuckCourseView` as a default style
                // of the user location indicator - revert to back to default look in preview mode.
                self.navigationMapView.userLocationStyle = .puck2D()
                
                // Showcase originally requested routes.
                if let routes = self.routes {
                    let cameraOptions = CameraOptions(bearing: 0.0, pitch: 0.0)
                    self.navigationMapView.showcase(routes,
                                                    routesPresentationStyle: .all(shouldFit: true, cameraOptions: cameraOptions),
                                                    animated: true,
                                                    duration: duration)
                }
            }
        })
    }

    func showAnnotations(results: [SearchResult], cameraShouldFollow: Bool = true) {
        navigationMapView.pointAnnotationManager?.annotations = results.map{ searchResult -> PointAnnotation in
            var annotation = PointAnnotation(coordinate: searchResult.coordinate)
            annotation.textOffset = [0, -2]
            annotation.textColor = StyleColor(.red)
            annotation.image = .init(image: UIImage(named: "green_pin")!, name: "green_pin")
            return annotation
        }
        
        if cameraShouldFollow {
            cameraToAnnotations(navigationMapView.pointAnnotationManager!.annotations)
        }
    }
    
    func cameraToAnnotations(_ annotations: [PointAnnotation]) {
        if annotations.count == 1, let annotation = annotations.first {
            navigationMapView.mapView.camera.fly(to: .init(center: annotation.point.coordinates, zoom: 15), duration: 0.25, completion: nil)
        } else {
            let coordinatesCamera = navigationMapView.mapView.mapboxMap.camera(for: annotations.map(\.point.coordinates),
                                                         padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                                                         bearing: nil,
                                                           pitch: nil)
            navigationMapView.mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
        }
    }
    
    func showAnnotation(_ result: SearchResult) {
        showAnnotations(results: [result])
    }
    
    func showAnnotation(_ favorite: FavoriteRecord) {
        navigationMapView.pointAnnotationManager?.annotations = [PointAnnotation(favoriteRecord: favorite)]
        
        cameraToAnnotations(navigationMapView.pointAnnotationManager!.annotations)
    }
    
    func showError(_ error: Error) {
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension SimpleUISearchViewController: SearchControllerDelegate {
    func categorySearchResultsReceived(category: SearchCategory, results: [SearchResult]) {
        showAnnotations(results: results)
    }
    
    func searchResultSelected(_ searchResult: SearchResult) {
        print("Entering searchResultSelected --------------")
        if setStartLocation {
            startLocation = searchResult
            navigationBar.startField.text = startLocation?.name
            setStartLocation = false
            showAnnotation(searchResult)
        } else {
            endLocation = searchResult
            navigationBar.endField.text = endLocation?.name
            if navigationBar.startField.text == "Where from?" {
                navigationBar.startField.text = "Current location"
            }
            setStartLocation = true
        }
        print("Start location", startLocation ?? "nil")
        print("End location", endLocation ?? "nil")
        
        navigationBar.isHidden = false
        
        if let endLocation = endLocation {
            // End location given, take start location or current location.
            if let startLocation = startLocation {
                requestRoute(origin: startLocation.coordinate, destination: endLocation.coordinate)
            }
            else {
                guard let userLocation = navigationMapView.mapView.location.latestLocation else { return }
                
                let userLocationCoordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
                                          longitude: userLocation.coordinate.longitude)
                
                requestRoute(origin: userLocationCoordinates, destination: endLocation.coordinate)
            }
        }
        // No end location, do nothing
        else {
            return
        }
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
    }
    
    func searchCancelled() {
        navigationBar.isHidden = false
        
        if endLocation != nil {
            startButton.isHidden = false
        }
    }
}

extension PointAnnotation {
    init(searchResult: SearchResult) {
        self.init(coordinate: searchResult.coordinate)
        textField = searchResult.name
    }
    
    init(favoriteRecord: FavoriteRecord) {
        self.init(coordinate: favoriteRecord.coordinate)
        textField = favoriteRecord.name
    }
}

extension CLLocation {
    static let defaultLocation = CLLocation(latitude: 50.878309, longitude: 4.698938)
}

extension CLLocationCoordinate2D {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 50.878309, longitude: 4.698938)
}
