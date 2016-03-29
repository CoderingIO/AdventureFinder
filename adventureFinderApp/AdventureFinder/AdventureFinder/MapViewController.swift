//
//  MapViewController.swift
//  AdventureFinder
//
//  Created by Wayne Bangert on 3/27/16.
//  Copyright © 2016 Wayne Bangert. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol HandleMapSearch {
    func dropPinZoom(placemark:MKPlacemark)
}


class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let ref = Firebase(url: "https://adventurefinder.firebaseio.com/")
    let usersRef = Firebase(url: "https://adventurefinder.firebaseio.com/")

    var user: User!
    
    var adventures = [AdventureItem]()
    
    var selectedPin:MKPlacemark? = nil
    
    var searchResultController:UISearchController? = nil
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var mapTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Search
        let searchTable = storyboard!.instantiateViewControllerWithIdentifier("SearchTableViewController") as! SearchTableViewController
        searchResultController = UISearchController(searchResultsController: searchTable)
        searchResultController?.searchResultsUpdater = searchTable
        
        searchResultController?.hidesNavigationBarDuringPresentation = false
        searchResultController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        let searchBar = searchResultController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for adventures"
        navigationItem.titleView = searchResultController?.searchBar
        
    searchTable.mapView = mapView
        
        // pin maker
        searchTable.handleMapSearchDelegate = self
        
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            }, withCancelBlock: {error in
                print(error.description)
        })
        
        user = User(uid: "FakeID", email: "looking@for.fun")
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.queryOrderedByChild("completed")/*("distance").queryStartingAtValue(0)*/.observeEventType(.Value, withBlock: { snapshot in
            
            var newAdventures = [AdventureItem]()
            
            for adventure in snapshot.children {
                
                let adventureItem = AdventureItem(snapshot: adventure as! FDataSnapshot)
                newAdventures.append(adventureItem)
            }
            self.adventures = newAdventures
            self.mapTableView.reloadData()
        })
        ref.observeAuthEventWithBlock { authData in
            if authData != nil {
                self.user = User(authData: authData)
                
                let currentUserRef = self.usersRef.childByAppendingPath(self.user.uid)
                
                currentUserRef.setValue(self.user.email)
                
                currentUserRef.onDisconnectRemoveValue()
            }
        }
    }
    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return adventures.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdventureCell") as! AdventureItemTableViewCell
        
        let adventureItem = adventures[indexPath.row]
        
        cell.adventure = adventureItem
        cell.configureView()
        
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController : CLLocationManagerDelegate {
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            print("location: :\(location)")
        }
    }
    
    func locationManager(manager:CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoom(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
        pinView?.pinTintColor = UIColor.greenColor()
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: #selector(getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView

    }
}

