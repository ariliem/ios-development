import UIKit

class DetailViewController: UIViewController {

    var item: FavoriteItem?

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        guard let item = item else { return }

        navigationItem.title = item.title

        coverImageView.image = UIImage(named: item.imageName)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        descriptionLabel.text = item.description

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
