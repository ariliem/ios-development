import UIKit

struct BTSFavorite {
    let imageName: String
    let title: String
    let description: String
}

class ViewController: UIViewController {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songDescriptionLabel: UILabel!
    @IBOutlet weak var shuffleButton: UIButton!

    let favorites: [BTSFavorite] = [
        BTSFavorite(
            imageName: "bts1",
            title: "Spring Day",
            description: "An emotional masterpiece from 'You Never Walk Alone' about longing, warmth, and waiting for friends through a long winter."
        ),
        BTSFavorite(
            imageName: "bts2",
            title: "Black Swan",
            description: "A dramatic orchestral hip-hop track from 'Map of the Soul: 7' exploring an artist's deepest fear of losing passion for music."
        ),
        BTSFavorite(
            imageName: "bts3",
            title: "Blood Sweat & Tears",
            description: "The iconic title track from the 'Wings' album blending moombahton trap with classical art aesthetics and temptation themes."
        ),
        BTSFavorite(
            imageName: "bts4",
            title: "Mikrokosmos",
            description: "A stadium-filling synth-pop anthem celebrating every person as a shining star with their own unique story in the universe."
        ),
        BTSFavorite(
            imageName: "bts5",
            title: "Run BTS",
            description: "A high-energy hip-hop rock banger from the 'Proof' anthology showcasing the group's relentless drive, teamwork, and confidence."
        ),
        BTSFavorite(
            imageName: "bts6",
            title: "FAKE LOVE",
            description: "The dark, powerful lead single from 'Love Yourself: Tear' about realizing that a love where you lose yourself isn't real."
        ),
        BTSFavorite(
            imageName: "bts7",
            title: "Life Goes On",
            description: "A warm acoustic comfort song from the 'BE' album reminding listeners that even when the world stops, life still goes on."
        ),
        BTSFavorite(
            imageName: "bts8",
            title: "Pied Piper",
            description: "A playful yet groovy disco-pop song dedicated directly to ARMY, teasing fans for being completely captivated by the music."
        ),
        BTSFavorite(
            imageName: "bts9",
            title: "Magic Shop",
            description: "A heartfelt fan song produced by Jungkook that invites listeners to open a door in their heart whenever they need comfort."
        ),
        BTSFavorite(
            imageName: "bts10",
            title: "Louder than bombs",
            description: "A haunting, atmospheric track with deep bass and breathtaking falsettos reflecting on the bittersweet weight of global fame."
        )
    ]

    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        displayFavorite(at: currentIndex)
    }

    private func setupAppearance() {
        coverImageView.layer.cornerRadius = 18
        coverImageView.clipsToBounds = true
        shuffleButton.layer.cornerRadius = 14
    }

    private func displayFavorite(at index: Int) {
        guard favorites.indices.contains(index) else { return }
        let item = favorites[index]
        coverImageView.image = UIImage(named: item.imageName)
        songTitleLabel.text = item.title
        songDescriptionLabel.text = item.description
    }

    @IBAction func shuffleButtonTapped(_ sender: UIButton) {
        guard favorites.count > 1 else { return }

        var nextIndex = Int.random(in: 0..<favorites.count)
        while nextIndex == currentIndex {
            nextIndex = Int.random(in: 0..<favorites.count)
        }

        currentIndex = nextIndex
        displayFavorite(at: currentIndex)
    }
}
