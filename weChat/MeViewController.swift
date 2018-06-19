//
//  MeViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import Firebase

class MeViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var uid: UILabel!
    
    var myuid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myuid = Auth.auth().currentUser?.uid
        uid.text = self.myuid
        Database.database().reference().child("users").child(myuid!).observeSingleEvent(of:DataEventType.value, with:{
            (datasnap) in
            
            let myname = datasnap.childSnapshot(forPath:"userName").value
            let profileImageUrl = datasnap.childSnapshot(forPath:"profileImageUrl").value
            
            self.name.text = myname as? String
            
            let url = URL(string: profileImageUrl! as! String)
            URLSession.shared.dataTask(with: url!, completionHandler : { (data,response,err) in   //fire base http session image url doenload view
                
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                    
                }
            }).resume()
        })
        

        // Do any additional setup after loading the view.
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
