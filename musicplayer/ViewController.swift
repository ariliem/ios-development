import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var coverimageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playpauseButton: UIButton!
    

    let tracks = TrackLibrary.tracks
    var currentIndex = 0
    var audioPlayer: AVAudioPlayer?
    var isPlaying = false {
        didSet {
            updatePlayPauseButtonIcon()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTrack(at: currentIndex)
    }


    func setupUI() {
        coverimageview.layer.cornerRadius = 12
        coverimageview.clipsToBounds = true
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        artistLabel.font = UIFont.systemFont(ofSize: 16)
        artistLabel.textColor = .secondaryLabel
    }

    func updateUI() {
        let currentTrack = tracks[currentIndex]
        titleLabel.text = currentTrack.title
        artistLabel.text = currentTrack.artist
        coverimageview.image = UIImage(named: currentTrack.coverImageName)
    }


    func updatePlayPauseButtonIcon() {
        let imageName = isPlaying ? "pause.fill" : "play.fill"
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: config)
        playpauseButton.setImage(image, for: .normal)
    }


    func loadTrack(at index: Int) {
        let track = tracks[index]
        updateUI()
        
        guard let url = Bundle.main.url(forResource: track.fileName, withExtension: track.fileExtension) else {
            print("Ошибка: Аудиофайл не найден в бандле: \(track.fileName).\(track.fileExtension)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            if isPlaying {
                audioPlayer?.play()
            }
        } catch {
            print("Ошибка инициализации AVAudioPlayer: \(error.localizedDescription)")
        }
    }



    @IBAction func previous(_ sender: UIButton) {
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = tracks.count - 1
        }
        loadTrack(at: currentIndex)
        if isPlaying {
            audioPlayer?.play()
        }
    }

    @IBAction func playpausee(_ sender: Any) {
        if isPlaying {
            audioPlayer?.pause()
            isPlaying = false
        } else {
            audioPlayer?.play()
            isPlaying = true
        }
    }

    @IBAction func nextTapped(_ sender: UIButton) {
        currentIndex += 1
        if currentIndex >= tracks.count {
            currentIndex = 0 
        }
        loadTrack(at: currentIndex)
        if isPlaying {
            audioPlayer?.play()
        }
    }


    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            nextTapped(UIButton())
        }
    }
}
