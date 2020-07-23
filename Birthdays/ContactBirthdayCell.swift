
import UIKit

class ContactBirthdayCell: UITableViewCell {
  
  @IBOutlet weak var lblFullname: UILabel!
  @IBOutlet weak var lblBirthday: UILabel!
  @IBOutlet weak var imgContactImage: UIImageView!
  @IBOutlet weak var lblEmail: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    imgContactImage.layer.cornerRadius = 25.0
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
}
