//
//  DonationItemViewController.swift
//  run2help
//
//  Created by Arsalan Iravani on 26.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase

var cardViewArray = [DonationItemView]()

class DonationViewController: UIViewController, UIScrollViewDelegate {
    
    var index: Int = 0
    
    @IBOutlet weak var donationScrollView: UIScrollView!
    @IBOutlet weak var donationPageControl: UIPageControl!
    @IBOutlet weak var profileImage: RoundButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpDonateButton: UIButton!
    @IBOutlet weak var popUPHowMuchText: UILabel!
    @IBOutlet weak var popUpBalanceText: UILabel!
    
    @IBOutlet weak var donationTitle: UILabel!
    let loadingIndicator = UIActivityIndicatorView()
    
    let topGreen = UIColor(red:0.24, green:0.52, blue:0.15, alpha:1.00)
    let bottomGreen = UIColor(red:0.63, green:0.88, blue:0.30, alpha:1.00)
    
    
    @IBOutlet weak var thankYouPopup: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var grayBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.masksToBounds = true
        thankYouPopup.clipsToBounds = true
        
        popUpView.layer.cornerRadius = 10
        thankYouPopup.layer.cornerRadius = 10
        view.insertSubview(popUpView, aboveSubview: donationScrollView)
        popUpBalanceText.text = "Your balance: \(currentUser.balance ?? -1) AZN"
        popUpBalanceText.adjustsFontSizeToFitWidth = true
        
        let layer = self.view.layer as? CAGradientLayer
        layer?.colors = [topGreen.cgColor, bottomGreen.cgColor]
        
        //        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        self.donationScrollView.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: self.donationScrollView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: self.donationScrollView.centerYAnchor).isActive = true
        
        index = 0
        
        donationPageControl.isHidden = true
        donationPageControl.hidesForSinglePage = true
        
        if let photo = currentUser.profileImage {
            profileImage.setBackgroundImage(photo, for: .normal)
        }
        
        donationScrollView.isPagingEnabled = true
        donationScrollView.delegate = self
        
        donationPageControl.currentPageIndicatorTintColor = UIColor(red: 0.47, green: 0.72, blue: 0.31, alpha: 1)
        
        donationScrollView.showsHorizontalScrollIndicator = false
        donationScrollView.showsVerticalScrollIndicator = false
        
        //                donationScrollView.backgroundColor = UIColor.yellow
        
        cardViewArray.removeAll()
        
