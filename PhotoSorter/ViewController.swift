//
//  ViewController.swift
//  PhotoSorter
//
//  Created by Evi Shiakolas on 7/14/15.
//  Copyright (c) 2015 EviAndFritz. All rights reserved.
//

import UIKit
import Parse

import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        let testObject = PFObject(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("Object has been saved.")
            
            self.getPhotoLibraryPhotos(completion: { photos in
                println(photos)
                //Set Images in this block.
            })
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func likePicture(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
    }
    
    func getPhotoLibraryPhotos(completion completionBlock : ([UIImage] -> ()))   {
        let library = ALAssetsLibrary()
        var count = 0
        var photos : [UIImage] = []
        var stopped = false
        
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group,var stop) -> Void in
            
            group?.setAssetsFilter(ALAssetsFilter.allPhotos())
            
            group?.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse, usingBlock: {
                (asset : ALAsset!, index, var stopEnumeration) -> Void in
                
                if (!stopped)
                {
                    if count >= 50
                    {
                        
                        stopEnumeration.memory = ObjCBool(true)
                        stop.memory = ObjCBool(true)
                        completionBlock(photos)
                        stopped = true
                    }
                    else
                    {
//                        // For just the thumbnails use the following line.
//                        let cgImage = asset.thumbnail().takeUnretainedValue()
//                        
                        // Use the following line for the full image.
                        let cgImage = asset.defaultRepresentation().fullScreenImage().takeRetainedValue()
                        
                        if let photo = UIImage(CGImage: cgImage) {
                            photos.append(photo)
                            count += 1
                        }
                    }
                }
                
            })
            
            },failureBlock : { error in
                println(error)
        })
    }
    

}
    
    
   



