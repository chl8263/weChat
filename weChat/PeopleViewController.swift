//
//  PeopleViewController.swift
//  weChat
//
//  Created by admin2 on 2018. 6. 6..
//  Copyright © 2018년 admin2. All rights reserved.
//
import UIKit
import SnapKit
import Firebase

class PeopleViewController :UIViewController,UITableViewDelegate ,UITableViewDataSource{
    
    var array : [UserModel] = []
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBar = UIView()
        self.view.addSubview(statusBar)
        
        statusBar.snp.makeConstraints{(m) in
            
            m.right.top.left.equalTo(self.view)
            m.height.equalTo(20)
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PeopleViewTableCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (m) in
            m.top.equalTo(view)
            m.bottom.left.right.equalTo(view)
        }
        
        Database.database().reference().child("users").observe(DataEventType.value, with: {(snapshot)in
            
            self.array.removeAll()
            
            let myuid =  Auth.auth().currentUser?.uid
            
            for child in snapshot.children{
                
                let fchild = child as! DataSnapshot
                var userModel = UserModel()
                
                
                
                //let model = UserModel(snapshot: snapshot)
                let username = fchild.childSnapshot(forPath: "userName").value
                let profileImageUrl = fchild.childSnapshot(forPath: "profileImageUrl").value
                let uid = fchild.childSnapshot(forPath: "uid").value

                print(username)
                userModel.userName = username as! String
                userModel.profileImageUrl = profileImageUrl as! String
                userModel.uid = uid as! String
                //userModel.setValuesForKeys(fchild.value as! [String : Any])
                
                
                if(userModel.uid == myuid){
                    continue
                }
                
                self.array.append(userModel)
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath) as! PeopleViewTableCell
        
        let imageview = cell.imageview
        cell.addSubview(imageview!)
        imageview?.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo(cell).offset(10)
            m.height.width.equalTo(50)
        }
        
        
        URLSession.shared.dataTask(with: URL(string : array[indexPath.row].profileImageUrl! as! String)!){ (data,response,err) in   //fire base http session image url doenload view
            
            DispatchQueue.main.async {
                imageview?.image = UIImage(data: data!)
                imageview?.layer.cornerRadius = (imageview?.frame.size.width)!/2 //image circle
                imageview?.clipsToBounds = true  //image circle
            }
            }.resume()
        
        let label = cell.label!
        
        label.snp.makeConstraints { (m) in
            m.centerY.equalTo(cell)
            m.left.equalTo((imageview?.snp.right)!).offset(20)
            
        }
        label.text = array[indexPath.row].userName as! String
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        
        view?.destinationUid = self.array[indexPath.row].uid
        
        self.navigationController?.pushViewController(view!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
class PeopleViewTableCell : UITableViewCell {
    var imageview : UIImageView! = UIImageView()
    var label : UILabel! = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(imageview)
        self.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
}
