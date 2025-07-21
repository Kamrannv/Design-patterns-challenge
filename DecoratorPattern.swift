//WITHOUT Strategy Pattern
class RemoteImageLoader: FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        // makes one attempt, no retry
    }
}

func loadWithRetry(loader: RemoteImageLoader, url: URL, maxAttempts: Int) {
    var attempts = 0
    func attempt() {
        attempts += 1
        loader.loadImageData(from: url) { result in
            if case .failure = result, attempts < maxAttempts {
                attempt()
            } else {
                // handle success or final failure
            }
        }
    }
    attempt()
}
//WITH Strategy Pattern
// 1) Component interface
protocol FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

// 2) Concrete component
class RemoteImageLoader: FeedImageDataLoader {
    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        // makes one network request
    }
}

// 3) Decorator
class RetryDecorator: FeedImageDataLoader {
    private let wrapped: FeedImageDataLoader
    private let maxAttempts: Int

    init(wrapped: FeedImageDataLoader, maxAttempts: Int) {
        self.wrapped = wrapped
        self.maxAttempts = maxAttempts
    }

    func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        attempt(1, from: url, completion: completion)
    }

    private func attempt(_ count: Int, from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        wrapped.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success:
                completion(result)
            case .failure where count < self?.maxAttempts ?? 0:
                self?.attempt(count + 1, from: url, completion: completion)
            case .failure:
                completion(result)
            }
        }
    }
}
