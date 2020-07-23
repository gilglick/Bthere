import UIKit
import Contacts
import ContactsUI
import FirebaseAuth

protocol AddContactViewControllerDelegate {
  func didFetchContacts(_ contacts: [CNContact])
}

class AddContactViewController: UIViewController, UserCallBack {
    func onFinish(user: User) {
//        self.firebaseService.addContacts(user: user, contactId: )
    }

  @IBOutlet weak var txtLastName: UITextField!
    
    var delegate: AddContactViewControllerDelegate!
    var user : User!
    var firebaseService : FirebaseService!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    firebaseService = FirebaseService(callback: self)
    txtLastName.delegate = self
    generateDoneButton()
  }
    
    func generateDoneButton(){
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(AddContactViewController.performDoneItemTap))
        navigationItem.rightBarButtonItem = doneBarButtonItem
    }
}

extension AddContactViewController: CNContactPickerDelegate {
  @IBAction func showContacts(_ sender: AnyObject) {
    let contactPickerViewController = CNContactPickerViewController()
    contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "birthday != nil")
    contactPickerViewController.delegate = self
    contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey]
    present(contactPickerViewController, animated: true, completion: nil)
  }
  
  func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    delegate.didFetchContacts([contact])
    navigationController?.popViewController(animated: true)
  }
}
    // MARK: - UITextFieldDelegate functions
extension AddContactViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    AppDelegate.appDelegate.requestForAccess { (accessGranted) -> Void in
      if accessGranted {
        let predicate = CNContact.predicateForContacts(matchingName: self.txtLastName.text!)
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey] as [Any]
        var contacts = [CNContact]()
        var warningMessage: String!
        let contactsStore = AppDelegate.appDelegate.contactStore
        do {
          contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
          if contacts.count == 0 {
            warningMessage = "No contacts were found matching the given name."
          }
        } catch {
          warningMessage = "Unable to fetch contacts."
        }
        
        if let warningMessage = warningMessage {
          DispatchQueue.main.async {
            Helper.show(message: warningMessage)
          }
        } else {
          DispatchQueue.main.async {
            self.delegate.didFetchContacts(contacts)
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
    return true
  }
    // MARK: - On click done button
  @objc func performDoneItemTap() {
        AppDelegate.appDelegate.requestForAccess { (accessGranted) -> Void in
          if accessGranted {
            let predicate = CNContact.predicateForContacts(matchingName: self.txtLastName.text!)
            let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactBirthdayKey] as [Any]
            var contacts = [CNContact]()
            var warningMessage: String!
            let contactsStore = AppDelegate.appDelegate.contactStore
            do {
              contacts = try contactsStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
              if contacts.count == 0 {
                warningMessage = "No contacts were found matching the given name."
              }
            } catch {
              warningMessage = "Unable to fetch contacts."
            }

            if let warningMessage = warningMessage {
              DispatchQueue.main.async {
                Helper.show(message: warningMessage)
              }
            } else {
              DispatchQueue.main.async {
                self.firebaseService.addContacts(user: self.user, contactId: contacts.first!.identifier)
                self.delegate.didFetchContacts(contacts)
                self.navigationController?.popViewController(animated: true)
              }
            }
          }
        }
    }
}
