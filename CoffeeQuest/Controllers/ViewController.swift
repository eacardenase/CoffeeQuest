/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import MapKit
import YelpAPI

public class ViewController: UIViewController {
  
  // MARK: - Properties
  private var businesses = [Business]()
  public var client: BusinessSearchClient = YLPClient(apiKey: YelpAPIKey)
  private let locationManager = CLLocationManager()
  public let annotationFactory = AnnotationFactory()
  
  private lazy var mapView: MKMapView = {
    let _mapView = MKMapView()

    _mapView.showsUserLocation = true
    _mapView.userTrackingMode = .follow
    _mapView.delegate = self

    return _mapView
  }()
  
  // MARK: - View Lifecycle
  
  public override func loadView() {
    view = mapView
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    locationManager.requestWhenInUseAuthorization()
  }
  
  // MARK: - Actions
  @IBAction func businessFilterToggleChanged(_ sender: UISwitch) {
    
  }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
  
  public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
    centerMap(on: userLocation.coordinate)
  }

  public func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
    print(annotation.coordinate)
  }

  private func centerMap(on coordinate: CLLocationCoordinate2D) {
    let regionRadius: CLLocationDistance = 3000
    let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                              latitudinalMeters: regionRadius,
                                              longitudinalMeters: regionRadius)
    mapView.setRegion(coordinateRegion, animated: true)
    searchForBusinesses()
  }
  
  private func searchForBusinesses() {
    client.search(
      with: mapView.userLocation.coordinate,
      term: "coffee",
      limit: 35,
      offset: 0
    ) { [weak self] result in
      guard let self else { return }

      switch result {
      case .success(let businesses):
        self.businesses = businesses

        DispatchQueue.main.async {
          self.addAnnotations()
        }
      case .failure(let error):
        print("Search failed: \(error.localizedDescription)")
      }
    }
  }
  
  private func addAnnotations() {
    businesses.forEach {
      let viewModel = annotationFactory.createBusinessMapViewModel(for: $0)

      mapView.addAnnotation(viewModel)
    }
  }

  public func mapView(
    _ mapView: MKMapView,
    viewFor annotation: any MKAnnotation
  ) -> MKAnnotationView? {
    guard let viewModel = annotation as? BusinessMapViewModel else {
      return nil
    }

    let annotationView: MKAnnotationView

    if let existingView = mapView.dequeueReusableAnnotationView(
      withIdentifier: NSStringFromClass(BusinessMapViewModel.self)
    ) {
      annotationView = existingView
    } else {
      annotationView = MKAnnotationView(
        annotation: viewModel,
        reuseIdentifier: NSStringFromClass(BusinessMapViewModel.self)
      )
    }

    annotationView.image = viewModel.image
    annotationView.canShowCallout = true

    return annotationView
  }
}
