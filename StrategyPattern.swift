//WITHOUT Strategy Pattern
enum SortType {
    case date, name, size
}

func sortImages(_ images: [Image], by type: SortType) -> [Image] {
    switch type {
    case .date:
        return images.sorted { $0.date < $1.date }
    case .name:
        return images.sorted { $0.name < $1.name }
    case .size:
        return images.sorted { $0.size < $1.size }
    }
}

//WITH Strategy Pattern
// 1) Strategy protocol
protocol SortingStrategy {
    func sort(_ images: [Image]) -> [Image]
}

// 2) Concrete strategies
class DateSortingStrategy: SortingStrategy {
    func sort(_ images: [Image]) -> [Image] {
        images.sorted { $0.date < $1.date }
    }
}

class NameSortingStrategy: SortingStrategy {
    func sort(_ images: [Image]) -> [Image] {
        images.sorted { $0.name < $1.name }
    }
}

class SizeSortingStrategy: SortingStrategy {
    func sort(_ images: [Image]) -> [Image] {
        images.sorted { $0.size < $1.size }
    }
}

// 3) Context
class Gallery {
    private var strategy: SortingStrategy
    
    init(strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func updateStrategy(_ strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func displaySortedImages(_ images: [Image]) {
        let sorted = strategy.sort(images)
        print("Displaying \(sorted.count) sorted images!")
    }
}
