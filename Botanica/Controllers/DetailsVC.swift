//
//  DetailsVC.swift
//  Botanica
//
//  Created by yekta on 3.02.2024.
//

import UIKit
import CoreData
class DetailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var locationTxtFld: UITextField!
    @IBOutlet weak var yearTxtFld: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var chosenPlantName = ""
    var chosenPlantID:UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Rounded
        let namePlaceholder = "Name"
            nameTxtFld.attributedPlaceholder = NSAttributedString(string: namePlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let locationPlaceholder = "Location"
            locationTxtFld.attributedPlaceholder = NSAttributedString(string: locationPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let yearPlaceholder = "Year"
            yearTxtFld.attributedPlaceholder = NSAttributedString(string: yearPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        nameTxtFld.textColor = UIColor.white
        locationTxtFld.textColor = UIColor.white
        yearTxtFld.textColor = UIColor.white
        saveButton.layer.cornerRadius = 20
        saveButton.layer.masksToBounds = true
        
        //Recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        selectedImage.addGestureRecognizer(imageTapRecognizer)
        
        selectedImage.isUserInteractionEnabled=true
        
        if chosenPlantName != "" {
            saveButton.isHidden = true
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Plants")
            
            let IDString = chosenPlantID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", IDString!)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            
            
            do{
               let results =  try context.fetch(fetchRequest)
                if results.count>0{
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String{
                            nameTxtFld.text = name
                        }
                        if let location = result.value(forKey: "location") as? String{
                            locationTxtFld.text = location
                        }
                        if let year = result.value(forKey: "year") as? Int{
                            yearTxtFld.text = String(year) 
                        }
                        if let imageData = result.value(forKey: "image") as? Data{
                            let image = UIImage(data: imageData)
                            selectedImage.image = image
                        }
                    }
                }
            }
            catch{
                print("Error")
            }
            
        }
        else{
            saveButton.isHidden = false
            saveButton.isEnabled = false
        }
        
    }
    
    @objc func selectImage (){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newHerb = NSEntityDescription.insertNewObject(forEntityName: "Plants", into: context)
        
        //Attributes
        newHerb.setValue(nameTxtFld.text ?? "", forKey: "name")
        newHerb.setValue(locationTxtFld.text ?? "", forKey: "location")
        if let year = Int(yearTxtFld.text!){
            newHerb.setValue(year, forKey: "year")
        }
        newHerb.setValue(UUID(), forKey: "id")
        let data = selectedImage.image?.jpegData(compressionQuality: 0.5)
        newHerb.setValue(data, forKey: "image")
        do{
            try context.save()
            print("success")
        } catch{
            print("Bir hata meydana geldi.")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        //islem bittikten sonra bir onceki ekrana gecis yapmayi saglar
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
