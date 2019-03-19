//
//  ObjectBrowserViewCell.swift
//  NetXMS Mobile Console
//
//  Created by Ēriks Jenkēvics on 14/06/2018.
//  Copyright © 2018 Raden Solutions. All rights reserved.
//

import UIKit

class ObjectBrowserViewCell: UITableViewCell
{
   @IBOutlet weak var view: UIView!
   @IBOutlet weak var severityLabel: UILabel!
   @IBOutlet weak var objectName: UILabel!
   @IBOutlet weak var button: UIButton!
   @IBOutlet weak var typeImage: UIImageView!
   var object: AbstractObject?
   var objectBrowser: ObjectBrowserViewController?
   
   override func awakeFromNib()
   {
      super.awakeFromNib()
      view.layer.cornerRadius = 4
      view.layer.shadowColor = UIColor(red:0.03, green:0.08, blue:0.15, alpha:0.15).cgColor
      view.layer.shadowOpacity = 1
      view.layer.shadowOffset = CGSize(width: 0, height: 2)
      view.layer.shadowRadius = 6
   }
   
   override func setSelected(_ selected: Bool, animated: Bool)
   {
      super.setSelected(selected, animated: animated)
      
      // Configure the view for the selected state
   }
   
   @IBAction func onButtonPressed(_ sender: Any)
   {
      if let objectBrowserVC = objectBrowser?.storyboard?.instantiateViewController(withIdentifier: "ObjectBrowserViewController")
      {
         var objects = [AbstractObject]()
         for id in (object?.children)!
         {
            if let child = Connection.sharedInstance?.objectCache[id]
            {
               objects.append(child)
            }
         }
         objectBrowserVC.title = object?.objectName
         (objectBrowserVC as? ObjectBrowserViewController)?.objects = objects
         objectBrowser?.navigationController?.pushViewController(objectBrowserVC, animated: true)
      }
   }
}
