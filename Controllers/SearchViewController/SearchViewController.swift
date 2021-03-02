//
//  SearchViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 25/02/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import Kingfisher
import SVProgressHUD

class SearchViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var searchArray = [String]()
    
    var allBusinessesDataArray = [AllBusinesses]()
    var allBusinessesFilteredDataArray = [AllBusinesses]()
    
    let transition = SlideInTransition()
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchTextField.becomeFirstResponder()
        getAllBusiness()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        searchTextField?.addTarget(self, action: #selector(searchRecords(_ :)), for: .editingChanged)
        
        transition.dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisFunc)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeLeft.direction = .left
        self.transition.dimmingView.addGestureRecognizer(swipeLeft)
        
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 200.0, height: collectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 0.8
        floawLayout.sideItemAlpha = 1.0
        floawLayout.spacingMode = .fixed(spacing: 45.0) // Space btw cells 5.0 original
        collectionView.collectionViewLayout = floawLayout
    }
    
    @IBAction func goButtonAction(_ sender: Any) {
        self.searchTextField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        for h in 0...self.allBusinessesDataArray.count-1{
            let y = self.allBusinessesDataArray[h]
            // ================ Append Key words =====================
//            let keywordArr = y.keywords.split(separator: ",")
//            for keyword in keywordArr{
//                self.searchArray.append("\(keyword)")
//            }
            // =======================================================
            self.searchArray.append(y.name)
        }
        self.allBusinessesFilteredDataArray.removeAll()
        for h in 0...self.allBusinessesDataArray.count-1{
            let y = self.allBusinessesDataArray[h]
            self.allBusinessesFilteredDataArray.append(y)
        }
        //self.friendsListSearchedData = self.friendsListData
        self.collectionView.reloadData()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField?.text?.count != 0 {
            self.searchArray.removeAll()
            for arrw in self.allBusinessesDataArray{
                // ================ Append Key words =====================
//                let keywordArr = arrw.keywords.split(separator: ",")
//                for keyword in keywordArr{
//                    self.searchArray.append("\(keyword)")
//                }
                // =======================================================
                let arr = arrw.name
                if let nameToSearch = textField.text{
                    let range = arr.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.searchArray.append(arr)
                    }
                }
                print(self.searchArray)
            }
            self.allBusinessesFilteredDataArray.removeAll()
            var t = 0
            for u in 0...self.allBusinessesDataArray.count-1{
                let g = self.allBusinessesDataArray[u]
                if searchArray.count > t {
                    
//                    let gkeyArr = g.keywords.split(separator: ",")
//                    for item in gkeyArr{
//                        if searchArray[t] == item {
//                            self.allBusinessesFilteredDataArray.append(g)
//                            t += 1
//                            break
//                        }
//                    }
                    
                    if g.name == searchArray[t]{
                        self.allBusinessesFilteredDataArray.append(g)
                        t += 1
                    }
                }
                
            }
        }else{
            for h in 0...self.allBusinessesDataArray.count-1{
                
                let y = self.allBusinessesDataArray[h]
                // ================ Append Key words =====================
//                let keywordArr = y.keywords.split(separator: ",")
//                for keyword in keywordArr{
//                    self.searchArray.append("\(keyword)")
//                }
                // =======================================================
                self.searchArray.append(y.name)
            }
            self.allBusinessesFilteredDataArray.removeAll()
            for h in 0...self.allBusinessesDataArray.count-1{
                let y = self.allBusinessesDataArray[h]
                self.allBusinessesFilteredDataArray.append(y)
            }
            //self.friendsListSearchedData = self.friendsListData
        }
        self.collectionView.reloadData()
        return true
    }
    @objc func searchRecords(_ textField:UITextField){
        self.searchArray.removeAll()
        if searchTextField?.text?.count != 0 {
            self.searchArray.removeAll()
            for arrw in self.allBusinessesDataArray{
                // ================ Append Key words =====================
//                let keywordArr = arrw.keywords.split(separator: ",")
//                for keyword in keywordArr{
//                    self.searchArray.append("\(keyword)")
//                }
                // =======================================================
                let arr = arrw.name
                if let nameToSearch = textField.text{
                    let range = arr.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                    if range != nil {
                        self.searchArray.append(arr)
                    }
                }
                print(self.searchArray)
            }
            self.allBusinessesFilteredDataArray.removeAll()
            var t = 0
            for u in 0...self.allBusinessesDataArray.count-1{
                let g = self.allBusinessesDataArray[u]
                if searchArray.count > t {
                    
//                    let gkeyArr = g.keywords.split(separator: ",")
//                    for item in gkeyArr{
//                        if searchArray[t] == item {
//                            self.allBusinessesFilteredDataArray.append(g)
//                            t += 1
//                            break
//                        }
//                    }
                    
                    if g.name == searchArray[t]{
                        self.allBusinessesFilteredDataArray.append(g)
                        t += 1
                    }
                }
                
            }
        }else{
            for h in 0...self.allBusinessesDataArray.count-1{
                let y = self.allBusinessesDataArray[h]
                // ================ Append Key words =====================
//                let keywordArr = y.keywords.split(separator: ",")
//                for keyword in keywordArr{
//                    self.searchArray.append("\(keyword)")
//                }
                // =======================================================
                self.searchArray.append(y.name)
            }
            self.allBusinessesFilteredDataArray.removeAll()
            for h in 0...self.allBusinessesDataArray.count-1{
                let y = self.allBusinessesDataArray[h]
                self.allBusinessesFilteredDataArray.append(y)
            }
            //self.friendsListSearchedData = self.friendsListData
        }
        self.collectionView.reloadData()
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizer.Direction.left {
            print("Swipe Left")
            dismiss(animated: true, completion: nil)
            //swipeDirectionLabel.text = "Swiped Right"
        }
        
    }
    
    @objc func dismisFunc(){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func barButtonAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.transitioningDelegate = self
        present(vc,animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
    fileprivate var currentPage: Int = 0 {
        didSet {
            print("page at centre = \(currentPage)")
        }
    }
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        return pageSize
    }
    func getAllBusiness(){
        
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("all_businesses")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                self.allBusinessesDataArray.removeAll()
                self.allBusinessesFilteredDataArray.removeAll()
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    let image = obj?["image"] as? String
                    let key = obj?["key"] as! String
                    let keywords = obj?["keywords"] as! String
                    let name = obj?["name"] as! String
                    let rating = obj?["rating"] as! Int
                    let userId = obj?["userId"] as! String
                     let phone = obj?["phoneNo"] as? String
                    
                    let businessData = AllBusinesses(image: image ?? "", key: key, keywords: keywords, name: name, rating: rating, userId: userId, phoneNo: phone ?? "")
                    
                    self.allBusinessesDataArray.append(businessData)
                    self.allBusinessesFilteredDataArray.append(businessData)
                    
                }
                SVProgressHUD.dismiss()
                self.collectionView.reloadData()
                
            }
        }
        
    }
}

