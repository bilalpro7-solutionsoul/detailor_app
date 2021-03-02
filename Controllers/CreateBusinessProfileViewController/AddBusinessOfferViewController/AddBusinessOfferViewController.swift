//
//  AddBusinessOfferViewController.swift
//  DailerApp
//
//  Created by Muhammad Bilal on 10/03/2020.
//  Copyright © 2020 Solution Soul. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import SVProgressHUD

class AddBusinessOfferViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerLinkTF: UITextField!
    @IBOutlet weak var offerNameTF: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    var imageUploadURL = ""
    
    var isEdit = false
    var offerItem = OffersStructure(imageUrl: " ", key: " ", link: " ", name: " ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit{
            self.offerImage.kf.setImage(with: URL(string: offerItem.imageUrl ),placeholder: UIImage(named: "camera (2)"))
            self.imageUploadURL = offerItem.imageUrl
            offerNameTF.text = offerItem.name
            offerLinkTF.text = offerItem.link
            
        }
        
        
        self.offerImage.layer.cornerRadius = 8
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.showAnimate()
        imagePicker.delegate = self
    }
    
    @IBAction func addOfferButtonAction(_ sender: Any) {
        var userID = ""
        if let userid = defaults.string(forKey: userData.id) {
            print(userid) // Another String Value
            userID = userid
        }
        
        
        if isEdit{
            
            if imageUploadURL != "" {
                if offerLinkTF.text != "" {
                    if offerNameTF.text != "" {
                        let ref = Database.database().reference().child("listing").child("business").child(userID).child("offers")
                        //let key = ref.childByAutoId().key
                        let data = ["imageUrl":"\(imageUploadURL)","key":"\(offerItem.key)","link":"\(self.offerLinkTF.text!)","name":"\(self.offerNameTF.text!)"] as [String : Any]
                        ref.child(offerItem.key).setValue(data)
                        removeAnimate()
                    }else{
                        showAlert(message: "Please Enter Name")
                    }
                }else{
                    showAlert(message: "Please Enter Link")
                }
            }else{
                showAlert(message: "Please Upload Image!")
            }

            
        }
        else{
        
        if imageUploadURL != "" {
            if offerLinkTF.text != "" {
                if offerNameTF.text != "" {
                    let ref = Database.database().reference().child("listing").child("business").child(userID).child("offers")
                    let key = ref.childByAutoId().key
                    let data = ["imageUrl":"\(imageUploadURL)","key":"\(key!)","link":"\(self.offerLinkTF.text!)","name":"\(self.offerNameTF.text!)"] as [String : Any]
                    ref.child(key!).setValue(data)
                    removeAnimate()
                }else{
                    showAlert(message: "Please Enter Name")
                }
            }else{
                showAlert(message: "Please Enter Link")
            }
        }else{
            showAlert(message: "Please Upload Image!")
        }
        }
    }
    @IBAction func offerImageButtonAction(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker,animated: true,completion: nil)
    }
    @IBAction func crossButtonAction(_ sender: Any) {
        self.removeAnimate()
    }
    // Show Animation when present Controller
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert,animated: true,completion: nil)
    }
}

extension AddBusinessOfferViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            self.offerImage.image = image
            let imgsd = resizeImageWithAspect(image: image, scaledToMaxWidth: 300, maxHeight: 300)
            //self.offerImage.image = imgsd
            SVProgressHUD.show(withStatus: "Updating")
            let img = imgsd
            var fileData = Data()
            fileData = (img!.pngData())!
            let ky = Database.database().reference().childByAutoId().key
            let storageRef = Storage.storage().reference().child("images/\(ky!)")//storage.reference().child("images")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageRef.putData(fileData, metadata: metadata) { (metadata, error) in
                if error == nil {
                    print("Successfully uploaded")
                    var dwnUrl = ""
                    storageRef.downloadURL(completion: { (url, err) in
                        dwnUrl = "\(url!)"
                        print(url!)
                        
                        self.imageUploadURL = dwnUrl
                        SVProgressHUD.dismiss()
                    })
                    
                    print(dwnUrl)
                    
                    
                    
                }else{
                    let alert = UIAlertController(title: "Warning", message: "Error While Upload Information", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert,animated: true,completion: nil)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
            
        }
    }
}
