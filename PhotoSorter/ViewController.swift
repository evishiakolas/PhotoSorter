//
//  ViewController.swift
//  PhotoSorter
//
//  Created by Evi Shiakolas on 7/14/15.
//  Copyright (c) 2015 EviAndFritz. All rights reserved.
//

import UIKit
import Parse
import Photos
import AssetsLibrary

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        self.fetchPhotos()
            
            let iphonePhotos = PFObject(className: "iphonePhotos")
            iphonePhotos["photoNames"] = self.images
            iphonePhotos.saveInBackgroundWithBlock{
                (success: Bool!, error: NSError!) -> Void in
                println("object has been saved")
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
    
   
        var images:NSMutableArray! // <-- Array to hold the fetched images
        var totalImageCountNeeded:Int! // <-- The number of images to fetch
        
        func fetchPhotos () {
            images = NSMutableArray()
            totalImageCountNeeded = 3
            self.fetchPhotoAtIndexFromEnd(0)
            
            println( "toString(images.dynamicType) -> \(images.dynamicType)")
            
        }
    
//    func convertPhotoNamesToJSON () {
//        
//        
//        UIImage *my_image; //your image handle
//        NSData *data_of_my_image = UIImagePNGRepresentation(my_image);
//        NSString *base64StringOf_my_image = [data_of_my_image convertToBase64String];
//        
//        //now you can add it to your dictionary
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        [dict setObject:base64StringOf_my_image forKey:@"image"];
//        
//        if ([NSJSONSerialization isValidJSONObject:dict]) //perform a check
//        {
//            NSLog(@"valid object for JSON");
//            NSError *error = nil;
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
//            
//            
//            if (error!=nil) {
//                NSLog(@"Error creating JSON Data = %@",error);
//            }
//            else{
//                NSLog(@"JSON Data created successfully.");
//            }
//        }
//        else{
//            NSLog(@"not a valid object for JSON");
//        }
//        
//        
//    }
    
    // Repeatedly call the following method while incrementing
        // the index until all the photos are fetched
        func fetchPhotoAtIndexFromEnd(index:Int) {
            
            let imgManager = PHImageManager.defaultManager()
            
            // Note that if the request is not set to synchronous
            // the requestImageForAsset will return both the image
            // and thumbnail; by setting synchronous to true it
            // will return just the thumbnail
            var requestOptions = PHImageRequestOptions()
            requestOptions.synchronous = true
            
            // Sort the images by creation date
            var fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
            
            if let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
                
                // If the fetch result isn't empty,
                // proceed with the image request
                if fetchResult.count > 0 {
                    // Perform the image request
                    imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                        
                        // Add the returned image to your array
                        self.images.addObject(image)
                        
                        // If you haven't already reached the first
                        // index of the fetch result and if you haven't
                        // already stored all of the images you need,
                        // perform the fetch request again with an
                        // incremented index
                        if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                            self.fetchPhotoAtIndexFromEnd(index + 1)
                        } else {
                            // Else you have completed creating your array
                            println("Completed array: \(self.images)")
                        }
                    })
                }
            }
}
   

}

