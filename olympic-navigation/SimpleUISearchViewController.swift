import UIKit
import MapboxNavigation
import MapboxMaps
import MapboxSearch
import MapboxSearchUI

class SimpleUISearchViewController: UIViewController {
    let mapView = MapView(frame: .zero)
    lazy var annotationsManager = mapView.annotations.makePointAnnotationManager()
    
    lazy var searchController: MapboxSearchController = {
        let pointLocationProvider = PointLocationProvider(coordinate: .sanFrancisco)
//        let defaultLocationProvider = DefaultLocationProvider(locationManager: .init())
        // can define category slot (horizontal) and category lists (vertical)
        // let categoryDataProvider = ConstantCategoryDataProvider()
        var configuration = Configuration(locationProvider: pointLocationProvider) // , hideCategorySlots: true)
        
        return MapboxSearchController(configuration: configuration)
    }()
    
    lazy var panelController = MapboxPanelController(rootViewController: searchController)
    
    var startLocation: SearchResult?
    var endLocation: SearchResult?
    var setStartLocation: Bool = false
    
    var startNavigationBar = NavigationBar()
    var endNavigationBar = NavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.frame = view.bounds
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        // Show user location
        mapView.location.options.puckType = .puck2D()
        
        let cameraOptions = CameraOptions(center: .sanFrancisco, zoom: 15)
        mapView.camera.fly(to: cameraOptions, duration: 1, completion: nil)
        
        startNavigationBar.label.text = "Start"
        startNavigationBar.textField.placeholder = "Where from?"
        endNavigationBar.label.text = "End"
        endNavigationBar.textField.placeholder = "Where to?"
                
        view.addSubview(startNavigationBar)
        view.addSubview(endNavigationBar)
        addNavigationBarConstraints()
        startNavigationBar.isHidden = true
        endNavigationBar.isHidden = true
        
        searchController.delegate = self
        addChild(panelController)
        
    }
    
    private func addNavigationBarConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        let navigation_bar_height: CGFloat = CGFloat(40)
        
        // Add
        constraints.append(startNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        constraints.append(startNavigationBar.heightAnchor.constraint(equalToConstant: navigation_bar_height))
        constraints.append(startNavigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(20)))
        constraints.append(startNavigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: CGFloat(-20)))
        
        constraints.append(endNavigationBar.topAnchor.constraint(equalTo: startNavigationBar.bottomAnchor, constant: CGFloat(8)))
        constraints.append(endNavigationBar.heightAnchor.constraint(equalToConstant: navigation_bar_height))
        constraints.append(endNavigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CGFloat(20)))
        constraints.append(endNavigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: CGFloat(-20)))
        
        // Activate (apply)
        NSLayoutConstraint.activate(constraints)
    }

    func showAnnotations(results: [SearchResult], cameraShouldFollow: Bool = true) {
        annotationsManager.annotations = results.map{ searchResult -> PointAnnotation in
            var annotation = PointAnnotation(coordinate: searchResult.coordinate)
            annotation.textOffset = [0, -2]
            annotation.textColor = StyleColor(.red)
            annotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
            return annotation
        }
        
        if cameraShouldFollow {
            cameraToAnnotations(annotationsManager.annotations)
        }
    }
    
    func cameraToAnnotations(_ annotations: [PointAnnotation]) {
        if annotations.count == 1, let annotation = annotations.first {
            mapView.camera.fly(to: .init(center: annotation.point.coordinates, zoom: 15), duration: 0.25, completion: nil)
        } else {
            let coordinatesCamera = mapView.mapboxMap.camera(for: annotations.map(\.point.coordinates),
                                                         padding: UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24),
                                                         bearing: nil,
                                                           pitch: nil)
            mapView.camera.fly(to: coordinatesCamera, duration: 0.25, completion: nil)
        }
    }
    
    func showAnnotation(_ result: SearchResult) {
        showAnnotations(results: [result])
    }
    
    func showAnnotation(_ favorite: FavoriteRecord) {
        annotationsManager.annotations = [PointAnnotation(favoriteRecord: favorite)]
        
        cameraToAnnotations(annotationsManager.annotations)
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
            setStartLocation = false
        } else {
            endLocation = searchResult
            setStartLocation = true
        }
        print("Start location", startLocation)
        print("End location", endLocation)
        showAnnotation(searchResult)
        
        startNavigationBar.textField.text = "Current location"
        endNavigationBar.textField.text = endLocation?.name
        
        startNavigationBar.isHidden = false
        endNavigationBar.isHidden = false

    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
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

extension CLLocationCoordinate2D {
    static let sanFrancisco = CLLocationCoordinate2D(latitude: 50.878309, longitude: 4.698938)
}
