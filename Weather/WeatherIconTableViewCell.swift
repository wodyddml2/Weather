import UIKit

class WeatherIconTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherIconImageBackgroundView: UIView!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var greetingView: UIView!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        weatherIconImageBackgroundView.viewSetupUI()
        greetingView.viewSetupUI()
        
        greetingLabel.fontSetupUI()
    }
    
}

extension UIView {
    func viewSetupUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
    }
}

extension UILabel {
    func fontSetupUI() {
        self.font = .boldSystemFont(ofSize: 17)
    }
}
