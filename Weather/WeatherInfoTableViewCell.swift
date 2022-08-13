import UIKit

class WeatherInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var weatherInfoView: UIView!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    func setupUI() {
        weatherInfoView.viewSetupUI()
        weatherInfoLabel.fontSetupUI()
    }
}
