//
//  SearchViewController.swift
//  ERF
//
//  Created by Vũ Kiên on 27/07/2016.
//  Copyright © 2016 Kiên Vũ. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var instructorCollectionView: UICollectionView!
    
    var instructors: [Instructor] = [Instructor]()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getInstructor() -> Void {
        //lay du lieu
    }
    
    func configureUI() -> Void {
        self.navigationItem.title = "INSTRUCTOR LIST"
        self.searchBar.backgroundColor = UIColor.clearColor()
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
        instructorCollectionView.backgroundColor = UIColor.whiteColor()
        instructorCollectionView.backgroundView?.backgroundColor = UIColor.whiteColor()
        self.view.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let width = (self.view.frame.width - 25)/2
        layout.itemSize = CGSize(width:  width, height: 3*width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        instructorCollectionView.setCollectionViewLayout(layout, animated: true)
        self.addLeftBarButtonWithImage(UIImage(named: "img-menu")!)
    }
    
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let instructor = instructors[indexPath.row]
        let instructorDetail = self.storyboard?.instantiateViewControllerWithIdentifier("AddorUpdateTeachingRecordViewController") as! AddorUpdateTeachingRecordViewController
        instructorDetail.instructor = instructor
        self.navigationController?.pushViewController(instructorDetail, animated: true)
    }
    
    

}