        downloadCards()
        
    }
    
    func downloadCards() {
        print("Before Downloading")
        
        // Get a reference to the storage service using the default Firebase App
        let storage = FIRStorage.storage()
        let storageRef = storage.reference()
        let donationsImagesReference = storageRef.child("DonationsImages")
        let spaceRef = storageRef.child("\(donationsImagesReference)/detDom.jpg")
        
        print("Reference is :", spaceRef)
        
        // Start the download (in this case writing to a file)
        let downloadTask = storageRef.child("DonationsImages/detDom.jpg").write(toFile: URL(fileURLWithPath: "DonationsImages/detDom.jpg"))
        
        // Observe changes in status
        // Download resumed, also fires when the download starts
        downloadTask.observe(.resume) { snapshot in
            print("Resumed or Startded")
        }
        
        // Download paused
        downloadTask.observe(.pause) { snapshot in
            print("Paused")
        }
        
        // Download reported progress
        downloadTask.observe(.progress) { snapshot in
            let percentComplete: Double = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            
            //            print("Percentage is:", percentComplete)
        }
        
        // Download completed successfully
        downloadTask.observe(.success) { snapshot in
            print("Download completed successfully")
        }
        
        // Errors only occur in the "Failure" case
        downloadTask.observe(.failure) { snapshot in
            guard let errorCode = (snapshot.error as NSError?)?.code else {
                return
            }
            guard let error = FIRStorageErrorCode(rawValue: errorCode) else {
                return
            }
            switch (error) {
            case .objectNotFound:
                print("File doesn't exist")
                break
            case .unauthorized:
                print("User doesn't have permission to access file")
                break
            case .cancelled:
                print("User cancelled the download")
                break
            case .unknown:
                print("Unknown error occurred, inspect the server response")
                break
            default:
                print("Another error occurred. This is a good place to retry the download.")
                break
            }
        }
        
        FIRDatabase.database().reference().child("Donations").observe( .childAdded, with: { (snapshot) in
            
            // FIXME: Maybe crash
            print("During Downloading", snapshot.key)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let id = snapshot.key
                
                if let title = dictionary["title"] as? String,
                    let descriptionText = dictionary["description"] as? String,
                    let imageURL = dictionary["imageURL"] as? String,
                    let numberOfDonatedPeople = dictionary["numberOfDonatedPeople"] as? Int,
                    let donatedMoney = dictionary["donatedMoney"] as? Int {
                    
                    // Image
                    // FIXME: check cache
                    if let url = URL(string: imageURL) {
                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                            // Dowload hit an error so let's return out
                            if error != nil {
                                print(error ?? "error")
                                return
                            }
                            
                            print("\n\nDownloaded id :", id, "Data:", data ?? "")
                            
                            guard let imageData = UIImage(data: data!) else { return }
                            let card = Card(id: id, title: title, descriptionText: descriptionText, image: imageData,  numberOfDonatedPeople: numberOfDonatedPeople, donatedMoney: donatedMoney)
                            
                            DispatchQueue.main.async {
                                _ = self.createCardView(card: card, draw: true)
                            }
                            
                        }).resume()
                    }
                }
            }
        })
    }
    //        FIRDatabase.database().reference().child("Donations").observe( .childChanged, with: { (snapshot) in
    //            // FIXME: Maybe crash
    //            print("During Downloading", snapshot.key)
    //
    //            if let dictionary = snapshot.value as? [String: AnyObject] {
    //                let id = snapshot.key
    //
    //                if let title = dictionary["title"] as? String,
    //                    let descriptionText = dictionary["description"] as? String,
    //                    let imageURL = dictionary["imageURL"] as? String,
    //                    let numberOfDonatedPeople = dictionary["numberOfDonatedPeople"] as? Int,
    //                    let donatedMoney = dictionary["donatedMoney"] as? Int {
    //
    //                    // Image
    //                    // FIXME: check cache
    //                    if let url = URL(string: imageURL) {
    //                        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
    //                            // Dowload hit an error so let's return out
    //                            if error != nil {
    //                                print(error ?? "error")
    //                                return
    //                            }
    //
    //                            print("\n\nDownloaded id :", id, "Data:", data ?? "")
    //
    //                            guard let imageData = UIImage(data: data!) else { return }
    //                            let card = Card(id: id, title: title, descriptionText: descriptionText, image: imageData,  numberOfDonatedPeople: numberOfDonatedPeople, donatedMoney: donatedMoney)
    //
    //                            DispatchQueue.main.async {
    ////                                _ = self.createCardView(card: card, draw: true)
    //                             _ = self.createCardView(card: card, draw: true)
    //                            }
    //
    //                        }).resume()
    //                    }
    //                }
    //            }
    //        })
    //        print("Done downloading")
    //    }
    
    func changeCard(_ card: Card) {
        if let idOptional = card.id {
            let index = findCard(withID: idOptional)
            if index != -1 {
                if let newCard = createCardView(card: card, draw: false){
                    cardViewArray[index] = newCard
                    redraw(atIndex: index)
                }
            }
            print("Changed")
        }
    }
    
    func redrawAll() {
        for (index, card) in cardViewArray.enumerated() {
            
            let pageWidth = donationScrollView.frame.size.width
            let page = Int(floor((donationScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            
            self.donationScrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(cardViewArray.count), height: self.donationScrollView.bounds.size.height)
            
            self.donationScrollView.contentSize = CGSize(width: donationScrollView.frame.size.width * CGFloat(cardViewArray.count), height: self.donationScrollView.bounds.size.height)
            
            var frame = donationScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page) * CGFloat(index)
            frame.origin.y = 0.0
            frame = frame.insetBy(dx: 5.0, dy: 0.0)
            
            card.frame = frame
            self.donationPageControl.isHidden = false
            self.donationPageControl.numberOfPages = cardViewArray.count
            self.donationScrollView.addSubview(card)
        }
    }
    
    
    func redraw(atIndex index: Int) {
        let cardView = cardViewArray[index]
        // Position
        cardView.frame.origin.x = CGFloat(index) * CGFloat(self.view.frame.size.width)
        self.donationScrollView.contentSize = CGSize(width: self.view.frame.size.width * CGFloat(cardViewArray.count), height: self.donationScrollView.bounds.size.height)
        self.donationScrollView.addSubview(cardView)
    }
    
    func findCard(withID id: String) -> Int {
        for (index, card) in cardViewArray.enumerated() {
            if id == card.donationItemViewID {
                print("Found card with id", id, "index", index)
                return index
            }
        }
        return -1
    }
    
    func createCardView(card: Card, draw: Bool) -> DonationItemView? {
        let cardView = Bundle.main.loadNibNamed("DonationItemView", owner: self, options: nil)?.first as! DonationItemView
        
        cardView.layer.cornerRadius = 10
        
        cardView.donationItemViewID = card.id
        
        cardView.donationImageView.image = card.image
        
        cardView.donationTitle.text = card.title
        cardView.donationDescription.text = card.descriptionText
        cardView.donationPeopleDonatedText.text = "\(card.numberOfDonatedPeople ?? 0) people already donated \(card.donatedMoney ?? 0) AZN"
        
        var buttonText = "Be next!"
        if let number = card.numberOfDonatedPeople {
            if number == 0 {
                buttonText = "Be first!"
            } else if number == 1 {
                buttonText = "Be second people!"
            } else if number == 2 {
                buttonText = "Be 3rd!"
            } else if number < 99 {
                buttonText = "Be \(number + 1)th!"
            }
        }
        
        // Button Donation
        cardView.donationButton.setTitle(buttonText, for: .normal)
        cardView.donationButton.backgroundColor =  UIColor(red:0.38, green:0.28, blue:0.74, alpha:1.00)
        cardView.donationButton.tag = index
        cardView.donationButton.addTarget(self, action: #selector(donateCard(_:)), for: .touchUpInside)
        
        // Clipping
        cardView.clipsToBounds = true
        
        // Size
        cardView.frame.size.width = self.donationScrollView.frame.size.width - 20
        cardView.frame.size.height = self.donationScrollView.bounds.height
        
        cardView.donationButton.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.donationButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor).isActive = true
        cardView.donationButton.centerYAnchor.constraint(equalTo: cardView.donationPeopleDonatedText.bottomAnchor, constant: 25).isActive = true
        cardView.donationButton.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.3).isActive = true
        cardView.donationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        cardView.donationButton.layer.cornerRadius = 15
        
        
        let pageWidth = donationScrollView.frame.size.width
        let page = Int(floor((donationScrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        var frame = donationScrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        frame = frame.insetBy(dx: 5.0, dy: 0.0)
        
        cardView.frame = frame
        donationScrollView.addSubview(cardView)
        
        cardViewArray.append(cardView)
        
        if draw {
            self.load()
        }
        return cardView
    }
    
    func load() {
        let cardView = cardViewArray[index]
        
        // Position
        cardView.frame.origin.x = CGFloat(index) * CGFloat(donationScrollView.frame.size.width)
        
        print("Layer Size of card", cardView.layer.bounds.size)
        print("Layer Bounds of card", cardView.layer.bounds)
        print("Bounds of card", cardView.bounds)
        print("Bounds size of card", cardView.bounds.size)
        
        self.donationScrollView.contentSize = CGSize(width: donationScrollView.frame.size.width * CGFloat(cardViewArray.count), height: self.donationScrollView.bounds.size.height)
        
        self.donationPageControl.isHidden = false
        
        self.donationScrollView.addSubview(cardView)
        print("Added to Scroll View  at: ", cardView.layer.position)
        self.donationPageControl.numberOfPages = cardViewArray.count
        
        // Increase index
        index = index + 1
    }
    
    var ref: FIRDatabaseReference!
    
    func donateCard(_ sender: UIButton) {
        popUpView.isHidden = false
        
        print("Sender Tag is",sender.tag)
        donationTitle.text = cardViewArray[sender.tag].donationTitle.text! + "?"
        grayBackground.isHidden = false
    }
    
    //    func donateCard(_ sender: UIButton, amount: Int) {
    //        guard let idOptional = cardViewArray[sender.tag].donationItemViewID else { print("Problem with id from donateCard()"); return }
    //        print("The user pressed donation to card ID:", idOptional)
    //
    //        ref = FIRDatabase.database().reference().child("Donations")
    //
    //        // Download Values
    //        ref.child(idOptional).observeSingleEvent(of: .value, with: { (snapshot) in
    //            if let value = snapshot.value as? NSDictionary {
    //                print(value)
    //                let downloadedMoneyOptional = value["donatedMoney"] as? Double ?? -1
    //                let downloadedPeopleOptional = value["numberOfDonatedPeople"] as? Int ?? -1
    //
    //                // Update Values
    //                self.ref.child(idOptional).updateChildValues(["donatedMoney": /*amount*/ 5 + downloadedMoneyOptional], withCompletionBlock: { (error, ref) in
    //                    if error != nil {
    //                        print("Some problem with donation from database")
    //                        return
    //                    }
    //                    ref.updateChildValues(["numberOfDonatedPeople": downloadedPeopleOptional + 1])
    //                    print("Donated", amount, "for", idOptional, "Successfully")
    //                    self.redrawAll()
    //                })
    //            }
    //        })
    //    }
    
    @IBOutlet weak var constraintPopup: NSLayoutConstraint!
    
    @IBAction func donationPressed(_ sender: Any) {
        nameLabel.text = currentUser.name
        
        popUpView.isHidden = true
        thankYouPopup.isHidden = false
        grayBackground.isHidden = false
        
        popUpView.endEditing(true)
    }
    
    @IBAction func closePopup(_ sender: Any) {
        popUpView.isHidden = true
        grayBackground.isHidden = true
        popUpView.endEditing(true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        //        print("Content Offset x:", scrollView.contentOffset.x, "frame size width:",scrollView.frame.size.width)
        donationPageControl.currentPage = Int(page)
    }
    
    @IBAction func closeThankYouPopup(_ sender: Any) {
        thankYouPopup.isHidden = true
        grayBackground.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        self.view.insertSubview(grayBackground, belowSubview: popUpView)
    }
    
}


