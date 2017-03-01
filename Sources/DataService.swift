import Foundation
import SwiftLMDB

enum Result<Value> {
    case success(Value)
    case failure(Error)

    init(_ value: Value) {
        self = .success(value)
    }

    init(_ error: Error) {
        self = .failure(error)
    }

    init(_ value: Value, _ error: Error?) {
        if let errorValue = error {
            self = .failure(errorValue)
        } else {
            self = .success(value)
        }
    }
}

enum DataServiceError: Error {
    case notFound
    case writeError
}

class DataService {

    let environment: Environment
    let database: Database

    init?(with name: String) {
        do {
            let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
            let libraryURL = URL(fileURLWithPath: paths[0])
            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            let envURL = tempURL.appendingPathComponent("global/")

            print(envURL.path)

            // The folder in which the environment is opened must already exist.
            try FileManager.default.createDirectory(at: envURL, withIntermediateDirectories: true, attributes: nil)

            environment = try Environment(path: envURL.path, flags: [], maxDBs: 32)
            database = try environment.openDatabase(named: name, flags: [.create])
        } catch {
            return nil
        }
    }

    func get(valueOf key: String) -> Result<String> {
        do {
            if let value = try database.get(type: String.self, forKey: key) {
                return Result(value)
            } else {
                return Result(DataServiceError.notFound)
            }
        } catch {
            return Result(DataServiceError.notFound)
        }
    }

    func set(_ value: String, _ key: String) -> Result<String> {
        do {
            try database.put(value: value, forKey: key)
            return Result(key)
        } catch {
            return Result(DataServiceError.writeError)
        }
    }
}
