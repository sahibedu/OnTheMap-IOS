//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sultan on 08/04/18.
//  Copyright © 2018 Sultan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    var keyToSend = String()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateStudentInfo { (studentinfo) in
            self.setupPins()
        }
    }
    
    func populateStudentInfo(completitionHandler: @escaping(_ data: [StudentInformation]) -> ()){
        ParseNetworking().fetchStudentsFromParse(completion:{ (data) in
            let resultsData = data["results"] as! NSArray
            for key in resultsData{
                StudentDataSource.sharedInstance.studentData.append(StudentInformation(studentDict: key as! [String:Any]))
            }
            print("Student Info Populated in MapVC")
            completitionHandler(StudentDataSource.sharedInstance.studentData)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
        func setupPins() {
        for values in  StudentDataSource.sharedInstance.studentData{
            var annot = MKPointAnnotation()
            annot = values.getAnnotaions()
            mapView.addAnnotation(annot)
        }
        mapView.reloadInputViews()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = MKPinAnnotationView()
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "studentPin")
        pinView.canShowCallout = true
        pinView.annotation = annotation
        pinView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        UIApplication.shared.open(URL(string: ((view.annotation?.subtitle)!)!)!, options: [:], completionHandler: nil)
    }
    

}
