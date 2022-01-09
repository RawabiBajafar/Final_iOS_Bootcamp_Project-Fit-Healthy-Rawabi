//
//  SignUpViewController.swift
//  CustomLoginDemo
//
//  Created by Christopher Ching on 2019-07-22.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  
  @IBOutlet weak var lastNameTextField: UITextField!
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  @IBOutlet var Confirm: MainTF!
  
  
  @IBOutlet weak var signUpButton: UIButton!
  
  @IBOutlet weak var errorLabel: UILabel!
  
  @IBOutlet var weight: UITextField!
  
  @IBOutlet var Height: UITextField!
  
  @IBOutlet var DateOfBirth: UITextField!
  
  @IBOutlet var confirmTextField: MainTF!
  override func viewDidLoad() {
    super.viewDidLoad()
    self.Keyboard()
    firstNameTextField.text = "rawabi"
    lastNameTextField.text = "Ahmed"
    emailTextField.text = "test1238@gmail.com"
    passwordTextField.text = "123_$Ff3"
    weight.text = "55"
    Height.text = "156"
    DateOfBirth.text = "2-3-2020"
    confirmTextField.text = "123_$Ff3"
    // Do any additional setup after loading the view.
    setUpElements()
    
    navigationItem.backButtonTitle = ""
    overrideUserInterfaceStyle = .light
    navigationItem.setHidesBackButton(true, animated: true)
  }
  
  
  
  
  
  
  
  func setUpElements() {
    
    // Hide the error label
    errorLabel.alpha = 0
    
    // Style the elements
    Utilities.styleTextField(firstNameTextField)
    Utilities.styleTextField(lastNameTextField)
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleTextField(Confirm)
    Utilities.styleFilledButton(signUpButton)
    Utilities.styleTextField(weight)
    Utilities.styleTextField(Height)
    Utilities.styleTextField(DateOfBirth)
    
  }
  
  // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns the error message
  func validateFields() -> String? {
    
    // Check that all fields are filled in
    if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        Confirm.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        weight.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        Height.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        DateOfBirth.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    {
      
      return "Please fill in all fields."
    }
    
    // Check if the password is secure
    let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if Utilities.isPasswordValid(cleanedPassword) == false {
      // Password isn't secure enough
      return "Please make sure your password is at least 8 characters, contains a special character and a number."
    }
    
    return nil
  }
  
  
  @IBAction func signUpTapped(_ sender: Any) {
    
    // Validate the fields
    let error = validateFields()
    
    if error != nil {
      
      //      let vc = storyboard?.instantiateViewController(withIdentifier: "Lifestyle")
      //      if let viewController = vc {
      //        navigationController?.pushViewController(viewController, animated: true)
      //      }
      // There's something wrong with the fields, show error message
      showError(error!)
    }
    else {
      
      // Create cleaned versions of the data
      let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let Confirm = Confirm.text?.trimmingCharacters(in: .whitespacesAndNewlines)
      let weight = weight.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let height = Height.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let age = DateOfBirth.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let DateOfBirth = DateOfBirth.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      
      // Create the user
      Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
        
        //Check for errors
        if err != nil {
          
          // There was an error creating the user
          self.showError("Error creating user")
        }
        else {
          print(result)
          // User was created successfully, now store the first name and last name
          let db = Firestore.firestore()
          let id = result?.user.uid
          db.collection("users").document(id!).setData(["firstname":firstName,
              "lastname":lastName,
              "weight":weight,
              "height":height,
              "DateOfBirth":DateOfBirth,
              "uid":result!.user.uid ]) { (error) in
            
            if error != nil {
              // Show error message
              self.showError("Error saving user data")
            }
            else{
              self.transitionToHome()
            }
          }
//          db.collection("users").addDocument(data: ["firstname":firstName,
//                                                    "lastname":lastName,
//                                                    // "password":password,
//                                                    // "Confirm" : Confirm,
//                                                    //"email" : email,
//                                                    "weight":weight,
//                                                    "height":height,
//                                                    "DateOfBirth":DateOfBirth,
//                                                    "uid": result!.user.uid ]) { (error) in
//
//            if error != nil {
//              // Show error message
//              self.showError("Error saving user data")
//            }
//          }
          // Transition to the home screen
//          self.transitionToHome()
          
        }
        
      }
      
      
      
    }
  }
  
  func showError(_ message:String) {
    
    errorLabel.text = message
    errorLabel.alpha = 1
  }
  
  func transitionToHome() {
    
    //    let homeViewController = storyboard?.instantiateViewController(identifier: Constants.StoryboardSignUp.homeViewController) as? SignUpSelection
    //
    //
    //    view.window?.rootViewController = homeViewController
    //    view.window?.makeKeyAndVisible()
    
    let vc2 = storyboard?.instantiateViewController(withIdentifier: "HomeSignUp")
    
    if let viewcontrollerr = vc2 {
      
      
      present(viewcontrollerr, animated: true)
      
    }
  }
  
}
