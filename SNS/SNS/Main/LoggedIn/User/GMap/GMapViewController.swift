//
//  GMapViewController.swift
//  SNS
//
//  Created by Je Min Son on 11/28/18.
//  Copyright © 2018 Jason Son. All rights reserved.
//

import UIKit
import GoogleMaps


let RECTNOTEZomOut: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40)

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
                let imgView = UIImageView(frame: RECTNOTEZomOut)
                imgView.layer.borderWidth = 2
                imgView.layer.borderColor = UIColor.orange.cgColor
                imgView.layer.cornerRadius = imgView.frame.height/2
                imgView.layer.masksToBounds = false
                imgView.clipsToBounds = true
                imgView.image = user.img!
                marker.iconView = imgView
                marker.map = self.mapView
                
                self.mapView.camera = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
            }
            
        }
    }

}
