//
//  CocoaToysConfigManager.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import Combine
import CocoaToysKit
import Cocoa

private final class AppConfigFileChangedSubscription<S: Subscriber>: Subscription where S.Input == Result<URL, ConfigManagerError>, S.Failure == Never {
    final class Presenter: NSObject, NSFilePresenter {
        let presentedItemURL: URL?
        let presentedItemOperationQueue = OperationQueue()
        @CurrentValuePublished(value: nil) var fileDidChange: RelayPublisher<URL?>

        init(presentedItemURL: URL) {
            self.presentedItemURL = presentedItemURL
        }

        func presentedSubitemDidChange(at url: URL) {
            _fileDidChange.send(url)
        }
    }

    private var subscriber: S?
    private let presenter: Presenter
    private var cancellable: Cancellable?

    init(subscriber: S, dir: URL) {
        self.subscriber = subscriber
        presenter = Presenter(presentedItemURL: dir)
        cancellable = presenter.fileDidChange.compactMap { $0 }.sink { [weak self] in
            _ = self?.subscriber?.receive(.success($0))
        }
        NSFileCoordinator.addFilePresenter(presenter)
    }


    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        subscriber = nil
        cancellable?.cancel()
    }

    deinit {
        NSFileCoordinator.removeFilePresenter(presenter)
    }
}

private final class FileChangedPublisher: Publisher {
    typealias Output = Result<URL, ConfigManagerError>
    typealias Failure = Never

    private let dir: URL

    init(dir: URL) {
        self.dir = dir
    }

    func receive<S: Subscriber>(subscriber: S) where S.Input == Output, S.Failure == Never {
        let subscription = AppConfigFileChangedSubscription(subscriber: subscriber, dir: dir)
        subscriber.receive(subscription: subscription)
    }
}

public final class CocoaToysConfigManager: NSObject, ConfigManager {
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let publisher: FileChangedPublisher

    public init(fileManager: FileManager) {
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        self.publisher = FileChangedPublisher(dir: Dependencies.appConfigURL(from: fileManager))
    }

    public func fileChanged<Config: ConfigType>(_ configType: Config.Type) -> AnyPublisher<Result<Config, ConfigManagerError>, Never> {
        publisher
            .map { result in
                switch result {
                case .success(let url):
                    do {
                        let data = try Data(contentsOf: url)
                        return .success(data)
                    } catch {
                        return .failure(.readFailed(error))
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
            .prepend(read(fileName: configType.fileName))
            .map { result in
                switch result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(configType, from: data)
                        return .success(decoded)
                    } catch {
                        return .failure(.decodeFailed(error))
                    }
                case .failure(let error):
                    return .failure(error)
                }
            }
            .removeDuplicates(by: { previous, new in
                guard
                    case .success(let previousConfig) = previous,
                    case .success(let newConfig) = new,
                    previousConfig != newConfig
                else {
                    return true
                }

                return false
            })
            .eraseToAnyPublisher()
    }

    public func save(config: some ConfigType) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let appName = type(of: config).fileName
            do {
                let data = try encoder.encode(config)
                try data.write(to: appConfigURL().appendingPathComponent(appFileName(appName)))
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }

        }
    }

    public func update<Config: ConfigType>(action: @escaping (inout Config) -> Void) async throws {
        try await withCheckedThrowingContinuation { [weak self] (continuation: CheckedContinuation<Void, Error>) in
            guard let self else {
                return
            }
            switch read(Config.self) {
            case .success(let config):
                Task.detached {
                    do {
                        var config = config
                        action(&config)
                        try await self.save(config: config)
                        continuation.resume()
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }

    public func createIfNotExists<Config: ConfigType>(defaultConfig: @autoclosure () -> Config) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                let configURL = appConfigURL()
                if !fileManager.fileExists(atPath: configURL.path) {
                    try fileManager.createDirectory(at: configURL, withIntermediateDirectories: true)
                }

                if !isExists(config: Config.self) {
                    let config = defaultConfig()
                    let data = try encoder.encode(config)
                    let fileName = Config.fileName
                    let path = appConfigURL().appendingPathComponent(appFileName(fileName)).path
                    fileManager.createFile(atPath: path, contents: data)
                }
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    public func isExists<Config: ConfigType>(config: Config.Type) -> Bool {
        let appConfigURL = appConfigURL()
            .appendingPathComponent(appFileName(config.fileName))
        return fileManager.fileExists(atPath: appConfigURL.path)
    }
}

private extension CocoaToysConfigManager {
    func appConfigURL() -> URL {
        Dependencies.appConfigURL(from: fileManager)
    }

    func read(fileName: String) -> Result<Data, ConfigManagerError> {
        let url = appConfigURL().appendingPathComponent(appFileName(fileName))
        do {
            return .success(try Data(contentsOf: url))
        } catch {
            return .failure(.fileNotFound)
        }
    }

    func read<Config: ConfigType>(_ configType: Config.Type) -> Result<Config, ConfigManagerError> {
        do {
            switch read(fileName: Config.fileName) {
            case .success(let data):
                return .success(try JSONDecoder().decode(configType, from: data))
            case .failure(let error):
                return .failure(error)
            }
        } catch {
            return .failure(.decodeFailed(error))
        }
    }
}

private func appConfigURL(from fileManager: FileManager) -> URL {
    fileManager.homeDirectoryForCurrentUser
        .appendingPathComponent(".config")
        .appendingPathComponent("cocoatoys")
}

private func appFileName(_ fileName: String) -> String {
    "\(fileName).json"
}
