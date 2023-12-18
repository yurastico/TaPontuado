//
//  MapViewController.swift
//  Alura Ponto
//
//  Created by Yuri Cunha on 18/12/23.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    class func instantiate(_ receipt: Recibo) -> MapViewController {
        let controller = MapViewController(nibName: "MapaViewController", bundle: nil)
        controller.receipt = receipt
        return controller
    }
    
    private var receipt: Recibo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        addPin()
        
    }

    func setLocation() {
        guard let latitude = receipt?.latitude, let longitude = receipt?.longitude else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
        map.setRegion(location, animated: true)
    }
    
    func addPin() {
        let annotation = MKPointAnnotation()
        annotation.title = "Registro"
        annotation.coordinate.latitude = receipt?.latitude ?? 0
        annotation.coordinate.longitude = receipt?.longitude ?? 0
        map.addAnnotation(annotation)
        
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString("Avenida paulista") { places, error in
//            let location = places?.first
//            let latitude = location?.location?.coordinate.latitude
//            let longitue = location?.location?.coordinate.longitude
//        }
        
    }
}
