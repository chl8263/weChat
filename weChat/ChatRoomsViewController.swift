//
//  ChatRoomsViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//

import UIKit
import Firebase
class ChatRoomsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var uid: String!
    var chatrooms : [ChatModel]! = []
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uid = Auth.auth().currentUser?.uid

        self.getChatroomsList()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatrooms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RowCell", for: indexPath) as! CustomCell
        
        var destinationUid : String?
        
        for item in chatrooms[indexPath.row].users{
            
            if(item.key != self.uid){
                destinationUid = item.key
            }
        }
        
        Database.database().reference().child("users").child(destinationUid!).observeSingleEvent(of: DataEventType.value, with:{
            (datasnap) in
            
            let userModel = UserModel()
            
            let userName = datasnap.childSnapshot(forPath: "userName").value
            let profileImageUrl = datasnap.childSnapshot(forPath: "profileImageUrl").value
            let uid = datasnap.childSnapshot(forPath: "uid").value
            
            userModel.userName = userName as! String
            userModel.profileImageUrl = profileImageUrl as! String
            userModel.uid = uid as! String
            
            cell.label_title.text = userModel.userName
            
            let url = URL(string: (userModel.profileImageUrl)!)
            URLSession.shared.dataTask(with: url!, completionHandler : { (data,response,err) in   //fire base http session image url doenload view
                
                DispatchQueue.main.async {
                    
                    cell.imageView?.image = UIImage(data: data!)
                    
                }
            }).resume()
            
            let lastMessageKey = self.chatrooms[indexPath.row].comments.keys.sorted(){$0>$1}
            cell.label_lastmessage.text = self.chatrooms[indexPath.row].comments[lastMessageKey[0]]?.message
            
        })
        
        
        return cell
    }
    override func viewDidAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    func getChatroomsList(){
        
        Database.database().reference().child("chatrooms").queryOrdered(byChild: "users/"+uid).queryEqual(toValue: true).observeSingleEvent(of: DataEventType.value, with: {(datasnap) in
            
            for item in datasnap.children.allObjects as! [DataSnapshot]{
                self.chatrooms.removeAll()
                if let chatroomdic = item.value as? [String: AnyObject]{
                    let chatModel = ChatModel(JSON : chatroomdic)
                    self.chatrooms.append(chatModel!)
                }
                
            }
            self.tableView.reloadData()
        })
        
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
class CustomCell : UITableViewCell{
    
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var label_title: UILabel!
    @IBOutlet weak var label_lastmessage: UILabel!
    
}
