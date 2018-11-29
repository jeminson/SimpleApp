//
//  GMapViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/28/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import GoogleMaps


class GMapViewController: MRKBaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var userInfoArray : [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUsersLocation(userInfo: userInfoArray)
    }
    
    func showUsersLocation(userInfo: [UserInfo]) {
        
        for user in userInfo {
            let coordinateLatitude = Double(user.latitude!)!
            let coordinateLongitude = Double(user.longitude!)!
            let location = CLLocation(latitude: coordinateLatitude, longitude: coordinateLongitude)
            let smallImage = UIImage().resizeimage(image: user.img!, withSize: CGSize(width: 40.0, height: 40.0))
            
            DispatchQueue.main.async {
                let marker = GMSMarker()
                marker.position = location.coordinate
                marker.title = user.firstName
                marker.icon = smallImage
                marker.map = self.mapView
                marker.isDraggable = true
                
                self.mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
            }
            
        }
    }

}
