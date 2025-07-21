//Without Composite
struct AudioFile {
    let name: String
}

struct VideoFile {
    let name: String
}

struct Playlist {
    let name: String
    let items: [Any]
}

func play(_ item: Any) {
    if let audio = item as? AudioFile {
        print("Playing audio: \(audio.name)")
    } else if let video = item as? VideoFile {
        print("Playing video: \(video.name)")
    } else if let playlist = item as? Playlist {
        for i in playlist.items {
            play(i)
        }
    }
}

//With Composite
protocol MediaComponent {
    func play()
}

// 2) Leaf objects
class AudioFile: MediaComponent {
    let name: String
    init(name: String) { self.name = name }
    func play() {
        print("Playing audio: \(name)")
    }
}

class VideoFile: MediaComponent {
    let name: String
    init(name: String) { self.name = name }
    func play() {
        print("Playing video: \(name)")
    }
}

// 3) Composite
class Playlist: MediaComponent {
    let name: String
    var items = [MediaComponent]()
    
    init(name: String) { self.name = name }
    
    func add(_ item: MediaComponent) {
        items.append(item)
    }
    
    func play() {
        print("Playing playlist: \(name)")
        for item in items {
            item.play()
        }
    }
}

//RUN
let song1 = AudioFile(name: "Song A")
let song2 = AudioFile(name: "Song B")
let video1 = VideoFile(name: "Video A")

let playlist1 = Playlist(name: "Morning Mix")
playlist1.add(song1)
playlist1.add(video1)

let playlist2 = Playlist(name: "Workout Mix")
playlist2.add(song2)
playlist2.add(playlist1)  // nested playlist!

playlist2.play()

//OUTPUT
Playing playlist: Workout Mix
Playing audio: Song B
Playing playlist: Morning Mix
Playing audio: Song A
Playing video: Video A
