import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int 
}

extension FavoriteItem {
    static let btsTracks: [FavoriteItem] = [
        FavoriteItem(title: "Spring Day", subtitle: "You Never Walk Alone · 2017", imageName: "bts1", rating: 5),
        FavoriteItem(title: "Black Swan", subtitle: "Map of the Soul: 7 · 2020", imageName: "bts2", rating: 5),
        FavoriteItem(title: "Blood Sweat & Tears", subtitle: "Wings · 2016", imageName: "bts3", rating: 5),
        FavoriteItem(title: "Mikrokosmos", subtitle: "Map of the Soul: Persona · 2019", imageName: "bts4", rating: 5),
        FavoriteItem(title: "Run BTS", subtitle: "Proof · 2022", imageName: "bts5", rating: 5),
        FavoriteItem(title: "FAKE LOVE", subtitle: "Love Yourself: Tear · 2018", imageName: "bts6", rating: 5),
        FavoriteItem(title: "Life Goes On", subtitle: "BE · 2020", imageName: "bts7", rating: 4),
        FavoriteItem(title: "Pied Piper", subtitle: "Love Yourself: Her · 2017", imageName: "bts8", rating: 5),
        FavoriteItem(title: "Magic Shop", subtitle: "Love Yourself: Tear · 2018", imageName: "bts9", rating: 5),
        FavoriteItem(title: "Louder than bombs", subtitle: "Map of the Soul: 7 · 2020", imageName: "bts10", rating: 4),
        FavoriteItem(title: "Dynamite", subtitle: "Single · 2020", imageName: "bts11", rating: 4),
        FavoriteItem(title: "Butter", subtitle: "Single · 2021", imageName: "bts12", rating: 4),
        FavoriteItem(title: "Anpanman", subtitle: "Love Yourself: Tear · 2018", imageName: "bts13", rating: 4),
        FavoriteItem(title: "Epiphany", subtitle: "Love Yourself: Answer · 2018", imageName: "bts14", rating: 5),
        FavoriteItem(title: "00:00 (Zero O'Clock)", subtitle: "Map of the Soul: 7 · 2020", imageName: "bts15", rating: 5),
        FavoriteItem(title: "Silver Spoon (Baepsae)", subtitle: "The Most Beautiful Moment in Life Pt. 2 · 2015", imageName: "bts16", rating: 5),
        FavoriteItem(title: "Dis-ease", subtitle: "BE · 2020", imageName: "bts17", rating: 5),
        FavoriteItem(title: "Blue & Grey", subtitle: "BE · 2020", imageName: "bts18", rating: 5),
        FavoriteItem(title: "Telepathy", subtitle: "BE · 2020", imageName: "bts19", rating: 4),
        FavoriteItem(title: "Boy With Luv", subtitle: "Map of the Soul: Persona · 2019", imageName: "bts20", rating: 4)
    ]
}
