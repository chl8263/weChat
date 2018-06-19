//
//  MainViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var textfield: UITextField!
    
    var userModel: UserModel?
    
    var uid: String?
    var chatRoomUid: String?
    
    var comments : [ChatModel.Comment] = []
    
    public var destinationUid : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = Auth.auth().currentUser?.uid
        
        sendBtn.addTarget(self, action: #selector(createRoom), for: .touchUpInside)
        
        checkCahtRoom()
        
        textfield.keyboardType = .default
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        self.tabBarController?.tabBar.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func gesture(_ sender: UITapGestureRecognizer) {
        textfield.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(self.comments[indexPath.row].uid == uid){
            let view = tableView.dequeueReusableCell(withIdentifier: "Messagecell", for:indexPath) as! MessageCell
            view.message.text = self.comments[indexPath.row].message
            view.message.numberOfLines = 0 // many line
            
            return view
        }else{
            
            let view = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
            
            view.message.text = self.comments[indexPath.row].message
            view.message.numberOfLines = 0 // many line
            
            view.iamgeView?.snp.makeConstraints { (m) in
                m.centerY.equalTo(view)
                m.left.equalTo(view).offset(10)
                m.height.width.equalTo(50)
            }
            
            
            print(self.userModel?.profileImageUrl)
            let url = URL(string: (self.userModel?.profileImageUrl)!)
            URLSession.shared.dataTask(with: url!, completionHandler : { (data,response,err) in   //fire base http session image url doenload view
                
                DispatchQueue.main.async {
                    view.imageView?.image = UIImage(data: data!)
                    view.imageView?.layer.cornerRadius = (view.imageView?.frame.size.width)!/2 //image circle
                    view.imageView?.clipsToBounds = true  //image circle
                }
                }).resume()
            
            return view

        }
        
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @objc func createRoom(){
        let createRoomInfo : Dictionary<String,Any> = [ "users" : [ uid! : true , destinationUid! : true] ]
        
        if(chatRoomUid == nil){
            self.sendBtn.isEnabled = false
            Database.database().reference().child("chatrooms").childByAutoId().setValue(createRoomInfo, withCompletionBlock: { (err, ref) in
                if (err  == nil){
                    self.checkCahtRoom()
                }
            })
            
        }else {
            
            let value : Dictionary<String,Any> = [
                    "uid" : uid!,
                    "message" : textfield.text!
                
            ]
            Database.database().reference().child("chatrooms").child(chatRoomUid!).child("comments").childByAutoId().setValue(value)
        }
        textfield.text = ""
    }
    
    func checkCahtRoom(){
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid!).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: { (datasnap) in
            
            for item in datasnap.children.allObjects as! [DataSnapshot]{
                
                if let chatRoomdic = item.value as? [String: AnyObject]{
                    
                    let chatModel = ChatModel(JSON: chatRoomdic)
                    if(chatModel?.users[self.destinationUid!] == true){
                        self.chatRoomUid = item.key
                        self.sendBtn.isEnabled = true
                        self.getDestinationInfo()
                    }
                    
                }
                
                self.chatRoomUid = item.key
            }
            
        })
    }
    
    func getDestinationInfo(){
        Database.database().reference().child("users").child(self.destinationUid!).observeSingleEvent(of: DataEventType.value, with: { (datasnap) in
            
            self.userModel = UserModel()
            
            let userName = datasnap.childSnapshot(forPath: "userName").value
            let profileImageUrl = datasnap.childSnapshot(forPath: "profileImageUrl").value
            let uid = datasnap.childSnapshot(forPath: "uid").value
            print(userName)
            print(profileImageUrl)
            print(uid)
            self.userModel?.userName = userName as! String
            self.userModel?.profileImageUrl = profileImageUrl as! String
            self.userModel?.uid = uid as! String
            
            self.getMessageList()
        })
    }
    
    func getMessageList(){
        Database.database().reference().child("chatrooms").child(self.chatRoomUid!).child("comments").observe(DataEventType.value, with: { (datasnap) in
            
            self.comments.removeAll()
            
            for item in datasnap.children.allObjects as! [DataSnapshot]{
                let comment = ChatModel.Comment(JSON : item.value as! [String:AnyObject])
                self.comments.append(comment!)
            }
            self.tableView.reloadData()
            DispatchQueue.main.async {
                if(self.comments.count > 0){
                    let indexpath = IndexPath(row: self.comments.count-1, section:0)
                    self.tableView.scrollToRow(at: indexpath, at: .bottom, animated: true)
                }
            }
        })
    
    }


}

class MessageCell : UITableViewCell{
    
    @IBOutlet weak var message: UILabel!
}

class DestinationCell : UITableViewCell{
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var iamgeView: UIImageView!
    
}
