import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseService{
    let db = Firestore.firestore()
    let callback : UserCallBack?
    let collectionName = "users"
    
    func writeData(user : User){
        do{
      try  db.collection(collectionName).document(user.userEmail).setData(from: user)
        } catch {
            
        }
    }
    
    func addContacts(user: User, contactId:String){
        db.collection(collectionName)
            .document(user.userEmail).updateData(["contacts": FieldValue.arrayUnion([contactId])])

    }
    
     func getUser(userEmail: String){
        let docRef = db.collection(collectionName).document(userEmail)
        var warningMessage: String!
        docRef.getDocument() { (document, error ) in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    self.callback?.onFinish(user: user)
                } else {
                    warningMessage = "\(String(describing: error))"
                    Helper.show(message:warningMessage)
                }
            case .failure(let error):
                warningMessage = error.localizedDescription
                Helper.show(message:warningMessage)
            }
        }
    }
    
   func setUser(user: User) {
        do{
            try db.collection(collectionName)
                .document(user.userEmail)
                .setData(from: user)
            callback?.onFinish(user: user)
        }catch let error {
            Helper.show(message: error.localizedDescription)
        }
    }
    
    func deleteContact(user: User, contactId:String){
        db.collection(collectionName)
             .document(user.userEmail).updateData(["contacts": FieldValue.arrayRemove([contactId])])
    }
    
    init() {
        self.callback = nil
    }
    
        init(callback : UserCallBack){
            self.callback = callback
    }
}