extension SearchViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allBusinessesFilteredDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as! SearchDetailViewController
        let item = self.allBusinessesFilteredDataArray[indexPath.row]
        vc.businessUserID = item.userId
        vc.isBusinessProfile = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
        let item = self.allBusinessesFilteredDataArray[indexPath.row]
        
        cell.businessNameLabel.text = item.name
        cell.businessRating.rating = Double(item.rating)
        cell.businessImage.kf.setImage(with: URL(string: item.image),placeholder: UIImage(named: ""))
        cell.businessImage.layer.cornerRadius = 8
        
        SVProgressHUD.show(withStatus: "Loading")
        let ref = Database.database().reference().child("listing").child("business").child(item.userId).child("stores")
        ref.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount>0{
                var count = 0
                for data in snapshot.children.allObjects as! [DataSnapshot]{
                    let obj = data.value as? [String: Any]
                    
                    if count == 0 {
                        let lat = obj?["lat"] as? String
                        let lon = obj?["lon"] as? String
                        
                        count += 1
                        
                        let marker = GMSMarker()
                        marker.position = CLLocationCoordinate2D(latitude: lat?.toDouble() ?? 0.0, longitude: lon?.toDouble() ?? 0.0)
                        //let startingPoint = CLLocationCoordinate2D(latitude: lon?.toDouble() ?? 0.0, longitude: lon?.toDouble() ?? 0.0)
                        self.mapView.camera = GMSCameraPosition(latitude: lat?.toDouble() ?? 0.0, longitude: lon?.toDouble() ?? 0.0, zoom: 12)
                        //self.mapView.animate(to: GMSCameraPosition(latitude: startingPoint.latitude, longitude: startingPoint.longitude, zoom: 12))
                        marker.map = self.mapView
                    }
                }
                SVProgressHUD.dismiss()
            }
            SVProgressHUD.dismiss()
        }
        
        return cell
    }
}

extension SearchViewController:UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
//extension SearchViewController:UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let size = self.collectionView.frame.size
//        return CGSize(width: size.width, height: size.height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0.0
//    }
//}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
