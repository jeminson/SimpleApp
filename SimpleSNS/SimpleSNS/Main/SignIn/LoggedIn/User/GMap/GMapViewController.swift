//
//  GMapViewController.swift
//  SimpleSNS
//
//  Created by Je Min Son on 12/1/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import GoogleMaps

let RECTNOTEZoomIn: CGRect = CGRect(x: 0, y: 0, width: 80, height: 80)
let RECTNOTEZomOut: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)

class GMapViewController: MRKBaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var selectedMarker : GMSMarker?
    
    var userInfoArray : [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        showUsersLocation(userLocation: userInfoArray)
    }

    func showUsersLocation(userLocation: [UserModel]) {
        
        for user in userLocation {
            let coordinateLatitude = Double(user.latitude!)!
            let coordinateLongitude = Double(user.longitude!)!
            let location = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
            
            DispatchQueue.main.async {
                let marker = GMSMarker()
                marker.position = location.coordinate
                marker.title = user.firstName
                let imgView = UIImageView(frame: RECTNOTEZomOut)
                imgView.layer.borderWidth = 2
                imgView.layer.borderColor = UIColor.orange.cgColor
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.layer.masksToBounds = false
                imgView.clipsToBounds = true
                imgView.image = user.image!
                marker.iconView = imgView
                marker.map = self.mapView
                
                self.mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
            }
            
        }
    }

}

extension GMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = selectedMarker {
            marker.iconView!.frame = RECTNOTEZomOut
            marker.iconView!.layer.cornerRadius = 40/2
            marker.iconView!.layer.masksToBounds = false
            marker.iconView!.clipsToBounds = true
        }
        if let ImageView = marker.iconView as? UIImageView{
            selectedMarker = marker
            ImageView.frame = RECTNOTEZoomIn
            ImageView.layer.cornerRadius = 80/2
            ImageView.layer.masksToBounds = false
            ImageView.clipsToBounds = true
            self.mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 17)
            
        }
        
        return true
    }
}
