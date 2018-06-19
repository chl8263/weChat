//
//  ViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 5..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class ViewController: UIViewController {
    
    var remoteConfig : RemoteConfig!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        remoteConfig = RemoteConfig.remoteConfig()
        let remoteConfigSettings = RemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings
        remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
        
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(0)){ (status, error ) -> Void in
            
            if status == .success{
                print("config fetch!")
                self.remoteConfig.activateFetched()
            }else {
                print("Configure not fetchd")
                
                
            }
            self.displayWelcome()
        }
        
    }
    
    func displayWelcome(){
        let color = remoteConfig["splash_background"].stringValue
        
        let caps = remoteConfig["splash_message_caps"].boolValue
        
        let message = remoteConfig["splash_message"].stringValue
        
        if(caps == true){
            
            let alert = UIAlertController(title : "warning" , message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title:"ok" , style : UIAlertActionStyle.default , handler : {(action) in
                //exit(0)
            }))
            
            self.present(alert, animated: true , completion:  nil)
        }else {
            let loginView = self.storyboard?.instantiateViewController(withIdentifier : "LoginViewController") as! LoginViewController
            
            Thread.sleep(forTimeInterval: 1)
            
            self.present(loginView, animated:false , completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

