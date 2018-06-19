//
//  LoginViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 5..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    @IBOutlet weak var loginbutton: UIButton!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var passwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! Auth.auth().signOut()
        
        
        
        email.keyboardType = .default
        passwd.keyboardType = .numberPad
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        statusBar.backgroundColor = UIColor.green
            
        loginbutton.addTarget(self, action: #selector(loginEvent) , for: .touchUpInside)
        
        Auth.auth().addStateDidChangeListener{(auth , user) in
            
            if (user != nil){
                let view = self.storyboard?.instantiateViewController(withIdentifier: "MainViewTabBarController") as! UITabBarController
                
                self.present(view, animated: true, completion: nil)
            }
        }
        // Do any additional setup after loading the view.
        
        signIn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    }
    
    @IBAction func gesture(_ sender: UITapGestureRecognizer) {
        
        email.resignFirstResponder()
        passwd.resignFirstResponder()
    }
    @objc func loginEvent(){
    
        Auth.auth().signIn(withEmail: email.text!, password: passwd.text!){
            (user, err) in
            
            if(err != nil){
                let alert = UIAlertController(title : "login error" , message: "id passwd invalid", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title:"ok" , style : UIAlertActionStyle.default , handler : nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    @objc func signUp(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "SignViewController") as! SignViewController
        
        self.present(view, animated: true,completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
