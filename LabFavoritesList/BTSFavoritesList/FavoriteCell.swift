import UIKit

class FavoriteCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!

    func configure(with item: FavoriteItem) {
        itemImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle

        let sortedStars = starImageViews.sorted { $0.tag < $1.tag }
        for (index, starView) in sortedStars.enumerated() {
            if index < item.rating {
                starView.image = UIImage(systemName: "star.fill")
                starView.tintColor = .systemPurple
            } else {
                starView.image = UIImage(systemName: "star")
                starView.tintColor = .systemGray3
            }
        }
    }
}
