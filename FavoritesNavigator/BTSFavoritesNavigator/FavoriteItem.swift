import Foundation

struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String
    let rating: Int
    let description: String
}

extension FavoriteItem {
    static let btsTracks: [FavoriteItem] = [
        FavoriteItem(
            title: "Spring Day",
            subtitle: "You Never Walk Alone · 2017",
            imageName: "bts1",
            rating: 5,
            description: "Spring Day is an emotional alternative hip-hop and pop rock ballad exploring themes of loss, longing, and enduring friendship. Released as the lead single of You Never Walk Alone, it uses the metaphor of a cold winter passing into warm spring. It remains the longest-charting song in MelOn history and a timeless comfort anthem for ARMY."
        ),
        FavoriteItem(
            title: "Black Swan",
            subtitle: "Map of the Soul: 7 · 2020",
            imageName: "bts2",
            rating: 5,
            description: "Inspired by Martha Graham's famous quote, Black Swan delves into an artist's deepest fear of losing their passion for music. The track blends cloud rap trap beats with a hauntingly beautiful lo-fi guitar and traditional Korean gayageum instrumentation. Its contemporary dance choreography showcased a completely new artistic peak for the group."
        ),
        FavoriteItem(
            title: "Blood Sweat & Tears",
            subtitle: "Wings · 2016",
            imageName: "bts3",
            rating: 5,
            description: "Blood Sweat & Tears combines moombahton trap rhythms with classical visual motifs inspired by Hermann Hesse's novel Demian. The song captures the irresistible nature of temptation and the bittersweet pain of growing up. Its museum-set music video broke global records and defined an iconic era in K-pop history."
        ),
        FavoriteItem(
            title: "Mikrokosmos",
            subtitle: "Map of the Soul: Persona · 2019",
            imageName: "bts4",
            rating: 5,
            description: "Mikrokosmos is a soaring synth-pop stadium anthem that celebrates the value of every human life. The lyrics compare each individual to a shining star with their own unique story and light in the night sky. During live stadium tours, this song turned arenas into breathtaking oceans of glowing ARMY Bombs."
        ),
        FavoriteItem(
            title: "Run BTS",
            subtitle: "Proof · 2022",
            imageName: "bts5",
            rating: 5,
            description: "Run BTS is an explosive uptempo hip-hop rock track included on the group's anthology album Proof. It reflects on the seven members' relentless hustle, origins in a small studio, and unbreakable bond over nearly a decade. The fierce choreography quickly became one of the most viral performance stages of their career."
        ),
        FavoriteItem(
            title: "FAKE LOVE",
            subtitle: "Love Yourself: Tear · 2018",
            imageName: "bts6",
            rating: 5,
            description: "FAKE LOVE is an anguished emo hip-hop and grunge rock track about realizing that a love built on self-erasure is destined to crumble. The production features heavy guitar riffs, booming 808 bass, and dramatic vocal delivery from all seven members. It propelled Love Yourself: Tear to become the group's first Billboard 200 number-one album."
        ),
        FavoriteItem(
            title: "Life Goes On",
            subtitle: "BE · 2020",
            imageName: "bts7",
            rating: 4,
            description: "Written during the global slowdown of 2020, Life Goes On is a gentle acoustic hip-hop ballad offering warmth and reassurance. It acknowledges the frustration of sudden isolation while promising that daylight and spring will inevitably return. The song made history as the first predominantly Korean-language track to debut at number one on the Billboard Hot 100."
        ),
        FavoriteItem(
            title: "Pied Piper",
            subtitle: "Love Yourself: Her · 2017",
            imageName: "bts8",
            rating: 5,
            description: "Pied Piper is a groovy disco-synth track written directly for fans who spend hours watching BTS content instead of studying or working. Rather than scolding listeners, the lyrics playfully invite them to follow the sound of the pipe into a safe musical paradise. Its smooth falsetto chorus makes it an undisputed fan-favorite B-side."
        ),
        FavoriteItem(
            title: "Magic Shop",
            subtitle: "Love Yourself: Tear · 2018",
            imageName: "bts9",
            rating: 5,
            description: "Co-produced by Jungkook, Magic Shop takes inspiration from the psychological technique of exchanging fear for positive empathy. The future bass instrumentation builds into a warm, sing-along chorus that feels like a comforting conversation with old friends. It encourages listeners to open a door in their hearts whenever they feel overwhelmed."
        ),
        FavoriteItem(
            title: "Louder than bombs",
            subtitle: "Map of the Soul: 7 · 2020",
            imageName: "bts10",
            rating: 4,
            description: "Co-written with Troye Sivan, Louder than bombs is a dark, atmospheric electro-pop ballad with a heavy, pulsing bassline. It addresses the collective pain and shadows that accompany global fame while promising never to turn away from listeners' sorrow. The dramatic vocal runs and haunting harmonies create an unforgettable listening experience."
        ),
        FavoriteItem(
            title: "Dynamite",
            subtitle: "Single · 2020",
            imageName: "bts11",
            rating: 4,
            description: "Dynamite is an upbeat disco-pop single released to bring joy and vibrant energy to listeners around the world. Packed with funky brass horns, snapping handclaps, and retro synthesizer grooves, it pays homage to classic 1970s music icons. The track earned BTS their first Grammy nomination and topped charts worldwide."
        ),
        FavoriteItem(
            title: "Butter",
            subtitle: "Single · 2021",
            imageName: "bts12",
            rating: 4,
            description: "Butter is a charismatic dance-pop anthem driven by a punchy retro bassline and crisp synth melodies. The playful lyrics showcase the group's smooth charm, confidence, and undeniable stage presence. It spent ten weeks at the top of the Billboard Hot 100 and became a summer phenomenon."
        ),
        FavoriteItem(
            title: "Anpanman",
            subtitle: "Love Yourself: Tear · 2018",
            imageName: "bts13",
            rating: 4,
            description: "Anpanman compares BTS to the relatable superhero who lacks flashy superpowers but gives away pieces of himself to help others. Even though he is weak and falls down, he keeps rising to share strength through music and performance. The energetic stage routines for this track are famous for their infectious joy and teamwork."
        ),
        FavoriteItem(
            title: "Epiphany",
            subtitle: "Love Yourself: Answer · 2018",
            imageName: "bts14",
            rating: 5,
            description: "Performed as a powerful solo ballad by Jin, Epiphany serves as the emotional turning point of the entire Love Yourself series. Accompanied by soaring piano and stadium rock guitars, the lyrics embrace self-acceptance despite imperfections. Its central message reminds listeners that the person they should love most in this world is themselves."
        ),
        FavoriteItem(
            title: "00:00 (Zero O'Clock)",
            subtitle: "Map of the Soul: 7 · 2020",
            imageName: "bts15",
            rating: 5,
            description: "Performed by the vocal line, Zero O'Clock reflects on exhausting days when nothing seems to go right. It focuses on the quiet moment at midnight when the clock resets and a brand-new day begins. The gentle melody reassures listeners that tomorrow brings a fresh start and happiness."
        ),
        FavoriteItem(
            title: "Silver Spoon (Baepsae)",
            subtitle: "The Most Beautiful Moment in Life Pt. 2 · 2015",
            imageName: "bts16",
            rating: 5,
            description: "Silver Spoon uses a traditional Korean proverb about the crow-tit and the stork to critique generational economic inequality. Backed by an aggressive hip-hop beat and energetic horn samples, the members voice the struggles of hardworking youth. It remains one of the sharpest socially conscious tracks in the group's discography."
        ),
        FavoriteItem(
            title: "Dis-ease",
            subtitle: "BE · 2020",
            imageName: "bts17",
            rating: 5,
            description: "Led by j-hope's old-school hip-hop sensibility, Dis-ease plays on the Korean word for workaholism and restlessness. The song examines the anxiety of sudden free time while turning uncertainty into creative resilience. Its bridge builds into one of the most exhilarating vocal and rap climaxes on the BE album."
        ),
        FavoriteItem(
            title: "Blue & Grey",
            subtitle: "BE · 2020",
            imageName: "bts18",
            rating: 5,
            description: "Originally written by V for his mixtape, Blue & Grey is a deeply vulnerable acoustic pop ballad about burnout and melancholy. It visualizes depression and anxiety as cold blue and grey shadows that quietly surround the narrator. Breath-like vocals and fingerpicked guitar strings give the song an intimate, diary-like atmosphere."
        ),
        FavoriteItem(
            title: "Telepathy",
            subtitle: "BE · 2020",
            imageName: "bts19",
            rating: 4,
            description: "Produced by SUGA, Telepathy is a groovy retro funk-disco track bursting with bright synthesizers and slap bass. Despite its cheerful rhythm, the lyrics express how much the members missed meeting fans in person during concert cancellations. It celebrates the invisible telepathic bond that keeps artists and listeners connected across any distance."
        ),
        FavoriteItem(
            title: "Boy With Luv",
            subtitle: "Map of the Soul: Persona · 2019",
            imageName: "bts20",
            rating: 4,
            description: "Boy With Luv is a bright funk-pop anthem that explores finding true strength in small, everyday moments of affection. Serving as a parallel to their 2014 track Boy In Luv, it shows the group's maturity and joyful artistic evolution. Its vibrant pink visual aesthetic and catchy guitar hook made it an instant global smash."
        )
    ]
}
