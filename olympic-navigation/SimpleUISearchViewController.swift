import UIKit
import MapboxMaps
import MapboxSearchUI

class SimpleUISearchViewController: MapsViewController {
    
    lazy var searchController: MapboxSearchController = {
        let locationProvider = PointLocationProvider(coordinate: .sanFrancisco)
        // can define category slot (horizontal) and category lists (vertical)
        // let categoryDataProvider = ConstantCategoryDataProvider()
        var configuration = Configuration(locationProvider: locationProvider) // , hideCategorySlots: true)
        
        return MapboxSearchController(configuration: configuration)
    }()
    
    var mapbox_pc_configuration = MapboxPanelController.Configuration(state: .collapsed)
    lazy var panelController = MapboxPanelController(rootViewController: searchController, configuration: mapbox_pc_configuration)
    
    var startButton: UIButton!

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
        print("Entering searchResultSelected --------------")
        print(panelController.state)
        panelController.setState(.hidden, animated: true)
        print(panelController.state)
        showAnnotation(searchResult)
        print(panelController.state)
        panelController.setState(.hidden, animated: true)
        print(panelController.state)
        
        startButton = UIButton()
        startButton.setTitle("Start Navigation", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = .blue
//        startButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        startButton.addTarget(self, action: #selector(tappedButton(sender:)), for: .touchUpInside)
        startButton.isHidden = false
        view.addSubview(startButton)
    }
    
    func userFavoriteSelected(_ userFavorite: FavoriteRecord) {
        showAnnotation(userFavorite)
    }
}
