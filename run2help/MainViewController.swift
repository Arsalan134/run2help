//
//  MainViewController.swift
//  run2help
//
//  Created by Arsalan Iravani on 03.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import CoreMotion
import MapKit
import CoreLocation
import HealthKit

class MainViewController: UIViewController, CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, UIScrollViewDelegate, MKMapViewDelegate {
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    var sportBitMask: [String: Bool] = ["cross" : false, "bike" : false, "fitness" : false, "football" : false, "basketball" : false, "tennis": false]
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var donateNowButton: UIButton!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var caloriesTextLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeTextLabel: UILabel!
    @IBOutlet weak var aznLabel: UILabel!
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dismissMapButton: UIButton!
    @IBOutlet weak var sportsScrollView: UIScrollView!
    @IBOutlet weak var mapDarker: UIView!
    
    @IBOutlet weak var arrow1: UIImageView!
    @IBOutlet weak var arrow2: UIImageView!
    @IBOutlet weak var arrow3: UIImageView!
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: String!
    }
    
    var fitnessPins : [CustomPointAnnotation] = []

    let pageTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Run2Help"
        l.font = UIFont(name: "OpenSans-Light", size: 17)
        l.textColor = UIColor.white
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 1
        l.textAlignment = .center
        return l
    }()
    
    let transition = CircularTransition()
    
    let circle1: UIImageView = {
        let c = UIImageView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.layer.masksToBounds = true
//        c.firstColor = UIColor(red:0.34, green:0.63, blue:0.20, alpha: 0.5)
//        c.secondColor = UIColor(red:0.52, green:0.77, blue:0.27, alpha: 0.5)
        c.image = #imageLiteral(resourceName: "Circle 1 Image")
        return c
    }()
    
    let circle2: GradientView = {
        let c = GradientView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.layer.masksToBounds = true
        c.firstColor = UIColor(red:0.40, green:0.66, blue:0.22, alpha: 1)
        c.secondColor = UIColor(red:0.46, green:0.71, blue:0.25, alpha: 1)
//        c.image = #imageLiteral(resourceName: "Circle 2 Image")
        return c
    }()
    
    let circle3: UIImageView = {
        let c = UIImageView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.layer.masksToBounds = true
//        c.firstColor = UIColor(red:0.44, green:0.66, blue:0.23, alpha: 1)
//        c.secondColor = UIColor(red:0.40, green:0.65, blue:0.22, alpha: 1)
        c.image = #imageLiteral(resourceName: "Circle 3 Image")
        return c
    }()
    
    let circle4: GradientView = {
        let c = GradientView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.layer.masksToBounds = true
        c.firstColor = UIColor(red:0.54, green:0.80, blue:0.27, alpha: 1)
        c.secondColor = UIColor(red:0.54, green:0.80, blue:0.27, alpha: 1)
        return c
    }()
    
    let circleBetween: GradientView = {
        let c = GradientView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.clipsToBounds = true
        c.firstColor = UIColor(red:0.58, green:0.82, blue:0.30, alpha: 0.2)
        c.secondColor = UIColor(red:0.53, green:0.78, blue:0.28, alpha: 0.2)
        return c
    }()
    
    let circleManat: GradientView = {
        let c = GradientView()
        c.translatesAutoresizingMaskIntoConstraints = false
        c.layer.masksToBounds = true
        c.firstColor = UIColor(red:0.58, green:0.81, blue:0.29, alpha: 1.00)
        c.secondColor = UIColor(red:0.49, green:0.74, blue:0.26, alpha: 1.00)
        return c
    }()
    
    let totalDistanceLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "OpenSans-Bold", size: 36)
        l.textColor = UIColor.white
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 1
        l.textAlignment = .right
        return l
    }()
    
    let KmLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "OpenSans-Light", size: 36)
        l.textColor = UIColor.white
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 1
        l.textAlignment = .left
        return l
    }()
    
    let totalStepsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: "OpenSans-Light", size: 18)
        l.textColor = UIColor.white
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 1
        l.textAlignment = .center
        //        l.backgroundColor = UIColor.yellow
        //        l.alpha = 0.2
        return l
    }()
    
    //    var healthManager: HealthKitManager = HealthKitManager()
    var mapIsOpen: Bool = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !mapIsOpen {
            let location = locations[0]
            let span = MKCoordinateSpanMake(0.002, 0.002)
            let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
        //        print(location)
    }
    
    
    //function to convert the given UIView into a UIImage
    func imageWithView(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func drawPageTitle() {
        view.addSubview(pageTitle)
        pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageTitle.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        pageTitle.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        pageTitle.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
    }
    
    func drawProfileImageButton() {
        
        profileImageButton.translatesAutoresizingMaskIntoConstraints = false
        profileImageButton.clipsToBounds = true
        profileImageButton.contentMode = .scaleAspectFill
        if let photo = currentUser.profileImage {
            profileImageButton.setBackgroundImage(photo, for: .normal)
        } else {
            profileImageButton.backgroundColor = UIColor.gray
        }
        profileImageButton.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        profileImageButton.centerYAnchor.constraint(equalTo: pageTitle.centerYAnchor).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func drawCircles() {
        view.addSubview(circle1)
        view.addSubview(circle2)
        view.addSubview(circle3)
        view.addSubview(circle4)
        view.addSubview(circleBetween)
        view.addSubview(circleManat)
        
        //        self.layer.cornerRadius = cornerRadius
        //        self.layer.borderWidth = borderWidth
        //        self.layer.borderColor = borderColor.cgColor
        
        circle1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.09).isActive = true
        circle1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.09).isActive = true
        
        circle2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle2.widthAnchor.constraint(equalTo: circle1.widthAnchor, multiplier: 0.78).isActive = true
        circle2.heightAnchor.constraint(equalTo: circle1.widthAnchor, multiplier: 0.78).isActive = true
        
        circle3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle3.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle3.widthAnchor.constraint(equalTo: circle2.widthAnchor, multiplier: 0.724).isActive = true
        circle3.heightAnchor.constraint(equalTo: circle2.widthAnchor, multiplier: 0.724).isActive = true
        
        circle4.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle4.widthAnchor.constraint(equalTo: circle3.widthAnchor, multiplier: 0.701).isActive = true
        circle4.heightAnchor.constraint(equalTo: circle3.widthAnchor, multiplier: 0.701).isActive = true
        
        circleBetween.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleBetween.topAnchor.constraint(equalTo: circle3.bottomAnchor).isActive = true
        circleBetween.widthAnchor.constraint(equalTo: circle4.widthAnchor, multiplier: 0.913).isActive = true
        circleBetween.heightAnchor.constraint(equalTo: circle4.heightAnchor, multiplier: 0.913).isActive = true
        
        circleManat.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleManat.centerYAnchor.constraint(equalTo: circle1.bottomAnchor).isActive = true
        circleManat.widthAnchor.constraint(equalTo: circleBetween.widthAnchor, multiplier: 0.5).isActive = true
        circleManat.heightAnchor.constraint(equalTo: circleBetween.heightAnchor, multiplier: 0.5).isActive = true
    }
    
    func drawDistance() {
        circle4.addSubview(totalDistanceLabel)
        circle4.addSubview(KmLabel)
        circle4.addSubview(totalStepsLabel)
        
        let offset: CGFloat = 12
        
        totalDistanceLabel.rightAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalDistanceLabel.centerYAnchor.constraint(equalTo: circle4.centerYAnchor, constant: -offset).isActive = true
        totalDistanceLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalDistanceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        KmLabel.leftAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        KmLabel.centerYAnchor.constraint(equalTo: circle4.centerYAnchor, constant: -offset).isActive = true
        KmLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        KmLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        totalStepsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalStepsLabel.centerYAnchor.constraint(equalTo: circle4.centerYAnchor, constant: offset).isActive = true
        totalStepsLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        totalStepsLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    var showProfile: Bool = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocationsViewController" {
            let secondVC = segue.destination as? DonationViewController
            secondVC?.transitioningDelegate = self
            secondVC?.modalPresentationStyle = .custom
            showProfile = false
        } else if segue.identifier == "showProfileViewController" {
            let secondVC = segue.destination as? UserProfileViewController
            secondVC?.transitioningDelegate = self
            secondVC?.modalPresentationStyle = .custom
            showProfile = true
        }
    }
    
    let topPink = #colorLiteral(red: 0.3823215365, green: 0.2853678465, blue: 0.7138758302, alpha: 1)
    let bottomPink = #colorLiteral(red: 0.5778232813, green: 0.4517942071, blue: 0.8250282407, alpha: 1)
    let topGreen = UIColor(red:0.24, green:0.52, blue:0.15, alpha:1.00)
    let bottomGreen = UIColor(red:0.63, green:0.88, blue:0.30, alpha:1.00)
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        if showProfile {
            transition.startingPoint = profileImageButton.center
            transition.topColor = topPink
            transition.bottomColor = bottomPink
        } else {
            transition.startingPoint = circleManat.center
            transition.topColor = topGreen
            transition.bottomColor = bottomGreen
        }
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        if showProfile {
            transition.startingPoint = profileImageButton.center
            transition.topColor = topPink
            transition.bottomColor = bottomPink
        } else {
            transition.startingPoint = circleManat.center
            transition.topColor = topPink
            transition.bottomColor = bottomPink
        }
        return transition
    }
    
    func drawDonateButton() {
        donateNowButton.translatesAutoresizingMaskIntoConstraints = false
        donateNowButton.clipsToBounds = true
        donateNowButton.backgroundColor = UIColor(red:0.38, green:0.28, blue:0.74, alpha:1.00)
        donateNowButton.layer.cornerRadius = 25
        
        donateNowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        donateNowButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        donateNowButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func repositionLabels() {
        let offset: CGFloat = 2
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.textAlignment = .center
        balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        balanceLabel.bottomAnchor.constraint(equalTo: circleManat.centerYAnchor, constant: -offset).isActive = true
        balanceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        balanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        aznLabel.translatesAutoresizingMaskIntoConstraints = false
        aznLabel.textAlignment = .center
        aznLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aznLabel.topAnchor.constraint(equalTo: circleManat.centerYAnchor, constant: offset).isActive = true
        aznLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        aznLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
        
        totalCaloriesLabel.translatesAutoresizingMaskIntoConstraints = false
        totalCaloriesLabel.textAlignment = .center
        totalCaloriesLabel.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true
        totalCaloriesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        totalCaloriesLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        caloriesTextLabel.translatesAutoresizingMaskIntoConstraints = false
        caloriesTextLabel.textAlignment = .center
        caloriesTextLabel.centerXAnchor.constraint(equalTo: totalCaloriesLabel.centerXAnchor).isActive = true
        caloriesTextLabel.centerYAnchor.constraint(equalTo: aznLabel.centerYAnchor).isActive = true
        caloriesTextLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        caloriesTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        timeLabel.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor).isActive = true
        
        timeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        timeTextLabel.textAlignment = .center
        timeTextLabel.centerXAnchor.constraint(equalTo: timeLabel.centerXAnchor).isActive = true
        timeTextLabel.centerYAnchor.constraint(equalTo: aznLabel.centerYAnchor).isActive = true
        timeTextLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeTextLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
    @IBAction func dismissMap() {
        barView.isHidden = true
        mapDarker.isHidden = false
        mapView.isScrollEnabled = false
        
        
        self.mapViewConstraint.constant = 405
        
        UIView.animate(withDuration: 0.2, animations: {
            self.mapDarker.alpha = 0.5
            self.mapView.layer.cornerRadius = self.mapView.frame.size.width / CGFloat(2.0)
            self.mapDarker.layer.cornerRadius = self.mapView.frame.size.width / CGFloat(2.0)
        })
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
        mapIsOpen = false
    }
    
    func openMapBySwiping() {
        mapIsOpen = true
        barView.isHidden = false
        mapView.isScrollEnabled = true
        self.mapViewConstraint.constant = 0
        self.mapDarker.layer.cornerRadius = 0
        
        UIView.animate(withDuration: 0.2, animations: {
            self.mapDarker.alpha = 0
            self.mapView.layer.cornerRadius = 0
        })
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func addGesture() {
        let directions: [UISwipeGestureRecognizerDirection] = [.up]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.openMapBySwiping))
            gesture.direction = direction
            mapDarker.addGestureRecognizer(gesture)
        }
    }
    
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var fitnessButton: UIButton!
    @IBOutlet weak var footballButton: UIButton!
    @IBOutlet weak var basketballButton: UIButton!
    @IBOutlet weak var tennisButton: UIButton!
    
    @IBAction func sportSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0: // cross
            if let select = sportBitMask["cross"] {
                sportBitMask["cross"] = !select
                if select {
                    crossButton.alpha = 1
                } else {
                    crossButton.alpha = 0.5
                }
            }
        case 1: // bike
            if let select = sportBitMask["bike"] {
                sportBitMask["bike"] = !select
                if select {
                    bikeButton.alpha = 1
                } else {
                    bikeButton.alpha = 0.5
                }
            }
        case 2: // fitness
            if let select = sportBitMask["fitness"] {
                sportBitMask["fitness"] = !select
                if select {
                    fitnessButton.alpha = 1
                    mapView.addAnnotations(fitnessPins)
                } else {
                    fitnessButton.alpha = 0.5
                    mapView.removeAnnotations(fitnessPins)
                }
            }
        case 3: // football
            if let select = sportBitMask["football"] {
                sportBitMask["football"] = !select
                if select {
                    footballButton.alpha = 1
                } else {
                    footballButton.alpha = 0.5
                }
            }
        case 4: // basketball
            if let select = sportBitMask["basketball"] {
                sportBitMask["basketball"] = !select
                if select {
                    basketballButton.alpha = 1
                } else {
                    basketballButton.alpha = 0.5
                }
            }
        case 5: // tennis
            if let select = sportBitMask["tennis"] {
                sportBitMask["tennis"] = !select
                if select {
                    tennisButton.alpha = 1
                } else {
                    tennisButton.alpha = 0.5
                }
            }
        default:
            break
        }
    }
    
    
    @IBOutlet weak var mapViewConstraint: NSLayoutConstraint!
    var locationManager = CLLocationManager()
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            print("NOT REGISTERED AS MKPOINTANNOTATION")
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pokemonIdentitfier")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pokemonIdentitfier")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let cpa = annotation as? CustomPointAnnotation {
            annotationView?.image = UIImage(named: cpa.imageName)
        }
        
        annotationView?.frame.size.width = 40
        annotationView?.frame.size.height = 40
        
        let title: UILabel = UILabel()
        title.text = annotation.title!
        
        annotationView?.addSubview(title)
        
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .white
        title.numberOfLines = 0
        title.font = UIFont(name: "OpenSans-Light", size: 10)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textAlignment = .center
        
        title.leftAnchor.constraint(equalTo: (annotationView?.leftAnchor)!, constant: 2).isActive = true
        title.topAnchor.constraint(equalTo: (annotationView?.topAnchor)!, constant: 2).isActive = true
        title.rightAnchor.constraint(equalTo: (annotationView?.rightAnchor)!, constant: -2).isActive = true
        title.bottomAnchor.constraint(equalTo: (annotationView?.bottomAnchor)!, constant: -2).isActive = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.tag)
        print("Selected")
        
    }
    
    func animateArrows() {
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.arrow3.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 0.5, options: [.repeat, .autoreverse], animations: {
            self.arrow2.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1, options: [.repeat, .autoreverse], animations: {
            self.arrow1.alpha = 1
        }, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateArrows()
    }
    
    
    func addPins() {
        var FitFitnessGymPin = CustomPointAnnotation()
        let FitFitnessPinCoordinates = CLLocationCoordinate2DMake(40.400020, 49.847964)
        FitFitnessGymPin.coordinate = FitFitnessPinCoordinates
        FitFitnessGymPin.title = "Fit Fitness Gym"
        FitFitnessGymPin.imageName = "pin.png"
        fitnessPins.append(FitFitnessGymPin)
    }
    
    // MARK: Main
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let layer = self.view.layer as? CAGradientLayer
        layer?.colors = [topGreen.cgColor, bottomGreen.cgColor]

        drawCircles()
        drawDistance()
        drawPageTitle()
        drawProfileImageButton()
        drawDonateButton()
        repositionLabels()
        addGesture()
        addPins()
        
        
        self.arrow1.alpha = 0.2
        self.arrow2.alpha = 0.2
        self.arrow3.alpha = 0.2
        
        //map
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapDarker.clipsToBounds = true
        mapDarker.backgroundColor = UIColor.black
        mapDarker.alpha = 0.5
        mapDarker.layer.cornerRadius = mapView.frame.size.width / CGFloat(2.0)
        
        mapView.layer.cornerRadius = mapView.frame.size.width / CGFloat(2.0)
        mapView.isScrollEnabled = false
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        dismissMapButton.translatesAutoresizingMaskIntoConstraints = false
        dismissMapButton.centerYAnchor.constraint(equalTo: pageTitle.centerYAnchor).isActive = true
        dismissMapButton.centerXAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        dismissMapButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        dismissMapButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        barView.isHidden = true
        self.sportsScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 40)
        
        fetchUserToMainView()
        
        let healthKitManager = HealthKitManager()
        if HKHealthStore.isHealthDataAvailable() {
            // add code to use HealthKit here...
            healthKitManager.main()
        }
        
        
        //        let newLayer = CAGradientLayer()
        //        newLayer.colors = [ UIColor(red:0.30, green:0.60, blue:0.18, alpha:1.00).cgColor, UIColor(red:0.65, green:0.90, blue:0.31, alpha:1.00).cgColor]
        //        newLayer.frame = view.frame
        //
        //        view.layer.addSublayer(newLayer)
        //        view.layer.insertSublayer(newLayer, at: 0)
        
        
        
        //        let marker = GMSMarker()
        //        // I have taken a pin image which is a custom image
        //        let markerImage = UIImage(named: "mapMarker")!.withRenderingMode(.alwaysTemplate)
        //        //creating a marker view
        //        let markerView = UIImageView(image: markerImage)
        //        //changing the tint color of the image
        //        markerView.tintColor = UIColor.red
        //        marker.position = CLLocationCoordinate2D(latitude: 28.7041, longitude: 77.1025)
        //        marker.iconView = markerView
        //        marker.title = "New Delhi"
        //        marker.snippet = "India"
        //        marker.map = mapView
        //
        //        //comment this line if you don't wish to put a callout bubble
        //        mapView.selectedMarker = marker
        
        
        
        
        //        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
        //            if authorized {
        //                print("HealthKit authorization received.")
        //            }
        //            else {
        //                print("HealthKit authorization denied!")
        //                if error != nil {
        //                    print("\(String(describing: error))")
        //                }
        //            }
        //        }
        
        // We cannot access the user's HealthKit data without specific permission.
        //        getHealthKitPermission()
        
        //        let queue = DispatchQueue(label: "downloadUserFromDatabase")
        //
        //        queue.async {
        //
        //            downloadUserFromDatabase()
        //
        //            DispatchQueue.main.async {
        //                self.fetchUserToMainView()
        //            }
        //
        //        }
        
        var cal = Calendar.current
        let setOfComponents: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute , .second]
        var components = cal.dateComponents(setOfComponents, from: Date())
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        cal.timeZone = .autoupdatingCurrent
        
        guard let midnightOfToday = cal.date(from: components) else { print("Error 12"); return }
        
        if(CMMotionActivityManager.isActivityAvailable()){
            
            activityManager.startActivityUpdates(to: .main, withHandler: { (data: CMMotionActivity!) in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    
                    //                    if data.stationary {
                    //                        self.activityState.text = "Stationary"
                    //                        //                        self.stateImageView.image = UIImage(named: "Sitting")
                    //                    }
                    //                    if data.walking {
                    //                        self.activityState.text = "Walking"
                    //                        //                        self.stateImageView.image = UIImage(named: "Walking")
                    //                    }
                    //                    if data.running {
                    //                        self.activityState.text = "Running"
                    //                    }
                    //                    if data.cycling {
                    //                        self.activityState.text = "Cycling"
                    //                        //                        self.stateImageView.image = UIImage(named: "Walking")
                    //                    }
                    //                    if data.automotive {
                    //                        self.activityState.text = "Automotive"
                    //                    }
                    //                    if data.unknown {
                    //                        self.activityState.text = "Unknown"
                    //                        //                        self.stateImageView.image = UIImage(named: "Walking")
                    //                    }
                })
            })
            
            //            var a: [CMMotionActivity] = []
            //            activityManager.queryActivityStarting(from: midnightOfToday, to: Date(), to: .main) { (a, error) in
            //                print(a?.count)
            //                print("Stttt", a?[0].startDate)
            //            }
        }
        
        if(CMPedometer.isStepCountingAvailable()){
            pedometer.queryPedometerData(from: midnightOfToday, to: Date(), withHandler: { (data, error) in
                DispatchQueue.main.async(execute: {
                    if(error == nil){
                        self.totalDistanceLabel.text = "\(data?.distance ?? 0)"
                        self.totalStepsLabel.text = "\(data?.numberOfSteps ?? 0) steps"
                    }
                })
            })
            pedometer.startUpdates(from: midnightOfToday, withHandler: { (data, error) in
                DispatchQueue.main.async(execute: {
                    if error != nil {
                        print(error ?? "some error 1")
                        return
                    }
                    
                    self.totalStepsLabel.text = "\(data?.numberOfSteps ?? -2) steps"
                    
                    if let d: Double = data?.distance as? Double {
                        if d > 1000 {
                            self.totalDistanceLabel.text = "\(String(format: "%.2f", d / 1000.0))"
                            self.KmLabel.text = "km"
                        } else {
                            self.totalDistanceLabel.text = "\(Int(d))"
                            self.KmLabel.text = "m"
                        }
                    }
                })
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        circle1.layer.cornerRadius = self.circle1.frame.size.width / 2.0
        circle2.layer.cornerRadius = self.circle2.frame.size.width / 2.0
        circle3.layer.cornerRadius = self.circle3.frame.size.width / 2.0
        circle4.layer.cornerRadius = self.circle4.frame.size.width / 2.0
        circleBetween.layer.cornerRadius = self.circleBetween.frame.size.width / 2.0
        circleManat.layer.cornerRadius = self.circleManat.frame.size.width / 2.0
        
        donateNowButton.centerYAnchor.constraint(equalTo: circleBetween.bottomAnchor, constant: 30).isActive = true
        
        circle1.bottomAnchor.constraint(equalTo: circle3.bottomAnchor, constant: (self.circle1.frame.size.width - self.circle3.frame.size.width) / 2 ).isActive = true
        circle2.bottomAnchor.constraint(equalTo: circle3.bottomAnchor, constant: (self.circle2.frame.size.width - self.circle3.frame.size.width) / 2 ).isActive = true
        circle4.bottomAnchor.constraint(equalTo: circle3.bottomAnchor, constant: (self.circle4.frame.size.width - self.circle3.frame.size.width) / 2 ).isActive = true
        
        totalCaloriesLabel.centerXAnchor.constraint(equalTo: circle2.leftAnchor, constant: (self.circle2.frame.size.width - self.circle3.frame.size.width) / 3).isActive = true
        
        timeLabel.centerXAnchor.constraint(equalTo: circle2.rightAnchor, constant: -(self.circle2.frame.size.width - self.circle3.frame.size.width) / 3).isActive = true
        
        profileImageButton.layer.cornerRadius = profileImageButton.layer.frame.size.width / 2.0
        
        mapDarker.layer.cornerRadius = mapView.frame.size.width / CGFloat(2.0)
        
        self.view.insertSubview(balanceLabel, aboveSubview: circleManat)
        self.view.insertSubview(circleBetween, aboveSubview: circle1)
        self.view.insertSubview(aznLabel, aboveSubview: circleManat)
        self.view.insertSubview(mapView, at: 20)
        self.view.insertSubview(barView, at: 20)
        self.view.insertSubview(profileImageButton, aboveSubview: barView)
        self.view.insertSubview(pageTitle, aboveSubview: barView)
        self.view.insertSubview(mapDarker, aboveSubview: mapView)
    }
    
    //    func getHealthKitPermission() {
    //        // Seek authorization in HealthKitManager.swift.
    //        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
    //            if authorized {
    //                // Get and set the user's height.
    //                //                HealthKitManager.setHeight()
    //                print("Authorized")
    //            } else {
    //                if error != nil {
    //                    print(error)
    //                }
    //                print("Permission denied.")
    //            }
    //        }
    //    }
    
    func fetchUserToMainView() {
        totalCaloriesLabel.text = "\(currentUser.caloriesBurned ?? 297 )"
        if let balance = currentUser.balance {
            balanceLabel.text = "\(Int.init(balance))"
        }
    }
}








