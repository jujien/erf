//
//  SearchViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit
import RealmSwift
import ReachabilitySwift
import Alamofire

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var instructorCollectionView: UICollectionView!
    @IBOutlet weak var waitIndicatorView: UIActivityIndicatorView!
    
    var instructors: [Instructor] = [Instructor]()
    var reachability : Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.getInstructor()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.closeLeft()
        instructorCollectionView.reloadData()
    }
    
    func getInstructor() -> Void {
        //lay du lieu
        do {
            reachability = try! Reachability.reachabilityForInternetConnection()
        }
        reachability!.whenReachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue(), {
                Alamofire.request(.GET, "https://dataforiliat.herokuapp.com/api/products").validate().responseJSON(completionHandler: { (response) in
                    print(response.result.value)
                    if let json = response.result.value {
                        for object in json as! [AnyObject] {
                            let instructor = object as! [String: AnyObject]
                            let code = "TECH 10"
                            let name = instructor["name"] as! String
                            let phone = instructor["phone"] as! Int
                            let imageUrl = instructor["imageURL"] as! String
                            let cls = (instructor["class"] as! [AnyObject])[0] as! [String: String]
                            let classRole = ClassRole.create(cls["nameClass"]!, roleCode: cls["classRole"]!)
                            let classRoles = List<ClassRole>()
                            classRoles.append(classRole)
                            self.instructors.append(Instructor.create(imageUrl, name: name, code: code, phone: "\(phone)", classRoles: classRoles))
                        }
                        self.instructorCollectionView.reloadData()
                        self.waitIndicatorView.stopAnimating()
                    }
                })
            })
        }
        
        reachability!.whenUnreachable = {
            reachability in
            dispatch_async(dispatch_get_main_queue(), {
                self.instructorCollectionView.reloadData()
                self.waitIndicatorView.stopAnimating()
            })
        }
        try! reachability?.startNotifier()
//        NetworkConfig.shareInstance.getAndParseJson { (data) in
//            let objects = data

//        }
        
    }
    
    //MARK: -configure UI and Layout
    func configureUI() -> Void {
        self.navigationItem.title = "INSTRUCTOR LIST"
        self.waitIndicatorView.hidesWhenStopped = true
        self.waitIndicatorView.activityIndicatorViewStyle = .White
        self.waitIndicatorView.center = instructorCollectionView.center
        self.waitIndicatorView.startAnimating()
        self.navigationController?.navigationBar.translucent = false
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
        self.configureLayout()
    }
    
    func configureLayout() -> Void {
        self.view.layoutIfNeeded()
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return instructors.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InstructorCell", forIndexPath: indexPath) as! InstructorCollectionViewCell
        let instructor = instructors[indexPath.row]
        cell.instructor = instructor
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let instructor = instructors[indexPath.row]
        let instructorDetail = self.storyboard?.instantiateViewControllerWithIdentifier("AddorUpdateTeachingRecordViewController") as! AddorUpdateTeachingRecordViewController
        instructorDetail.instructor = instructor
        self.navigationController?.pushViewController(instructorDetail, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (self.view.frame.width - 25.0)/2.0
        return CGSize(width:  width, height: 3.0*width/2.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
