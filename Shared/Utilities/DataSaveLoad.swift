import Foundation

/**
 Extension to save/load a JSON object by filename. (".json" extension is assumed and automatically added.)
 */
extension Data {
    static func delete(filename: String) throws {
        let fm = FileManager.default
        let urls = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let url = urls.first {
            let fileURL = url.appendingPathComponent(filename)
            try fm.removeItem(at: fileURL)
        }
    }
    
    static func load(filename: String) throws -> Data? {
        let fm = FileManager.default
        let urls = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let url = urls.first {
            let fileURL = url.appendingPathComponent(filename)
            let data = try Data(contentsOf: fileURL)
            return data
        }
        return nil
    }
    
    func save(filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        if let url = urls.first {
            try? FileManager.default.createDirectory (at: url, withIntermediateDirectories: true, attributes: nil)
            let fileURL = url.appendingPathComponent(filename)
            try self.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}

