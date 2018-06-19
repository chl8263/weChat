//
//  SignViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import Firebase

class SignViewController: UIViewController ,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    var remoteConfig = RemoteConfig.remoteConfig()

    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var join: UIButton!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var imageview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        passwd.keyboardType = .numberPad
        email.keyboardType = .default
        name.keyboardType = .default
        
         statusBar.backgroundColor = UIColor.green
        
        join.backgroundColor = UIColor.green
        cancel.backgroundColor = UIColor.green
        
        imageview.isUserInteractionEnabled = true
        imageview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(imageficker)))
        
        join.addTarget(self, action: #selector(signupEvent), for: .touchUpInside)
        cancel.addTarget(self, action: #selector(cancelevent), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gesture(_ sender: UITapGestureRecognizer) {
        passwd.resignFirstResponder()
        email.resignFirstResponder()
        name.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageview.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imageficker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func signupEvent(){
        Auth.auth().createUser(withEmail: email.text!, password: passwd.text!){ (user,err)in
            
            let uid = user?.user.uid
            
            let image = UIImageJPEGRepresentation(self.imageview.image!, 0.1)
            
            let storageRef = Storage.storage().reference().child("userImages").child(uid!)
            
            let uploadTask = storageRef.putData(image!, metadata: nil){(metadata,error) in
                
                storageRef.downloadURL(completion: { (url, error) in
                    let imageUrl = url?.absoluteString
                    let values = ["userName":self.name.text!,"profileImageUrl":imageUrl, "uid":Auth.auth().currentUser?.uid]
                    Database.database().reference().child("users").child(uid!).setValue(values, withCompletionBlock: { (err, ref) in
                        if (err != nil){
                            self.cancelevent()
                        }
                    })
                })
                
            }
            
            //.putData(image!, metadata: nil, completion: { (data, err) in
                
                //let imageUrl = data?.downloadURL()?.absoluteString
            //})
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelevent(){
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
